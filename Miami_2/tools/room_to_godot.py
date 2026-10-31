#!/usr/bin/env python3
"""Converte `07-salas/room_NN.json` em placeholders Godot + rascunho de location JSON.

Gera:
  - content draft: locations/<id>.from_room.json  (grade, blocked, spawn, props genéricos)
  - cena: game/world/locations/_generated/room_NN.tscn  (CSG/Label3D via script helper)
  - relatório: tools/_out/room_to_godot_report.md

Uso:
  python3 tools/room_to_godot.py 07-salas/room_14.json
  python3 tools/room_to_godot.py 07-salas --all
  python3 tools/room_to_godot.py 07-salas/room_00.json \\
      --content-out godot/miami3d/content/locations \\
      --scene-out godot/miami3d/game/world/locations/_generated
"""
from __future__ import annotations

import argparse
import json
import re
from pathlib import Path

HERE = Path(__file__).resolve().parent
MIAMI2 = HERE.parent

# Sala original → id canônico do remake (inventário 04)
ROOM_TO_LOCATION = {
    0: "first_street",
    1: "police_station",
    2: "glight_club",
    3: "newspaper_office",
    4: "stadium",
    5: "beauty_clinic",
    6: "heather_dean_apartment",
    7: "grand_avenue",
    8: "lounge",
    9: "south_beach",
    10: "cuban_cafe",
    11: "little_havana",
    12: "yuca_restaurant",
    13: "ocean_drive",
    14: "player_apartment",
    15: "pelican_port",
    16: "yacht",
    17: "everglades",
    18: "mansion",
    19: "downtown",
    20: "coconut_grove",
    21: "miami_beach",
    22: "pelican_island",
    23: "key_biscayne",
}

BLOCK_CHARS = set("#;")


def world_to_cell(x: int, y: int, origin_x: int, origin_y: int, w: int, h: int, xs: list[int], ys: list[int]) -> tuple[int, int]:
    """Projeta coordenadas da sala na grade lógica width×height."""
    min_x, max_x = min(xs), max(xs)
    min_y, max_y = min(ys), max(ys)
    span_x = max(1, max_x - min_x)
    span_y = max(1, max_y - min_y)
    cx = int((x - min_x) / span_x * (w - 1))
    cy = int((y - min_y) / span_y * (h - 1))
    return max(0, min(w - 1, cx)), max(0, min(h - 1, cy))


def blocked_from_ascii(ascii_grid) -> list[list[int]]:
    """Rects horizontais a partir da grade ASCII (# / ; = bloqueado)."""
    if not ascii_grid:
        return []
    lines = ascii_grid if isinstance(ascii_grid, list) else str(ascii_grid).splitlines()
    blocked = []
    for y, row in enumerate(lines):
        if not isinstance(row, str):
            continue
        x = 0
        while x < len(row):
            if row[x] not in BLOCK_CHARS:
                x += 1
                continue
            x0 = x
            while x < len(row) and row[x] in BLOCK_CHARS:
                x += 1
            blocked.append([x0, y, x - x0, 1])
    return blocked


def convert_room(room_path: Path) -> dict:
    data = json.loads(room_path.read_text(encoding="utf-8"))
    room_id = int(data.get("room", -1))
    loc_id = ROOM_TO_LOCATION.get(room_id, f"room_{room_id:02d}")
    grid = data.get("grid", {})
    w = int(grid.get("width", 16))
    h = int(grid.get("height", 16))
    ox = int(grid.get("originX", 0))
    oy = int(grid.get("originY", 0))
    records = data.get("records", [])
    xs = [int(r.get("x", 0)) for r in records] or [0]
    ys = [int(r.get("y", 0)) for r in records] or [0]

    blocked = blocked_from_ascii(data.get("collision_ascii"))
    if not blocked:
        # fallback: borda
        blocked = [[0, 0, w, 1], [0, 0, 1, h], [w - 1, 0, 1, h], [0, h - 1, w, 1]]

    spawn_cell = [w // 2, h // 2]
    for r in records:
        if r.get("name") == "player_spawn":
            spawn_cell = list(world_to_cell(int(r["x"]), int(r["y"]), ox, oy, w, h, xs, ys))
            break

    objects = []
    for i, r in enumerate(records):
        if r.get("name") != "object":
            continue
        cell = world_to_cell(int(r["x"]), int(r["y"]), ox, oy, w, h, xs, ys)
        objects.append({
            "id": f"obj_{int(r.get('id', i))}",
            "template": "prop_generic",
            "cell": list(cell),
            "legacyId": int(r.get("id", i)),
        })
        if len(objects) >= 80:  # evita cenas gigantes
            break

    portals = []
    for i, r in enumerate(records):
        if r.get("name") != "door_cell":
            continue
        cell = world_to_cell(int(r["x"]), int(r["y"]), ox, oy, w, h, xs, ys)
        portals.append({
            "id": f"door_{int(r.get('id', i))}",
            "cell": list(cell),
            "to": "",
            "spawn": "default",
            "note": "preencher destino manualmente",
        })

    npcs = []
    for i, r in enumerate(records):
        if r.get("name") != "npc":
            continue
        cell = world_to_cell(int(r["x"]), int(r["y"]), ox, oy, w, h, xs, ys)
        npcs.append({
            "npc": f"legacy_npc_{int(r.get('id', i))}",
            "cell": list(cell),
            "legacyId": int(r.get("id", i)),
        })

    zones = []
    for i, r in enumerate(records):
        if r.get("name") not in ("zone_rect_16_8", "zone_rect_64_128", "trigger_zone"):
            continue
        cell = world_to_cell(int(r["x"]), int(r["y"]), ox, oy, w, h, xs, ys)
        zones.append({
            "id": f"zone_{i}",
            "rect": [cell[0], cell[1], 2, 2],
            "tag": "custom",
        })
        if len(zones) >= 20:
            break

    location = {
        "id": loc_id,
        "name": f"@loc.{loc_id}",
        "region": "downtown",
        "scene": f"res://game/world/locations/_generated/room_{room_id:02d}.tscn",
        "indoor": room_id in (1, 2, 3, 5, 6, 8, 10, 12, 14, 16, 18),
        "openHours": [0, 24],
        "music": "apartment_calm" if room_id in (6, 8, 14) else "downtown_day",
        "grid": {"width": w, "height": h},
        "spawn": {"cell": spawn_cell, "facing": "S"},
        "spawns": {"default": {"cell": spawn_cell, "facing": "S"}},
        "blocked": _merge_blocked(blocked),
        "portals": portals,
        "zones": zones,
        "objects": objects,
        "npcs": [{"generic": True, "count": min(6, max(1, len(npcs)))}] if npcs else [],
        "triggers": [],
        "sourceRoom": room_id,
        "generatedBy": "room_to_godot.py",
    }
    meta = {
        "room": room_id,
        "location": loc_id,
        "grid": [w, h],
        "blockedCells": len(blocked),
        "objects": len(objects),
        "portals": len(portals),
        "npcsLegacy": len(npcs),
        "source": str(room_path),
    }
    return {"location": location, "meta": meta, "room_id": room_id, "loc_id": loc_id}


def _merge_blocked(cells: list[list[int]]) -> list[list[int]]:
    """Mantém lista compacta: se muitas células 1×1, devolve como está (até 400) ou amostra bordas+amostra."""
    if len(cells) <= 400:
        return cells
    # amostra: todas as bordas + a cada N
    out = [c for c in cells if c[0] == 0 or c[1] == 0]
    step = max(1, len(cells) // 300)
    out.extend(cells[::step])
    # unique
    seen = set()
    uniq = []
    for c in out:
        t = tuple(c)
        if t not in seen:
            seen.add(t)
            uniq.append(c)
    return uniq[:400]


def write_tscn(path: Path, room_id: int, loc_id: str, location: dict) -> None:
    """Cena mínima: LocationController; dados ficam no .from_room.json do content."""
    path.parent.mkdir(parents=True, exist_ok=True)
    _ = location  # usado pelo chamador no content-out
    content = f'''[gd_scene load_steps=2 format=3]

[ext_resource type="PackedScene" path="res://game/world/location_controller.tscn" id="1"]

[node name="Room{room_id:02d}_{_pascal(loc_id)}" type="Node3D"]

[node name="Location" parent="." instance=ExtResource("1")]
'''
    path.write_text(content, encoding="utf-8")


def _pascal(s: str) -> str:
    return "".join(p.capitalize() for p in s.split("_"))


def main() -> int:
    ap = argparse.ArgumentParser(description="room_NN.json → Godot placeholders")
    ap.add_argument("input", type=Path, help="arquivo room_NN.json ou pasta 07-salas")
    ap.add_argument("--all", action="store_true", help="processa todos room_*.json da pasta")
    ap.add_argument("--content-out", type=Path, default=None,
                    help="pasta para <id>.from_room.json (default: godot/miami3d/content/locations/_from_rooms)")
    ap.add_argument("--scene-out", type=Path, default=None,
                    help="pasta para room_NN.tscn (default: godot/miami3d/game/world/locations/_generated)")
    ap.add_argument("--report", type=Path, default=None)
    ap.add_argument("--write-live", action="store_true",
                    help="também grava <id>.json no content (cuidado: sobrescreve stubs)")
    args = ap.parse_args()

    content_out = args.content_out or (MIAMI2 / "godot/miami3d/content/locations/_from_rooms")
    scene_out = args.scene_out or (MIAMI2 / "godot/miami3d/game/world/locations/_generated")
    report_path = args.report or (HERE / "_out" / "room_to_godot_report.md")

    if args.input.is_dir() or args.all:
        root = args.input if args.input.is_dir() else args.input.parent
        files = sorted(root.glob("room_*.json"))
    else:
        files = [args.input]

    if not files:
        print("nenhum room_*.json encontrado")
        return 1

    content_out.mkdir(parents=True, exist_ok=True)
    scene_out.mkdir(parents=True, exist_ok=True)
    report_path.parent.mkdir(parents=True, exist_ok=True)

    lines = ["# room_to_godot — relatório\n", "| Sala | Location | Grade | Blocked | Objects | Portals |\n|---|---|---|---|---|---|\n"]
    for fp in files:
        if fp.name == "rooms_summary.json":
            continue
        result = convert_room(fp)
        loc = result["location"]
        meta = result["meta"]
        out_json = content_out / f"{result['loc_id']}.from_room.json"
        out_json.write_text(json.dumps(loc, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")
        write_tscn(scene_out / f"room_{result['room_id']:02d}.tscn", result["room_id"], result["loc_id"], loc)
        if args.write_live:
            live = content_out.parent / f"{result['loc_id']}.json"
            # não sobrescreve se já curado sem sourceRoom
            if live.exists():
                existing = json.loads(live.read_text(encoding="utf-8"))
                if not existing.get("stub") and not existing.get("generatedBy"):
                    print(f"skip live {live} (curado)")
                else:
                    live.write_text(json.dumps(loc, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")
                    print(f"wrote live {live}")
            else:
                live.write_text(json.dumps(loc, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")
        lines.append(
            f"| {meta['room']:02d} | `{meta['location']}` | {meta['grid'][0]}×{meta['grid'][1]} | "
            f"{meta['blockedCells']} | {meta['objects']} | {meta['portals']} |\n"
        )
        print(f"OK room_{meta['room']:02d} → {meta['location']}  ({out_json.name})")

    # item prop_generic se não existir
    items_dir = MIAMI2 / "godot/miami3d/content/items"
    prop_path = items_dir / "prop_generic.json"
    if items_dir.exists() and not prop_path.exists():
        prop_path.write_text(json.dumps({
            "id": "prop_generic",
            "name": "@item.prop_generic",
            "kind": "prop",
            "footprint": [1, 1],
            "actions": ["use"],
            "price": 0,
        }, indent=2) + "\n", encoding="utf-8")

    report_path.write_text("".join(lines), encoding="utf-8")
    print(f"report → {report_path}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
