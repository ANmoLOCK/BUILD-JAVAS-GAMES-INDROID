#!/usr/bin/env python3
"""Gera texturas/kits simples + JSON de mapa enriquecido a partir da ER (sala 14 / 00)."""
from __future__ import annotations

import json
import struct
import zlib
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
CONTENT = ROOT / "content/locations"
TEX = ROOT / "assets/textures/kits"


def write_png(path: Path, w: int, h: int, rgba_fn):
    """PNG RGB sem dependências — filtro None."""
    raw = bytearray()
    for y in range(h):
        raw.append(0)
        for x in range(w):
            r, g, b, a = rgba_fn(x, y, w, h)
            raw += bytes((r, g, b, a))
    comp = zlib.compress(bytes(raw), 9)

    def chunk(tag: bytes, data: bytes) -> bytes:
        return struct.pack(">I", len(data)) + tag + data + struct.pack(">I", zlib.crc32(tag + data) & 0xFFFFFFFF)

    ihdr = struct.pack(">IIBBBBB", w, h, 8, 6, 0, 0, 0)
    png = b"\x89PNG\r\n\x1a\n" + chunk(b"IHDR", ihdr) + chunk(b"IDAT", comp) + chunk(b"IEND", b"")
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_bytes(png)
    print("png", path, w, h)


def floor_apartment(x, y, w, h):
    # wood plank
    plank = ((y // 8) % 2)
    base = 140 + plank * 20
    noise = ((x * 17 + y * 13) % 11)
    r = min(255, base + 30 + noise)
    g = min(255, base + 10 + noise // 2)
    b = min(255, base - 20)
    # rug stripe
    if 40 < x < w - 40 and 40 < y < h - 40 and (x + y) % 37 < 3:
        return (180, 60, 90, 255)
    return (r, g, b, 255)


def floor_street(x, y, w, h):
    # asphalt + sidewalk bands
    cy = y / max(1, h - 1)
    cx = x / max(1, w - 1)
    # road in middle
    if 0.35 < cy < 0.65:
        g = 45 + ((x // 16) % 2) * 8
        # lane dash
        if abs(cy - 0.5) < 0.01 and (x // 12) % 2 == 0:
            return (220, 200, 80, 255)
        return (g, g, g + 5, 255)
    # sidewalk
    g = 150 + ((x + y) // 8 % 2) * 15
    return (g, g - 5, g - 10, 255)


def enrich_apartment():
    path = CONTENT / "player_apartment.json"
    d = json.loads(path.read_text())
    # more interactive objects inspired by ER room 14 (LOW apartment)
    extras = [
        {"id": "bed_player", "template": "bed_standard", "cell": [8, 3], "facing": "S"},
        {"id": "sofa_living", "template": "sofa_basic", "cell": [3, 12], "facing": "E"},
        {"id": "tv_stand", "template": "tv", "cell": [1, 12], "facing": "E"},
        {"id": "fridge_kit", "template": "fridge", "cell": [10, 14], "facing": "W"},
        {"id": "stove_kit", "template": "kitchen", "cell": [10, 16], "facing": "W"},
        {"id": "table_dining", "template": "table", "cell": [6, 14], "facing": "N"},
        {"id": "chair_1", "template": "chair", "cell": [5, 14], "facing": "E"},
        {"id": "chair_2", "template": "chair", "cell": [8, 14], "facing": "W"},
        {"id": "closet_main", "template": "closet", "cell": [11, 3], "facing": "W"},
        {"id": "shower_bath", "template": "shower", "cell": [2, 2], "facing": "S"},
        {"id": "toilet_bath", "template": "toilet", "cell": [1, 5], "facing": "E"},
        {"id": "sink_bath", "template": "sink", "cell": [3, 5], "facing": "N"},
        {"id": "plant_corner", "template": "plant", "cell": [12, 12], "facing": "S"},
        {"id": "computer_desk", "template": "computer", "cell": [1, 8], "facing": "E"},
    ]
    existing = {o["id"] for o in d.get("objects", [])}
    for o in extras:
        if o["id"] not in existing:
            d.setdefault("objects", []).append(o)
    # interior walls (rooms) — bathroom / kitchen divider from ER LOW apt spirit
    blocked = d.get("blocked", [])
    more_walls = [
        [0, 7, 5, 1],   # bathroom south wall
        [4, 7, 1, 3],
        [9, 12, 1, 6],  # kitchen west
    ]
    for w in more_walls:
        if w not in blocked:
            blocked.append(w)
    d["blocked"] = blocked
    d["visual"] = {
        "kit": "player_apartment",
        "floor_tex": "res://assets/textures/kits/player_apartment/albedo.png",
        "wall_color": [0.55, 0.48, 0.42],
        "neon_trim": False,
        "style": "miami_low_apt_remaster",
    }
    path.write_text(json.dumps(d, indent=2, ensure_ascii=False) + "\n")
    print("enriched", path)


def enrich_first_street():
    path = CONTENT / "first_street.json"
    d = json.loads(path.read_text())
    # buildings as blocked rects (facades) — inspired by First Street ER density
    blocked = d.setdefault("blocked", [])
    buildings = [
        [5, 5, 14, 10],    # west block
        [5, 50, 18, 12],
        [55, 5, 20, 14],   # east block
        [58, 48, 16, 14],
        [30, 2, 20, 6],    # north shops
    ]
    for b in buildings:
        if b not in blocked:
            blocked.append(b)
    extras = [
        {"id": "street_lamp_1", "template": "street_lamp", "cell": [20, 32], "facing": "S"},
        {"id": "street_lamp_2", "template": "street_lamp", "cell": [45, 32], "facing": "S"},
        {"id": "street_lamp_3", "template": "street_lamp", "cell": [60, 40], "facing": "S"},
        {"id": "newsstand_1", "template": "newsstand", "cell": [28, 31], "facing": "S"},
        {"id": "car_parked_1", "template": "car_parked", "cell": [35, 38], "facing": "E"},
        {"id": "car_parked_2", "template": "car_parked", "cell": [50, 38], "facing": "W"},
        {"id": "palm_1", "template": "palm_tree", "cell": [18, 28], "facing": "S"},
        {"id": "palm_2", "template": "palm_tree", "cell": [48, 28], "facing": "S"},
        {"id": "palm_3", "template": "palm_tree", "cell": [65, 45], "facing": "S"},
        {"id": "bench_2", "template": "bench", "cell": [33, 33], "facing": "S"},
        {"id": "bench_3", "template": "bench", "cell": [55, 42], "facing": "W"},
        {"id": "hydrant_1", "template": "hydrant", "cell": [24, 33], "facing": "S"},
        {"id": "shop_sign_1", "template": "shop_sign", "cell": [32, 9], "facing": "S"},
    ]
    existing = {o["id"] for o in d.get("objects", [])}
    for o in extras:
        if o["id"] not in existing:
            d.setdefault("objects", []).append(o)
    d["visual"] = {
        "kit": "first_street",
        "floor_tex": "res://assets/textures/kits/first_street/albedo.png",
        "wall_color": [0.75, 0.72, 0.68],
        "sky": "miami_dusk",
        "style": "first_street_remaster",
    }
    # keep apartment portal reachable — ensure not inside blocked
    path.write_text(json.dumps(d, indent=2, ensure_ascii=False) + "\n")
    print("enriched", path)


def main():
    write_png(TEX / "player_apartment/albedo.png", 256, 256, floor_apartment)
    write_png(TEX / "first_street/albedo.png", 512, 512, floor_street)
    enrich_apartment()
    enrich_first_street()


if __name__ == "__main__":
    main()
