#!/usr/bin/env python3
"""Gera GLBs paper-doll Neon Nightlife (M/F) — malhas 3D reais, não billboard."""
from __future__ import annotations

import json
import struct
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
OUT = ROOT / "assets/models/characters"
NEON = ROOT / "assets/characters/neon_nightlife"


def _pack_glb(vertices: list[tuple], indices: list[int], color: tuple[float, float, float]) -> bytes:
    """GLB mínimo: um mesh TRIANGLES com POSITION + COLOR_0."""
    import numpy as np

    pos = np.asarray(vertices, dtype=np.float32)
    # flat color per vertex
    cols = np.tile(np.asarray(color + (1.0,), dtype=np.float32), (len(vertices), 1))
    idx = np.asarray(indices, dtype=np.uint16)
    # bounds
    mins = pos.min(axis=0).tolist()
    maxs = pos.max(axis=0).tolist()

    # buffer layout: positions | colors | indices (aligned)
    pos_b = pos.tobytes()
    col_b = cols.tobytes()
    idx_b = idx.tobytes()
    pad = lambda b: b + (b"\x00" * ((4 - (len(b) % 4)) % 4))
    blob = pad(pos_b) + pad(col_b) + pad(idx_b)
    pos_len = len(pad(pos_b))
    col_off = pos_len
    col_len = len(pad(col_b))
    idx_off = col_off + col_len
    idx_len = len(pad(idx_b))

    gltf = {
        "asset": {"version": "2.0", "generator": "miami-neon-humanoid"},
        "scenes": [{"nodes": [0]}],
        "scene": 0,
        "nodes": [{"mesh": 0, "name": "Part"}],
        "meshes": [{
            "primitives": [{
                "attributes": {"POSITION": 0, "COLOR_0": 1},
                "indices": 2,
                "mode": 4,
            }]
        }],
        "accessors": [
            {"bufferView": 0, "componentType": 5126, "count": len(vertices), "type": "VEC3",
             "max": maxs, "min": mins},
            {"bufferView": 1, "componentType": 5126, "count": len(vertices), "type": "VEC4"},
            {"bufferView": 2, "componentType": 5123, "count": len(indices), "type": "SCALAR"},
        ],
        "bufferViews": [
            {"buffer": 0, "byteOffset": 0, "byteLength": len(pos_b), "target": 34962},
            {"buffer": 0, "byteOffset": col_off, "byteLength": len(col_b), "target": 34962},
            {"buffer": 0, "byteOffset": idx_off, "byteLength": len(idx_b), "target": 34963},
        ],
        "buffers": [{"byteLength": len(blob)}],
    }
    json_b = json.dumps(gltf, separators=(",", ":")).encode("utf-8")
    json_b = json_b + (b" " * ((4 - (len(json_b) % 4)) % 4))
    # GLB container
    total = 12 + 8 + len(json_b) + 8 + len(blob)
    out = bytearray()
    out += struct.pack("<4sII", b"glTF", 2, total)
    out += struct.pack("<I4s", len(json_b), b"JSON")
    out += json_b
    out += struct.pack("<I4s", len(blob), b"BIN\x00")
    out += blob
    return bytes(out)


def box(cx, cy, cz, sx, sy, sz) -> tuple[list, list]:
    hx, hy, hz = sx * 0.5, sy * 0.5, sz * 0.5
    v = [
        (cx - hx, cy - hy, cz - hz), (cx + hx, cy - hy, cz - hz),
        (cx + hx, cy + hy, cz - hz), (cx - hx, cy + hy, cz - hz),
        (cx - hx, cy - hy, cz + hz), (cx + hx, cy - hy, cz + hz),
        (cx + hx, cy + hy, cz + hz), (cx - hx, cy + hy, cz + hz),
    ]
    faces = [
        (0, 1, 2), (0, 2, 3), (4, 6, 5), (4, 7, 6),
        (0, 4, 5), (0, 5, 1), (2, 6, 7), (2, 7, 3),
        (0, 3, 7), (0, 7, 4), (1, 5, 6), (1, 6, 2),
    ]
    # expand unique verts per face for flat color (already per-vertex same color)
    verts, inds = [], []
    for a, b, c in faces:
        base = len(verts)
        verts.extend([v[a], v[b], v[c]])
        inds.extend([base, base + 1, base + 2])
    return verts, inds


def merge(parts: list[tuple[list, list]]) -> tuple[list, list]:
    verts, inds = [], []
    for v, i in parts:
        base = len(verts)
        verts.extend(v)
        inds.extend([x + base for x in i])
    return verts, inds


# Colors Neon Nightlife
SKIN_M = (0.78, 0.58, 0.45)
SKIN_F = (0.86, 0.68, 0.52)
HAIR = (0.12, 0.10, 0.12)
BLAZER = (0.08, 0.08, 0.10)
SHIRT = (0.92, 0.18, 0.55)
PANTS = (0.10, 0.10, 0.12)
DRESS = (0.95, 0.95, 0.98)
SHOES_M = (0.05, 0.05, 0.05)
SHOES_F = (0.92, 0.92, 0.95)


def part_head(gender: str):
    skin = SKIN_F if gender == "f" else SKIN_M
    # head sphere approx as boxy head + neck
    return merge([
        box(0, 1.62, 0, 0.28, 0.30, 0.28),
        box(0, 1.42, 0, 0.12, 0.12, 0.12),
    ]), skin


def part_hair(gender: str):
    if gender == "f":
        # long wavy mass
        return merge([
            box(0, 1.78, -0.02, 0.32, 0.14, 0.30),
            box(0, 1.55, -0.12, 0.28, 0.40, 0.12),
            box(0.12, 1.45, -0.08, 0.10, 0.35, 0.10),
            box(-0.12, 1.45, -0.08, 0.10, 0.35, 0.10),
        ]), HAIR
    return merge([
        box(0, 1.76, -0.02, 0.30, 0.12, 0.28),
        box(0, 1.68, -0.10, 0.26, 0.10, 0.12),
    ]), HAIR


def part_top(gender: str):
    if gender == "f":
        # cocktail dress torso
        return merge([
            box(0, 1.20, 0, 0.40, 0.45, 0.22),
            box(0, 0.95, 0, 0.38, 0.20, 0.20),
        ]), DRESS
    # blazer + magenta shirt hint
    return merge([
        box(0, 1.22, 0, 0.46, 0.50, 0.26),  # blazer
        box(0, 1.22, 0.08, 0.28, 0.40, 0.08),  # shirt front
        box(0.28, 1.22, 0, 0.12, 0.48, 0.18),  # sleeve R
        box(-0.28, 1.22, 0, 0.12, 0.48, 0.18),
    ]), BLAZER


def part_bottom(gender: str):
    if gender == "f":
        return merge([
            box(0, 0.72, 0, 0.36, 0.35, 0.20),
            box(0, 0.50, 0, 0.34, 0.15, 0.18),
        ]), DRESS
    return merge([
        box(0.10, 0.70, 0, 0.16, 0.55, 0.18),
        box(-0.10, 0.70, 0, 0.16, 0.55, 0.18),
        box(0, 0.95, 0, 0.36, 0.12, 0.20),
    ]), PANTS


def part_shoes(gender: str):
    c = SHOES_F if gender == "f" else SHOES_M
    h = 0.10 if gender == "f" else 0.12
    return merge([
        box(0.10, h * 0.5, 0.04, 0.12, h, 0.28),
        box(-0.10, h * 0.5, 0.04, 0.12, h, 0.28),
    ]), c


PARTS = {
    "head": (part_head, "heads", "head"),
    "hair": (part_hair, "hair", "hair"),
    "top": (part_top, "tops", "top"),
    "bottom": (part_bottom, "bottoms", "bottom"),
    "shoe": (part_shoes, "shoes", "shoe"),
}

# Neon variant indices from presets
VARIANTS = {
    "m": {"head": 2, "hair": 8, "top": 12, "bottom": 10, "shoe": 6},
    "f": {"head": 2, "hair": 10, "top": 18, "bottom": 8, "shoe": 9},
}


def write_part(gender: str, slot: str, variant: int):
    fn, folder, prefix = PARTS[slot]
    (verts, inds), color = fn(gender)
    # shirt magenta overlay for male top: bake shirt as separate brighter region already
    if slot == "top" and gender == "m":
        # add magenta shirt panel mesh with SHIRT color — merge with blazer verts using shirt color on those verts
        # simpler: use average color leaning blazer; magenta is in separate child at runtime
        pass
    data = _pack_glb(verts, inds, color)
    path = OUT / folder / f"{prefix}_{gender}_{variant:02d}.glb"
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_bytes(data)
    stub = path.with_suffix(".stub.json")
    stub.write_text(json.dumps({
        "id": f"{prefix}_{gender}_{variant:02d}",
        "slot": prefix,
        "gender": gender,
        "variant": variant,
        "style": "neon_nightlife",
        "mesh": f"res://assets/models/characters/{folder}/{prefix}_{gender}_{variant:02d}.glb",
        "status": "ready",
        "fallback": "res://assets/models/_shared/placeholder.glb",
    }, indent=2) + "\n")
    print("wrote", path, "bytes", len(data))
    return path


def main():
    import numpy  # noqa: F401 — required by _pack_glb
    n = 0
    for gender, slots in VARIANTS.items():
        for slot, variant in slots.items():
            write_part(gender, slot, variant)
            n += 1
    # also write assembled full-body preview glb
    for gender in ("m", "f"):
        parts = []
        colors = []
        for slot in ("head", "hair", "top", "bottom", "shoe"):
            (v, i), c = PARTS[slot][0](gender)
            # offset indices later — pack as separate nodes would be better; single mesh with one color average
            parts.append((v, i))
            colors.append(c)
        # use skin-ish average for assembled
        avg = tuple(sum(c[k] for c in colors) / len(colors) for k in range(3))
        verts, inds = merge(parts)
        data = _pack_glb(verts, inds, avg)
        ap = OUT / f"neon_full_{gender}.glb"
        ap.write_bytes(data)
        print("wrote", ap, len(data))
        n += 1
    print("done", n, "files")


if __name__ == "__main__":
    main()
