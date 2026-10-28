#!/usr/bin/env python3
"""Valida world_map.json contra locations do pack miami3d."""
from __future__ import annotations

import json
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
MAP = ROOT / "content" / "world_map.json"
LOC_DIR = ROOT.parent / "godot" / "miami3d" / "content" / "locations"


def main() -> int:
    if not MAP.exists():
        print(f"FAIL missing {MAP}")
        return 1
    doc = json.loads(MAP.read_text(encoding="utf-8"))
    anchors = doc.get("anchors", {})
    chunks = doc.get("chunks", [])
    known = {p.stem for p in LOC_DIR.glob("*.json") if not p.name.startswith("_")}
    errs: list[str] = []

    for loc_id, anchor in anchors.items():
        if loc_id not in known:
            errs.append(f"âncora sem location JSON: {loc_id}")
        oc = anchor.get("origin_cell")
        if not isinstance(oc, list) or len(oc) < 2:
            errs.append(f"{loc_id}: origin_cell inválido")
        if anchor.get("outdoor") and "size" not in anchor:
            # size opcional se location tem grid
            pass
        if not anchor.get("outdoor") and not anchor.get("parent"):
            errs.append(f"{loc_id}: indoor sem parent outdoor")

    outdoor = {k for k, v in anchors.items() if v.get("outdoor")}
    for ch in chunks:
        cid = ch.get("id")
        for loc in ch.get("locations", []):
            if loc not in anchors:
                errs.append(f"chunk {cid}: local sem âncora {loc}")
            elif loc not in outdoor:
                errs.append(f"chunk {cid}: lista indoor {loc}")

    # overlaps outdoor (aviso, não fail duro se leve)
    boxes = []
    for loc_id in sorted(outdoor):
        a = anchors[loc_id]
        ox, oy = a["origin_cell"][:2]
        loc_path = LOC_DIR / f"{loc_id}.json"
        w, h = 16, 16
        if "size" in a:
            w, h = a["size"][:2]
        elif loc_path.exists():
            g = json.loads(loc_path.read_text(encoding="utf-8")).get("grid", {})
            w, h = int(g.get("width", 16)), int(g.get("height", 16))
        boxes.append((loc_id, ox, oy, ox + w, oy + h))

    for i, (a_id, ax0, ay0, ax1, ay1) in enumerate(boxes):
        for b_id, bx0, by0, bx1, by1 in boxes[i + 1 :]:
            if ax0 < bx1 and ax1 > bx0 and ay0 < by1 and ay1 > by0:
                errs.append(f"overlap outdoor: {a_id} x {b_id}")

    # seams endpoints
    for s in doc.get("seams", []):
        for key in ("from", "to"):
            if s.get(key) not in outdoor:
                errs.append(f"seam {s}: {key} não é outdoor âncora")

    if errs:
        print(f"FAIL {len(errs)} issue(s)")
        for e in errs:
            print(" -", e)
        return 1

    print(
        "OK world_map",
        f"anchors={len(anchors)} outdoor={len(outdoor)} chunks={len(chunks)}",
        f"known_locations={len(known)}",
    )
    return 0


if __name__ == "__main__":
    sys.exit(main())
