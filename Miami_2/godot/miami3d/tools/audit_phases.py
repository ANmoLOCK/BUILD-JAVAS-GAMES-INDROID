#!/usr/bin/env python3
"""Auditoria das checklists A–G (sem Godot). Exit 0 se tudo ok."""
from __future__ import annotations
import json
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
CONTENT = ROOT / "content"


def _ids_from_folder(folder: Path) -> set[str]:
    out: set[str] = set()
    if not folder.is_dir():
        return out
    for p in folder.glob("*.json"):
        data = json.loads(p.read_text(encoding="utf-8"))
        items = []
        if isinstance(data, dict) and data.get("id"):
            items = [data]
        elif isinstance(data, list):
            items = data
        elif isinstance(data, dict):
            items = [v for v in data.values() if isinstance(v, dict) and v.get("id")]
        for it in items:
            if isinstance(it, dict) and it.get("id"):
                out.add(str(it["id"]))
    return out


def main() -> int:
    phases = json.loads((CONTENT / "phases.json").read_text(encoding="utf-8"))
    locs = _ids_from_folder(CONTENT / "locations")
    npcs = _ids_from_folder(CONTENT / "npcs")
    quests = _ids_from_folder(CONTENT / "quests")
    jobs = _ids_from_folder(CONTENT / "jobs")
    acts = _ids_from_folder(CONTENT / "interactions")
    core_map = {
        "time_system": "core/time_system.gd",
        "stat_system": "core/stat_system.gd",
        "appearance_system": "core/appearance_system.gd",
        "relationship_system": "core/relationship_system.gd",
        "dialogue_system": "core/dialogue_system.gd",
        "quest_machine": "core/quest_machine.gd",
        "economy_system": "core/economy_system.gd",
        "crime_system": "core/crime_system.gd",
        "job_system": "core/job_system.gd",
        "dating_system": "core/dating_system.gd",
        "home_system": "core/home_system.gd",
        "pet_system": "core/pet_system.gd",
        "mod_loader": "core/mod_loader.gd",
        "phase_director": "core/phase_director.gd",
        "phase_catalog": "core/phase_catalog.gd",
    }
    fails: list[str] = []
    for pid, ph in phases.get("phases", {}).items():
        for raw in ph.get("checklist", []):
            kind, cid = str(raw).split(":", 1)
            ok = False
            if kind == "core":
                ok = (ROOT / core_map.get(cid, f"core/{cid}.gd")).exists()
            elif kind == "location":
                ok = cid in locs
            elif kind == "npc":
                ok = cid in npcs
            elif kind == "quest":
                ok = cid in quests
            elif kind == "job":
                ok = cid in jobs
            elif kind == "action":
                ok = cid in acts
            elif kind == "ui":
                ok = (ROOT / f"game/ui/{cid}.tscn").exists() or (ROOT / f"game/ui/{cid}.gd").exists()
            elif kind == "actor":
                ok = (ROOT / f"game/actors/{cid}.tscn").exists() or (ROOT / f"game/actors/{cid}.gd").exists()
            elif kind == "minigame":
                ok = (ROOT / f"game/minigames/{cid}.tscn").exists()
            elif kind == "test":
                ok = (ROOT / f"tests/{cid}.gd").exists()
            elif kind == "content":
                if cid == "surgery":
                    ok = (CONTENT / "surgery.json").exists()
                elif cid == "gifts":
                    ok = (CONTENT / "gifts.json").exists()
                elif cid == "achievements":
                    ok = (CONTENT / "achievements.json").exists()
                elif cid == "quests_99":
                    ok = len(quests) >= 99
                elif cid == "regions_9":
                    regions = json.loads((CONTENT / "regions.json").read_text(encoding="utf-8"))
                    ok = len(regions.get("regions", [])) >= 9
            elif kind == "doc":
                ok = (ROOT / "game/phases/g_mods/CRIADORES.md").exists() if cid == "CRIADORES" else False
            elif kind == "mod":
                ok = (ROOT / "mods/example_pack/pack.json").exists() if cid == "example" else False
            if not ok:
                fails.append(f"{pid}:{raw}")
    if fails:
        print("FAIL", len(fails))
        for f in fails:
            print(" ", f)
        return 1
    print("OK phases checklist A–G")
    return 0


if __name__ == "__main__":
    sys.exit(main())
