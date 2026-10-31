#!/usr/bin/env python3
"""Valida brand.json + assets do boot Miami Life."""
from __future__ import annotations

import json
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
BRAND = ROOT / "content" / "brand.json"


def main() -> int:
    if not BRAND.exists():
        print("FAIL missing brand.json")
        return 1
    doc = json.loads(BRAND.read_text(encoding="utf-8"))
    errs: list[str] = []
    if doc.get("game_title") != "Miami Life":
        errs.append("game_title deve ser Miami Life")
    studio = str(doc.get("studio_name", "")).lower()
    if "gameloft" in studio or "gameloft" in str(doc.get("studio_legal", "")).lower():
        errs.append("studio_name/legal não pode ser Gameloft")
    assets = doc.get("assets", {})
    for key in ("studio_logo", "game_logo", "hero_bg"):
        rel = str(assets.get(key, "")).replace("res://", "")
        path = ROOT / rel
        if not path.exists():
            errs.append(f"asset ausente {key}: {path}")
    if errs:
        print("FAIL")
        for e in errs:
            print(" -", e)
        return 1
    print(
        "OK brand",
        doc.get("game_title"),
        "/",
        doc.get("studio_name"),
        "assets=3",
    )
    return 0


if __name__ == "__main__":
    sys.exit(main())
