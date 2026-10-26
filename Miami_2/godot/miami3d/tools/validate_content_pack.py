#!/usr/bin/env python3
"""Validação leve do pack: contagens mínimas + refs órfãs principais."""

from __future__ import annotations

import json
import sys
from pathlib import Path

CONTENT = Path(__file__).resolve().parents[1] / "content"


def load_folder(folder: str) -> dict:
    out = {}
    d = CONTENT / folder
    if not d.exists():
        return out
    for p in d.glob("*.json"):
        data = json.loads(p.read_text(encoding="utf-8"))
        if isinstance(data, dict) and "id" in data:
            out[data["id"]] = data
        elif isinstance(data, list):
            for item in data:
                if isinstance(item, dict) and "id" in item:
                    out[item["id"]] = item
    return out


def main() -> int:
    errors: list[str] = []
    warnings: list[str] = []

    pack = json.loads((CONTENT / "pack.json").read_text(encoding="utf-8"))
    stats = json.loads((CONTENT / "stats.json").read_text(encoding="utf-8"))
    strings = json.loads((CONTENT / "strings/pt-BR.json").read_text(encoding="utf-8"))
    locations = load_folder("locations")
    npcs = load_folder("npcs")
    items = load_folder("items")
    interactions = load_folder("interactions")
    quests = {k: v for k, v in load_folder("quests").items() if "stages" in v}
    jobs = load_folder("jobs")
    schedules = load_folder("schedules")
    regions = json.loads((CONTENT / "regions.json").read_text(encoding="utf-8"))
    achievements = json.loads((CONTENT / "achievements.json").read_text(encoding="utf-8"))
    gifts = json.loads((CONTENT / "gifts.json").read_text(encoding="utf-8"))
    surgery = json.loads((CONTENT / "surgery.json").read_text(encoding="utf-8"))
    rent = json.loads((CONTENT / "rent.json").read_text(encoding="utf-8"))
    topics = json.loads((CONTENT / "dialogue/topics.json").read_text(encoding="utf-8"))
    reactions = json.loads((CONTENT / "dialogue/reactions.json").read_text(encoding="utf-8"))

    checks = [
        ("locations >= 25", len(locations) >= 25, len(locations)),
        ("npcs >= 94", len(npcs) >= 94, len(npcs)),
        ("items >= 100", len(items) >= 100, len(items)),
        ("interactions >= 139", len(interactions) >= 139, len(interactions)),
        ("quests >= 99", len(quests) >= 99, len(quests)),
        ("jobs == 4", len(jobs) == 4, len(jobs)),
        ("schedules >= 10", len(schedules) >= 10, len(schedules)),
        ("achievements == 19", len(achievements.get("items", [])) == 19, len(achievements.get("items", []))),
        ("gifts == 8", len(gifts.get("items", [])) == 8, len(gifts.get("items", []))),
        ("regions == 9", len(regions.get("regions", [])) == 9, len(regions.get("regions", []))),
        ("topic cats == 38", len(topics.get("categories", [])) == 38, len(topics.get("categories", []))),
        ("interests == 175", int(topics.get("interestCount", 0)) == 175, topics.get("interestCount")),
        ("stats == 16", len(stats.get("stats", [])) == 16, len(stats.get("stats", []))),
        ("surgery == 4", len(surgery.get("procedures", [])) == 4, len(surgery.get("procedures", []))),
        ("rent apartment 300", int(rent.get("apartment", {}).get("amount", 0)) == 300, rent.get("apartment", {}).get("amount")),
        ("strings >= 500", len(strings) >= 500, len(strings)),
    ]
    for label, ok, val in checks:
        if ok:
            print(f"OK  {label} ({val})")
        else:
            errors.append(f"FAIL {label} ({val})")
            print(f"FAIL {label} ({val})")

    # refs: location portals
    for lid, loc in locations.items():
        for p in loc.get("portals", []):
            to = str(p.get("to", ""))
            if to and to not in locations:
                errors.append(f"portal órfão {lid} -> {to}")
        for n in loc.get("npcs", []):
            if n.get("generic"):
                continue
            nid = str(n.get("npc", ""))
            if nid and nid not in npcs:
                warnings.append(f"NPC ref ausente em {lid}: {nid}")
        for obj in loc.get("objects", []):
            tid = str(obj.get("template", ""))
            if tid and tid not in items:
                warnings.append(f"item template ausente em {lid}: {tid}")

    for nid, npc in npcs.items():
        sid = str(npc.get("schedule", ""))
        if sid and sid not in schedules:
            warnings.append(f"schedule ausente para {nid}: {sid}")

    for jid, job in jobs.items():
        loc = str(job.get("location", ""))
        if loc and loc not in locations:
            errors.append(f"job {jid} location ausente: {loc}")

    # string keys for locations
    for lid in locations:
        key = f"loc.{lid}"
        if key not in strings:
            warnings.append(f"string ausente: {key}")

    print("---")
    print(f"pack {pack.get('id')} v{pack.get('version')}")
    print(f"warnings: {len(warnings)}  errors: {len(errors)}")
    for w in warnings[:30]:
        print("  WARN", w)
    if len(warnings) > 30:
        print(f"  ... +{len(warnings)-30} warns")
    for e in errors:
        print("  ERR", e)
    return 1 if errors else 0


if __name__ == "__main__":
    sys.exit(main())
