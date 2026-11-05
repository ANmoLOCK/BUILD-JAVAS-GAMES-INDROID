#!/usr/bin/env python3
"""Build Miami-faithful player_apartment kit from original MN2 sprites.

- Upscales location + furniture GLOBAL sprites (nearest-neighbor ×4)
- Crops largest connected components from sheets
- Installs remastered floor/wall/bath tiles
- Writes manifest mapping item templates → Sprite3D textures
"""
from __future__ import annotations

import json
import shutil
from pathlib import Path

from PIL import Image

ROOT = Path(__file__).resolve().parents[3]  # Miami_2
SPRITES = ROOT / "06-sprites"
GODOT = ROOT / "godot" / "miami3d"
OUT = GODOT / "assets" / "locations" / "player_apartment"
KIT = GODOT / "assets" / "textures" / "kits" / "player_apartment"
ART = Path("/opt/cursor/artifacts/assets")

SCALE = 4
BLACK_THR = 18


def load_rgba(path: Path) -> Image.Image:
    return Image.open(path).convert("RGBA")


def key_black(im: Image.Image) -> Image.Image:
    """Make near-black background transparent (MN2 sheets)."""
    px = im.load()
    w, h = im.size
    for y in range(h):
        for x in range(w):
            r, g, b, a = px[x, y]
            if a < 8 or (r < BLACK_THR and g < BLACK_THR and b < BLACK_THR):
                px[x, y] = (0, 0, 0, 0)
    return im


def connected_crops(im: Image.Image, min_area: int = 80) -> list[Image.Image]:
    """Extract opaque connected components as cropped images (largest first)."""
    w, h = im.size
    px = im.load()
    seen = [[False] * w for _ in range(h)]
    comps: list[tuple[int, int, int, int, int]] = []  # area,x0,y0,x1,y1

    def neighbors(x: int, y: int):
        for dy in (-1, 0, 1):
            for dx in (-1, 0, 1):
                if dx == 0 and dy == 0:
                    continue
                nx, ny = x + dx, y + dy
                if 0 <= nx < w and 0 <= ny < h:
                    yield nx, ny

    for y in range(h):
        for x in range(w):
            if seen[y][x] or px[x, y][3] < 16:
                continue
            stack = [(x, y)]
            seen[y][x] = True
            cells = []
            while stack:
                cx, cy = stack.pop()
                cells.append((cx, cy))
                for nx, ny in neighbors(cx, cy):
                    if not seen[ny][nx] and px[nx, ny][3] >= 16:
                        seen[ny][nx] = True
                        stack.append((nx, ny))
            xs = [c[0] for c in cells]
            ys = [c[1] for c in cells]
            area = len(cells)
            if area >= min_area:
                comps.append((area, min(xs), min(ys), max(xs) + 1, max(ys) + 1))
    comps.sort(reverse=True)
    out = []
    for _a, x0, y0, x1, y1 in comps:
        out.append(im.crop((x0, y0, x1, y1)))
    return out


def upscale(im: Image.Image) -> Image.Image:
    return im.resize((im.width * SCALE, im.height * SCALE), Image.NEAREST)


def save_item(name: str, im: Image.Image, meta: dict) -> dict:
    im = key_black(im.copy())
    orig_dir = OUT / "original"
    x4_dir = OUT / "items"
    orig_dir.mkdir(parents=True, exist_ok=True)
    x4_dir.mkdir(parents=True, exist_ok=True)
    o = orig_dir / f"{name}.png"
    x = x4_dir / f"{name}.png"
    im.save(o)
    u = upscale(im)
    u.save(x)
    entry = {
        "id": name,
        "original": f"res://assets/locations/player_apartment/original/{name}.png",
        "x4": f"res://assets/locations/player_apartment/items/{name}.png",
        "size": list(im.size),
        "size_x4": list(u.size),
        **meta,
    }
    return entry


def pick_nth(path: Path, index: int = 0, min_area: int = 80) -> Image.Image:
    im = key_black(load_rgba(path))
    crops = connected_crops(im, min_area=min_area)
    if not crops:
        return im
    idx = min(index, len(crops) - 1)
    return crops[idx]


def install_tiles() -> dict:
    tiles_dir = OUT / "tiles"
    tiles_dir.mkdir(parents=True, exist_ok=True)
    KIT.mkdir(parents=True, exist_ok=True)

    mapping = {
        "floor": ART / "apt-floor-miami-wood.jpg",
        "wall": ART / "apt-wall-miami-cream.jpg",
        "bath": ART / "apt-bath-tile-miami.jpg",
    }
    # fallbacks already generated procedurally
    fallbacks = {
        "floor": tiles_dir / "floor_wood.png",
        "wall": tiles_dir / "wall_paint.png",
        "bath": tiles_dir / "bath_tile.png",
    }
    out = {}
    for kind, src in mapping.items():
        dst = tiles_dir / f"{kind}.png"
        if src.exists():
            im = Image.open(src).convert("RGBA")
            # normalize to 256 for tiling
            im = im.resize((256, 256), Image.LANCZOS)
            im.save(dst)
        elif fallbacks[kind].exists():
            shutil.copy(fallbacks[kind], dst)
        else:
            continue
        out[kind] = f"res://assets/locations/player_apartment/tiles/{kind}.png"
        if kind == "floor":
            shutil.copy(dst, KIT / "albedo.png")
        if kind == "wall":
            shutil.copy(dst, KIT / "wall.png")
        if kind == "bath":
            shutil.copy(dst, KIT / "bath.png")
    return out


def main() -> None:
    OUT.mkdir(parents=True, exist_ok=True)
    items: dict = {}

    # --- LOW apartment location pack ---
    low = SPRITES / "25_RES_LOCATION_LOWAPARTMENTA_SPRITES"
    loc_map = {
        "tv": ("0554", 0, 200),
        "window": ("0555", 0, 200),
        "closet": ("0556", 0, 80),
        "stove": ("0552", 0, 80),
        "table": ("0562", 0, 120),
        "shelf": ("0560", 0, 200),
        "poster": ("0563", 0, 80),
        "railing": ("0565", 0, 120),
        "wall_tile_sheet": ("0559", 0, 200),
    }
    for name, (sid, idx, mina) in loc_map.items():
        path = low / f"{sid}_sprite_frames_pal0.png"
        if not path.exists():
            print("missing", path)
            continue
        im = pick_nth(path, idx, mina)
        items[name] = save_item(name, im, {"source": f"LOWAPARTMENTA/{sid}", "sprite_id": sid})

    # --- GLOBAL furniture ---
    sources = {
        "bed_standard": (SPRITES / "07_RES_GLOBAL_SPRITES" / "0248_sprite_frames_pal0.png", 0, 400),
        "sofa_basic": (SPRITES / "08_RES_GLOBAL_1_SPRITES" / "0264_sprite_frames_pal1.png", 2, 400),  # orange straight
        "sofa_curved": (SPRITES / "08_RES_GLOBAL_1_SPRITES" / "0264_sprite_frames_pal1.png", 1, 400),
        "chair": (SPRITES / "08_RES_GLOBAL_1_SPRITES" / "0264_sprite_frames_pal1.png", 3, 100),
        "fridge": (SPRITES / "11_RES_GLOBAL_4_SPRITES" / "0320_sprite_frames_pal0.png", 0, 200),
        "kitchen_cabinet": (SPRITES / "07_RES_GLOBAL_SPRITES" / "0252_sprite_frames_pal0.png", 3, 300),
        "toilet": (SPRITES / "09_RES_GLOBAL_2_SPRITES" / "0287_sprite_frames_pal0.png", 0, 80),
        "shower": (SPRITES / "09_RES_GLOBAL_2_SPRITES" / "0288_sprite_frames_pal0.png", 0, 200),
        "plant": (SPRITES / "07_RES_GLOBAL_SPRITES" / "0259_sprite_frames_pal0.png", 0, 80),
        "glass_table": (SPRITES / "08_RES_GLOBAL_1_SPRITES" / "0269_sprite_frames_pal0.png", 0, 100),
        "door": (SPRITES / "10_RES_GLOBAL_3_SPRITES" / "0311_sprite_frames_pal0.png", 0, 200),
        "mirror": (SPRITES / "09_RES_GLOBAL_2_SPRITES" / "0285_sprite_frames_pal0.png", 0, 40),
    }
    for name, (path, idx, mina) in sources.items():
        if not path.exists():
            print("missing", path)
            continue
        im = pick_nth(path, idx, mina)
        items[name] = save_item(
            name,
            im,
            {"source": str(path.relative_to(SPRITES)), "crop_index": idx},
        )

    # sink: use toilet sheet brush/holder area or mirror as stand-in vanity → crop 2nd from toilet sheet
    sink_path = SPRITES / "09_RES_GLOBAL_2_SPRITES" / "0287_sprite_frames_pal0.png"
    if sink_path.exists():
        # try a wider bathroom vanity from 0286 if available
        alt = SPRITES / "09_RES_GLOBAL_2_SPRITES" / "0286_sprite_frames_pal0.png"
        path = alt if alt.exists() else sink_path
        im = pick_nth(path, 0, 40)
        items["sink"] = save_item("sink", im, {"source": str(path.relative_to(SPRITES))})

    # phone / computer / plant fallbacks from small deco if missing
    if "plant" not in items and (OUT / "original" / "deco_c_0551.png").exists():
        pass

    tiles = install_tiles()

    # template → item sprite id
    template_map = {
        "bed_standard": "bed_standard",
        "bed_1": "bed_standard",
        "bed_2": "bed_standard",
        "bed_3": "bed_standard",
        "sofa_basic": "sofa_basic",
        "sofa_1": "sofa_basic",
        "sofa_2": "sofa_curved",
        "sofa_3": "sofa_basic",
        "tv": "tv",
        "closet": "closet",
        "fridge": "fridge",
        "kitchen": "stove",
        "stove": "stove",
        "table": "table",
        "chair": "chair",
        "toilet": "toilet",
        "shower": "shower",
        "sink": "sink",
        "plant": "plant",
        "phone": "poster",
        "computer": "tv",
        "window": "window",
        "shelf": "shelf",
        "door": "door",
        "railing": "railing",
    }

    manifest = {
        "location": "player_apartment",
        "style": "miami_iso_sprites",
        "scale": SCALE,
        "source_packs": [
            "25_RES_LOCATION_LOWAPARTMENTA_SPRITES",
            "07_RES_GLOBAL_SPRITES",
            "08_RES_GLOBAL_1_SPRITES",
            "09_RES_GLOBAL_2_SPRITES",
            "11_RES_GLOBAL_4_SPRITES",
        ],
        "tiles": tiles,
        "items": items,
        "template_map": template_map,
        "pixel_snap": True,
        "sprite3d": {
            "billboard": "disabled",
            "pixel_size": 0.012,
            "shaded": False,
            "alpha_cut": "discard",
        },
    }
    (OUT / "manifest.json").write_text(json.dumps(manifest, indent=2, ensure_ascii=False) + "\n")
    print("items", len(items), "tiles", list(tiles.keys()))
    for k, v in items.items():
        print(" ", k, v["size"], "->", v["size_x4"])


if __name__ == "__main__":
    main()
