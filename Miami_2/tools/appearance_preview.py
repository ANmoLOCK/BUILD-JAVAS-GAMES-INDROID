#!/usr/bin/env python3
"""Preview PNG do vetor paper-doll (10 ints) — mesma paleta do MnPaperDoll.

Vetor: [gênero, pele, cabelo, corCabelo, top, corTop, bottom, corBottom, calçado, corCalçado]

Uso:
  python3 tools/appearance_preview.py --vector 0,1,3,2,4,1,2,0,1,3 -o /tmp/doll.png
  python3 tools/appearance_preview.py --npc landlord
  python3 tools/appearance_preview.py --gallery -o godot/miami3d/assets/ui/previews/
"""
from __future__ import annotations

import argparse
import json
import re
import struct
import zlib
from pathlib import Path

HERE = Path(__file__).resolve().parent
MIAMI2 = HERE.parent
CONTENT_NPCS = MIAMI2 / "godot/miami3d/content/npcs"

# Espelha MnPaperDoll.PALETTE
PALETTE = [
    (235, 199, 168),
    (184, 133, 97),
    (115, 77, 51),
    (51, 38, 31),
    (242, 230, 217),
    (140, 102, 140),
]

# cores extras para roupa
CLOTH = [
    (40, 70, 140), (180, 50, 60), (40, 120, 70), (200, 180, 60),
    (90, 90, 100), (220, 220, 220), (20, 20, 20), (160, 100, 40),
]


def clamp_idx(i: int, n: int) -> int:
    return max(0, min(n - 1, i))


def png_rgba(w: int, h: int, pixels: list[tuple[int, int, int, int]]) -> bytes:
    raw = bytearray()
    for y in range(h):
        raw.append(0)
        for x in range(w):
            raw.extend(pixels[y * w + x])
    compressed = zlib.compress(bytes(raw), 9)

    def chunk(tag: bytes, data: bytes) -> bytes:
        return struct.pack(">I", len(data)) + tag + data + struct.pack(">I", zlib.crc32(tag + data) & 0xFFFFFFFF)

    ihdr = struct.pack(">IIBBBBB", w, h, 8, 6, 0, 0, 0)
    return b"\x89PNG\r\n\x1a\n" + chunk(b"IHDR", ihdr) + chunk(b"IDAT", compressed) + chunk(b"IEND", b"")


def fill_rect(buf, w, h, x0, y0, rw, rh, rgba):
    for y in range(max(0, y0), min(h, y0 + rh)):
        for x in range(max(0, x0), min(w, x0 + rw)):
            buf[y * w + x] = rgba


def render_doll(vector: list[int], scale: int = 8) -> bytes:
    """Boneco modular 2D estilo paper-doll (vista 3/4 simplificada)."""
    while len(vector) < 10:
        vector.append(0)
    gender = "m" if int(vector[0]) == 0 else "f"
    skin = PALETTE[clamp_idx(int(vector[1]), len(PALETTE))]
    hair_c = PALETTE[clamp_idx(int(vector[3]), len(PALETTE))]
    top_c = CLOTH[clamp_idx(int(vector[5]), len(CLOTH))]
    bottom_c = CLOTH[clamp_idx(int(vector[7]), len(CLOTH))]
    shoe_c = CLOTH[clamp_idx(int(vector[9]), len(CLOTH))]

    # canvas lógico 32×48 → scale
    lw, lh = 32, 48
    w, h = lw * scale, lh * scale
    bg = (30, 40, 55, 255)
    buf = [bg] * (w * h)

    def R(x, y, rw, rh, rgb, a=255):
        fill_rect(buf, w, h, x * scale, y * scale, rw * scale, rh * scale, (*rgb, a))

    # sombra
    R(8, 44, 16, 3, (20, 20, 30))
    # pernas / bottom
    R(10, 28, 5, 12, bottom_c)
    R(17, 28, 5, 12, bottom_c)
    # tronco / top
    tw = 14 if gender == "m" else 12
    R(16 - tw // 2, 16, tw, 13, top_c)
    # braços
    R(16 - tw // 2 - 3, 17, 3, 10, skin)
    R(16 + tw // 2, 17, 3, 10, skin)
    # cabeça
    R(12, 6, 8, 8, skin)
    # cabelo
    hair_h = 4 + clamp_idx(int(vector[2]), 6)
    R(11, 4, 10, hair_h, hair_c)
    if gender == "f":
        R(10, 8, 2, 8, hair_c)
        R(20, 8, 2, 8, hair_c)
    # sapatos
    R(9, 40, 6, 3, shoe_c)
    R(17, 40, 6, 3, shoe_c)
    # olhos
    R(14, 9, 1, 1, (20, 20, 20))
    R(17, 9, 1, 1, (20, 20, 20))

    return png_rgba(w, h, buf)


def parse_vector(s: str) -> list[int]:
    parts = re.split(r"[,\s]+", s.strip())
    return [int(p) for p in parts if p != ""]


def load_npc_vector(npc_id: str) -> tuple[list[int], str]:
    path = CONTENT_NPCS / f"{npc_id}.json"
    if not path.exists():
        # generics file
        gen = CONTENT_NPCS / "generics.json"
        if gen.exists():
            for n in json.loads(gen.read_text(encoding="utf-8")):
                if n.get("id") == npc_id:
                    return list(n.get("appearance", [0] * 10)), str(n.get("gender", "m"))
        raise SystemExit(f"NPC não encontrado: {npc_id}")
    data = json.loads(path.read_text(encoding="utf-8"))
    return list(data.get("appearance", [0] * 10)), str(data.get("gender", "m"))


def main() -> int:
    ap = argparse.ArgumentParser(description="Preview paper-doll")
    ap.add_argument("--vector", type=str, default=None, help="10 ints separados por vírgula")
    ap.add_argument("--npc", type=str, default=None, help="id de NPC em content/npcs")
    ap.add_argument("--gallery", action="store_true", help="gera previews do elenco essencial")
    ap.add_argument("-o", "--output", type=Path, default=Path("appearance_preview.png"))
    ap.add_argument("--scale", type=int, default=8)
    args = ap.parse_args()

    if args.gallery:
        out_dir = args.output if args.output.suffix == "" else args.output.parent / "previews"
        out_dir.mkdir(parents=True, exist_ok=True)
        count = 0
        for p in sorted(CONTENT_NPCS.glob("*.json")):
            if p.name == "generics.json":
                continue
            data = json.loads(p.read_text(encoding="utf-8"))
            if not data.get("essential", True) and p.stem not in ("landlord", "heather", "scott"):
                # ainda assim gera elenco com arquivo próprio
                pass
            vec = list(data.get("appearance", [0] * 10))
            if data.get("gender") == "f" and (not vec or vec[0] == 0):
                vec = [1] + vec[1:]
                while len(vec) < 10:
                    vec.append(0)
            png = render_doll(vec, args.scale)
            (out_dir / f"{data['id']}.png").write_bytes(png)
            count += 1
        print(f"OK gallery {count} → {out_dir}")
        return 0

    if args.npc:
        vec, gender = load_npc_vector(args.npc)
        if gender == "f":
            vec[0] = 1
        label = args.npc
    elif args.vector:
        vec = parse_vector(args.vector)
        label = "custom"
    else:
        vec = [0, 1, 2, 2, 3, 1, 2, 0, 1, 3]
        label = "default"

    png = render_doll(vec, args.scale)
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_bytes(png)
    print(f"OK {label} vector={vec} → {args.output} ({len(png)} bytes)")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
