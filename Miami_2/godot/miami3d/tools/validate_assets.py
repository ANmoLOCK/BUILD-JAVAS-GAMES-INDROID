#!/usr/bin/env python3
"""Valida contratos da pasta assets/ (manifests + placeholders)."""

from __future__ import annotations

import json
import sys
from pathlib import Path

ASSETS = Path(__file__).resolve().parents[1] / "assets"


def main() -> int:
    errors: list[str] = []
    root = json.loads((ASSETS / "manifest.json").read_text(encoding="utf-8"))
    counts = root.get("counts", {})
    checks = [
        ("heads", 30), ("hair", 30), ("tops", 31), ("bottoms", 30), ("shoes", 13),
        ("npc_unique", 30), ("furniture", 60), ("kits", 25), ("anim_clips", 20), ("hud_icons", 16),
    ]
    for key, minimum in checks:
        val = int(counts.get(key, 0))
        ok = val >= minimum
        print(("OK " if ok else "FAIL"), f"{key} >= {minimum} ({val})")
        if not ok:
            errors.append(f"{key}={val}")

    required = [
        "models/_shared/placeholder.glb",
        "models/characters/rig_human.glb",
        "models/characters/manifest.json",
        "models/furniture/manifest.json",
        "models/props/manifest.json",
        "models/pets/manifest.json",
        "models/kits/manifest.json",
        "animations/anims_human.glb",
        "animations/anims_human.manifest.json",
        "textures/manifest.json",
        "audio/music/manifest.json",
        "audio/sfx/manifest.json",
        "ui/manifest.json",
        "ui/logo.png",
    ]
    for rel in required:
        p = ASSETS / rel
        if not p.exists():
            errors.append(f"missing {rel}")
            print("FAIL missing", rel)
        else:
            print("OK ", rel)

    # spot-check kit + hud
    if not (ASSETS / "models/kits/player_apartment/manifest.json").exists():
        errors.append("kit player_apartment")
    if not (ASSETS / "ui/hud/hunger.png").exists():
        errors.append("hud hunger")

    ph = ASSETS / "models/_shared/placeholder.glb"
    if ph.exists() and ph.read_bytes()[:4] != b"glTF":
        errors.append("placeholder.glb not glTF")

    print("---")
    print(f"version {root.get('version')} errors={len(errors)}")
    return 1 if errors else 0


if __name__ == "__main__":
    sys.exit(main())
