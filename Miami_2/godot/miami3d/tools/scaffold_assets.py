#!/usr/bin/env python3
"""Cria a árvore assets/ do Miami 3D: pastas, manifests, ícones PNG mínimos,
áudio stub e um GLB placeholder compartilhado. Não copia arte Gameloft."""

from __future__ import annotations

import json
import struct
import zlib
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]  # miami3d/
ASSETS = ROOT / "assets"
CONTENT = ROOT / "content"

REGIONS = [
    "downtown", "south_beach", "little_havana", "ocean_drive",
    "coconut_grove", "miami_beach", "pelican_island", "key_biscayne", "everglades",
]

LOCATIONS = [
    "first_street", "police_station", "glight_club", "newspaper_office", "stadium",
    "beauty_clinic", "heather_dean_apartment", "grand_avenue", "lounge", "south_beach",
    "cuban_cafe", "little_havana", "yuca_restaurant", "ocean_drive", "player_apartment",
    "pelican_port", "yacht", "everglades", "mansion", "downtown", "coconut_grove",
    "npc_apartment", "miami_beach", "pelican_island", "key_biscayne", "apartment_garden",
]

STORY_NPC_HEADS = [
    "landlord", "goldsax", "sanchez", "dean", "heather", "scott", "callie",
    "danny", "amy", "beatrice", "inspector", "hal_pachinko", "dj", "spillbeard",
    "opal", "charm", "guard", "captain", "nip", "took", "mortadella", "doctor",
    "security", "huggy", "john_plumber", "coco", "boss", "pet_shop_boy",
    "xavier", "elizabeth", "shaman", "mia",
]

ANIM_CLIPS = [
    "idle", "walk", "run", "sit", "sleep", "eat", "drink",
    "dance_techno", "dance_salsa", "dance_pop", "dance_metal",
    "kiss", "fight", "faint", "swim", "piano", "lift", "sweep", "cook",
    "work_bar", "work_poster", "work_delivery", "work_extra",
    "pee", "shower", "wave", "talk", "laugh", "angry", "use", "give",
]

AUDIO_MUSIC = [
    "title", "apartment_calm", "downtown_day", "beach_day", "club_night",
    "police_tension", "victory", "defeat", "dance_techno", "dance_salsa",
    "dance_pop", "dance_metal",
]

AUDIO_SFX = [
    "ui_click", "coin", "bark", "meow", "kiss", "punch", "notify", "portal",
]

HUD_ICONS = [
    "hunger", "sleep", "hygiene", "bladder", "fitness", "culture", "charisma",
    "crime", "kindness", "dance", "craziness", "sex_appeal", "mood", "social",
    "health", "self_esteem", "cash", "phone", "map", "pause",
]


def write_json(path: Path, data) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(data, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")


def png_rgba(w: int, h: int, rgba: tuple[int, int, int, int]) -> bytes:
    r, g, b, a = rgba
    raw = b"".join(b"\x00" + bytes([r, g, b, a]) * w for _ in range(h))
    compressed = zlib.compress(raw, 9)

    def chunk(tag: bytes, data: bytes) -> bytes:
        return struct.pack(">I", len(data)) + tag + data + struct.pack(">I", zlib.crc32(tag + data) & 0xFFFFFFFF)

    ihdr = struct.pack(">IIBBBBB", w, h, 8, 6, 0, 0, 0)
    return b"\x89PNG\r\n\x1a\n" + chunk(b"IHDR", ihdr) + chunk(b"IDAT", compressed) + chunk(b"IEND", b"")


def write_png(path: Path, color: tuple[int, int, int, int], size: int = 64) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_bytes(png_rgba(size, size, color))


def minimal_glb() -> bytes:
    """glTF 2.0 binário mínimo: 1 triângulo (placeholder importável)."""
    # positions: 3 verts
    positions = struct.pack("<9f", 0, 0, 0, 1, 0, 0, 0.5, 1, 0)
    indices = struct.pack("<3H", 0, 1, 2)
    # align to 4
    bin_blob = positions + indices
    pad = (4 - (len(bin_blob) % 4)) % 4
    bin_blob += b"\x00" * pad

    gltf = {
        "asset": {"version": "2.0", "generator": "miami3d-scaffold"},
        "scenes": [{"nodes": [0]}],
        "scene": 0,
        "nodes": [{"mesh": 0, "name": "Placeholder"}],
        "meshes": [{
            "primitives": [{
                "attributes": {"POSITION": 0},
                "indices": 1,
                "mode": 4,
            }],
            "name": "PlaceholderMesh",
        }],
        "accessors": [
            {"bufferView": 0, "componentType": 5126, "count": 3, "type": "VEC3",
             "max": [1, 1, 0], "min": [0, 0, 0]},
            {"bufferView": 1, "componentType": 5123, "count": 3, "type": "SCALAR"},
        ],
        "bufferViews": [
            {"buffer": 0, "byteOffset": 0, "byteLength": 36, "target": 34962},
            {"buffer": 0, "byteOffset": 36, "byteLength": 6, "target": 34963},
        ],
        "buffers": [{"byteLength": len(bin_blob)}],
    }
    json_bytes = json.dumps(gltf, separators=(",", ":")).encode("utf-8")
    json_pad = (4 - (len(json_bytes) % 4)) % 4
    json_bytes += b" " * json_pad

    total = 12 + 8 + len(json_bytes) + 8 + len(bin_blob)
    header = struct.pack("<4sII", b"glTF", 2, total)
    json_chunk = struct.pack("<I4s", len(json_bytes), b"JSON") + json_bytes
    bin_chunk = struct.pack("<I4s", len(bin_blob), b"BIN\x00") + bin_blob
    return header + json_chunk + bin_chunk


def touch_gitkeep(path: Path) -> None:
    path.mkdir(parents=True, exist_ok=True)
    (path / ".gitkeep").write_text("", encoding="utf-8")


def load_content_items() -> dict:
    items = {}
    folder = CONTENT / "items"
    if not folder.exists():
        return items
    for p in folder.glob("*.json"):
        data = json.loads(p.read_text(encoding="utf-8"))
        if isinstance(data, dict) and "id" in data:
            items[data["id"]] = data
        elif isinstance(data, list):
            for d in data:
                if isinstance(d, dict) and "id" in d:
                    items[d["id"]] = d
    return items


def main() -> None:
    ASSETS.mkdir(parents=True, exist_ok=True)
    placeholder = minimal_glb()
    ph_path = ASSETS / "models" / "_shared" / "placeholder.glb"
    ph_path.parent.mkdir(parents=True, exist_ok=True)
    ph_path.write_bytes(placeholder)

    # --- characters / paper-doll ---
    char = ASSETS / "models" / "characters"
    char.mkdir(parents=True, exist_ok=True)
    (char / "rig_human.glb").write_bytes(placeholder)
    parts = {
        "heads": 30,
        "hair": 30,
        "tops": 31,
        "bottoms": 30,
        "shoes": 13,
    }
    catalog_parts = {}
    for part, count in parts.items():
        folder = char / part
        folder.mkdir(parents=True, exist_ok=True)
        entries = []
        for i in range(count):
            for gender in ("m", "f"):
                name = f"{part[:-1] if part.endswith('s') else part}_{gender}_{i:02d}.glb"
                # shoes singular already
                if part == "shoes":
                    name = f"shoe_{gender}_{i:02d}.glb"
                elif part == "heads":
                    name = f"head_{gender}_{i:02d}.glb"
                elif part == "hair":
                    name = f"hair_{gender}_{i:02d}.glb"
                elif part == "tops":
                    name = f"top_{gender}_{i:02d}.glb"
                elif part == "bottoms":
                    name = f"bottom_{gender}_{i:02d}.glb"
                # only write one shared placeholder symlink-style: tiny stub marker
                stub = folder / (name.replace(".glb", ".stub.json"))
                write_json(stub, {
                    "id": name.replace(".glb", ""),
                    "slot": part.rstrip("s") if part != "bottoms" else "bottom",
                    "gender": gender,
                    "variant": i,
                    "mesh": f"res://assets/models/characters/{part}/{name}",
                    "fallback": "res://assets/models/_shared/placeholder.glb",
                    "status": "placeholder",
                })
                entries.append({
                    "id": name.replace(".glb", ""),
                    "gender": gender,
                    "variant": i,
                    "path": f"res://assets/models/characters/{part}/{name}",
                    "status": "placeholder",
                })
        catalog_parts[part] = entries
        write_json(folder / "manifest.json", {"slot": part, "count": count, "entries": entries})

    write_json(char / "manifest.json", {
        "rig": "res://assets/models/characters/rig_human.glb",
        "slots": list(parts.keys()),
        "paletteColors": 6,
        "parts": {k: len(v) // 2 for k, v in catalog_parts.items()},
    })

    # --- npc unique heads ---
    npc_dir = ASSETS / "models" / "npc_unique"
    npc_entries = []
    for nid in STORY_NPC_HEADS:
        stub = npc_dir / f"{nid}.stub.json"
        write_json(stub, {
            "id": nid,
            "mesh": f"res://assets/models/npc_unique/{nid}.glb",
            "fallback": "res://assets/models/_shared/placeholder.glb",
            "status": "placeholder",
        })
        npc_entries.append({"id": nid, "path": f"res://assets/models/npc_unique/{nid}.glb", "status": "placeholder"})
    write_json(npc_dir / "manifest.json", {"entries": npc_entries})

    # --- furniture / props from content ---
    items = load_content_items()
    furniture_entries = []
    prop_entries = []
    furn_dir = ASSETS / "models" / "furniture"
    props_dir = ASSETS / "models" / "props"
    for iid, item in sorted(items.items()):
        kind = str(item.get("kind", "prop"))
        mesh = str(item.get("mesh", ""))
        if kind == "furniture" or iid.startswith(("sofa_", "bed_", "dresser_", "tv_", "cushion_", "computer_", "chair_")) or iid in ("bed_standard", "sofa_basic"):
            path = mesh if mesh.startswith("res://assets/models/furniture/") else f"res://assets/models/furniture/{iid}.glb"
            rel = path.replace("res://assets/", "")
            stub_path = ASSETS / rel.replace(".glb", ".stub.json")
            write_json(stub_path, {"id": iid, "mesh": path, "kind": "furniture", "footprint": item.get("footprint", [1, 1]), "fallback": "res://assets/models/_shared/placeholder.glb", "status": "placeholder"})
            furniture_entries.append({"id": iid, "path": path, "footprint": item.get("footprint", [1, 1]), "status": "placeholder"})
        elif kind in ("prop", "food", "quest") or mesh:
            # normalize into props/
            path = f"res://assets/models/props/{iid}.glb"
            if mesh and "/furniture/" not in mesh:
                # keep specialty folders referenced in content as aliases under props stubs + optional kit path
                pass
            stub_path = props_dir / f"{iid}.stub.json"
            write_json(stub_path, {"id": iid, "mesh": path, "kind": kind, "footprint": item.get("footprint", [1, 1]), "contentMesh": mesh, "fallback": "res://assets/models/_shared/placeholder.glb", "status": "placeholder"})
            prop_entries.append({"id": iid, "path": path, "kind": kind, "status": "placeholder"})

    # ensure ~60 furniture slots listed (pad catalog if needed)
    while len(furniture_entries) < 60:
        i = len(furniture_entries)
        iid = f"furniture_pad_{i:02d}"
        path = f"res://assets/models/furniture/{iid}.glb"
        write_json(furn_dir / f"{iid}.stub.json", {"id": iid, "mesh": path, "kind": "furniture", "status": "placeholder", "fallback": "res://assets/models/_shared/placeholder.glb"})
        furniture_entries.append({"id": iid, "path": path, "status": "placeholder"})

    write_json(furn_dir / "manifest.json", {"count": len(furniture_entries), "entries": furniture_entries})
    write_json(props_dir / "manifest.json", {"count": len(prop_entries), "entries": prop_entries})

    # specialty content mesh folders (bathroom/kitchen/street/misc/bedroom) — alias stubs
    for folder in ("bathroom", "kitchen", "street", "misc", "bedroom"):
        touch_gitkeep(ASSETS / "models" / folder)
        write_json(ASSETS / "models" / folder / "README.json", {
            "note": "Caminhos legados em content/items/*.json; use props/ ou furniture/ como canônicos.",
            "fallback": "res://assets/models/_shared/placeholder.glb",
        })

    # --- pets ---
    pets = [
        ("dog_scottish", "dog"), ("dog_bulldog", "dog"), ("dog_beagle", "dog"),
        ("cat_house", "cat"), ("bird", "bird"), ("crocodile", "crocodile"),
    ]
    pet_entries = []
    pet_dir = ASSETS / "models" / "pets"
    for pid, species in pets:
        write_json(pet_dir / f"{pid}.stub.json", {
            "id": pid, "species": species,
            "mesh": f"res://assets/models/pets/{pid}.glb",
            "fallback": "res://assets/models/_shared/placeholder.glb",
            "status": "placeholder",
        })
        pet_entries.append({"id": pid, "species": species, "path": f"res://assets/models/pets/{pid}.glb", "status": "placeholder"})
    write_json(pet_dir / "manifest.json", {"entries": pet_entries})

    # --- kits por local ---
    kits_root = ASSETS / "models" / "kits"
    kit_index = []
    for lid in LOCATIONS:
        kdir = kits_root / lid
        kdir.mkdir(parents=True, exist_ok=True)
        for piece in ("floor", "wall", "trim", "door", "window"):
            write_json(kdir / f"{piece}.stub.json", {
                "id": f"{lid}_{piece}",
                "mesh": f"res://assets/models/kits/{lid}/{piece}.glb",
                "fallback": "res://assets/models/_shared/placeholder.glb",
                "status": "placeholder",
            })
        write_json(kdir / "manifest.json", {
            "location": lid,
            "pieces": ["floor", "wall", "trim", "door", "window"],
            "textures": {
                "albedo": f"res://assets/textures/kits/{lid}/albedo.png",
                "normal": f"res://assets/textures/kits/{lid}/normal.png",
                "roughness": f"res://assets/textures/kits/{lid}/roughness.png",
            },
            "status": "placeholder",
        })
        kit_index.append({"location": lid, "path": f"res://assets/models/kits/{lid}/"})
    write_json(kits_root / "manifest.json", {"kits": kit_index})

    # --- animations ---
    anim_dir = ASSETS / "animations"
    anim_dir.mkdir(parents=True, exist_ok=True)
    (anim_dir / "anims_human.glb").write_bytes(placeholder)
    write_json(anim_dir / "anims_human.manifest.json", {
        "library": "res://assets/animations/anims_human.glb",
        "clips": ANIM_CLIPS,
        "status": "placeholder",
        "note": "Substituir por biblioteca AnimationLibrary Godot; nomes estáveis via MnAnimationMap.",
    })

    # --- textures ---
    tex = ASSETS / "textures"
    # shared PBR placeholders
    write_png(tex / "shared" / "white.png", (240, 240, 240, 255))
    write_png(tex / "shared" / "grid.png", (60, 90, 70, 255))
    write_png(tex / "shared" / "normal_flat.png", (128, 128, 255, 255))
    write_png(tex / "shared" / "roughness.png", (160, 160, 160, 255))
    for region in REGIONS:
        write_png(tex / "regions" / f"{region}_ground.png", (70, 110, 80, 255) if "beach" not in region else (210, 190, 140, 255))
    for lid in LOCATIONS:
        ktex = tex / "kits" / lid
        write_png(ktex / "albedo.png", (120, 100, 80, 255))
        write_png(ktex / "normal.png", (128, 128, 255, 255))
        write_png(ktex / "roughness.png", (140, 140, 140, 255))
    write_json(tex / "manifest.json", {
        "shared": ["white.png", "grid.png", "normal_flat.png", "roughness.png"],
        "regions": REGIONS,
        "kits": LOCATIONS,
    })

    # --- audio ---
    audio = ASSETS / "audio"
    write_json(audio / "music" / "manifest.json", {
        "format": "ogg",
        "entries": [{"id": m, "path": f"res://assets/audio/music/{m}.ogg", "status": "missing"} for m in AUDIO_MUSIC],
    })
    write_json(audio / "sfx" / "manifest.json", {
        "format": "ogg",
        "entries": [{"id": s, "path": f"res://assets/audio/sfx/{s}.ogg", "status": "missing"} for s in AUDIO_SFX],
    })
    for sub in ("music", "sfx"):
        touch_gitkeep(audio / sub)
        (audio / sub / "README.md").write_text(
            f"# {sub}\n\nColoque arquivos `.ogg` com os ids do `manifest.json`.\n",
            encoding="utf-8",
        )

    # --- ui ---
    ui = ASSETS / "ui"
    colors = {
        "hunger": (200, 80, 60, 255), "sleep": (80, 100, 200, 255), "hygiene": (80, 180, 200, 255),
        "bladder": (200, 180, 60, 255), "fitness": (80, 160, 80, 255), "culture": (160, 100, 200, 255),
        "charisma": (220, 120, 160, 255), "crime": (40, 40, 40, 255), "kindness": (100, 200, 120, 255),
        "dance": (220, 60, 160, 255), "craziness": (180, 60, 220, 255), "sex_appeal": (220, 80, 100, 255),
        "mood": (240, 200, 80, 255), "social": (80, 160, 220, 255), "health": (60, 200, 100, 255),
        "self_esteem": (200, 160, 80, 255), "cash": (80, 180, 80, 255), "phone": (60, 60, 80, 255),
        "map": (60, 100, 60, 255), "pause": (100, 100, 100, 255),
    }
    for name in HUD_ICONS:
        write_png(ui / "hud" / f"{name}.png", colors.get(name, (180, 180, 180, 255)), 48)
    # item icons for curated items
    for iid in ("bed_standard", "sofa_basic", "flowers", "gnome", "phone", "shower", "fridge"):
        write_png(ui / "items" / f"{iid}.png", (160, 120, 90, 255), 64)
    write_png(ui / "logo.png", (240, 90, 130, 255), 128)
    write_json(ui / "manifest.json", {"hud": HUD_ICONS, "logo": "res://assets/ui/logo.png"})

    # --- root manifest ---
    write_json(ASSETS / "manifest.json", {
        "id": "miami3d_assets",
        "version": "0.1.0-placeholders",
        "note": "Placeholders procedurais + stubs. Troque .glb/.ogg reais mantendo os mesmos paths/ids.",
        "sharedPlaceholder": "res://assets/models/_shared/placeholder.glb",
        "sections": {
            "characters": "res://assets/models/characters/manifest.json",
            "npc_unique": "res://assets/models/npc_unique/manifest.json",
            "furniture": "res://assets/models/furniture/manifest.json",
            "props": "res://assets/models/props/manifest.json",
            "pets": "res://assets/models/pets/manifest.json",
            "kits": "res://assets/models/kits/manifest.json",
            "animations": "res://assets/animations/anims_human.manifest.json",
            "textures": "res://assets/textures/manifest.json",
            "audio_music": "res://assets/audio/music/manifest.json",
            "audio_sfx": "res://assets/audio/sfx/manifest.json",
            "ui": "res://assets/ui/manifest.json",
        },
        "counts": {
            "heads": 30, "hair": 30, "tops": 31, "bottoms": 30, "shoes": 13,
            "npc_unique": len(STORY_NPC_HEADS),
            "furniture": len(furniture_entries),
            "props": len(prop_entries),
            "pets": len(pets),
            "kits": len(LOCATIONS),
            "anim_clips": len(ANIM_CLIPS),
            "hud_icons": len(HUD_ICONS),
        },
    })

    (ASSETS / "README.md").write_text(
        """# assets/ — músculos do Miami 3D

Arte e áudio do remake. **Não** contém assets Gameloft; só placeholders + contratos de path.

| Pasta | Conteúdo |
| --- | --- |
| `models/characters/` | `rig_human.glb` + paper-doll (heads/hair/tops/bottoms/shoes) |
| `models/npc_unique/` | Cabeças do elenco |
| `models/furniture/` | Catálogo de móveis (~60) |
| `models/props/` | Props / decoração |
| `models/pets/` | Cães, gato, ave, crocodilo |
| `models/kits/<local>/` | Chão/parede por local |
| `animations/` | Biblioteca de clipes humanos |
| `textures/` | PBR shared + por kit/região |
| `audio/` | Música e SFX (OGG) |
| `ui/` | Ícones HUD / itens / logo |

## Como funciona no jogo

`MnAssetRegistry` resolve `id` → path. Se o `.glb`/`.ogg` ainda não existe, usa
`models/_shared/placeholder.glb` ou malha procedural (`MnMeshFactory`).

Quando a arte final chegar: grave o arquivo no path do `manifest` / `.stub.json` e
remova o stub (ou marque `"status": "ready"`).

## Regenerar árvore

```bash
python3 tools/scaffold_assets.py
python3 tools/validate_assets.py
```
""",
        encoding="utf-8",
    )
    print("OK assets em", ASSETS)
    print("furniture", len(furniture_entries), "props", len(prop_entries), "kits", len(LOCATIONS))


if __name__ == "__main__":
    main()
