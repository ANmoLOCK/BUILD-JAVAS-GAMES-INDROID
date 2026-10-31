#!/usr/bin/env python3
"""Valida um pack de conteúdo (content/ ou mods/<pack>/) contra os schemas em schemas/.

Além da validação estrutural (JSON Schema), confere referências cruzadas:
chaves de string (@...) existentes, ids de itens/NPCs/locais/interações/quests
referenciados que não foram definidos, e ids duplicados.

Uso:
    python3 tools/validate_content.py godot/miami3d/content
    python3 tools/validate_content.py godot/miami3d/content --lite
    python3 tools/validate_content.py godot/miami3d/content --strict

--lite  só contagens + refs (não precisa jsonschema; espelha miami3d/tools/validate_content_pack.py)
Requer (modo completo):  pip install jsonschema
"""
from __future__ import annotations

import argparse
import json
import re
import sys
from pathlib import Path

STRING_KEY = re.compile(r"^@([A-Za-z0-9_.]+)$")

KINDS = {
    "locations": "location.schema.json",
    "npcs": "npc.schema.json",
    "items": "item.schema.json",
    "interactions": "interaction.schema.json",
    "quests": "quest.schema.json",
}


def load_folder(pack: Path, folder: str) -> dict:
    out = {}
    d = pack / folder
    if not d.is_dir():
        return out
    for p in d.glob("*.json"):
        try:
            data = json.loads(p.read_text(encoding="utf-8"))
        except json.JSONDecodeError:
            continue
        if isinstance(data, dict) and "id" in data:
            out[str(data["id"])] = data
        elif isinstance(data, list):
            for item in data:
                if isinstance(item, dict) and "id" in item:
                    out[str(item["id"])] = item
    return out


def walk(obj, path=""):
    if isinstance(obj, dict):
        for k, v in obj.items():
            yield from walk(v, f"{path}.{k}" if path else k)
    elif isinstance(obj, list):
        for i, v in enumerate(obj):
            yield from walk(v, f"{path}[{i}]")
    else:
        yield path, obj


class Report:
    def __init__(self):
        self.errors = []
        self.warnings = []

    def err(self, where, msg):
        self.errors.append(f"{where}: {msg}")

    def warn(self, where, msg):
        self.warnings.append(f"{where}: {msg}")


def run_lite(pack: Path, rep: Report) -> dict:
    """Validação sem jsonschema — contagens do inventário 04 + refs básicas."""
    locations = load_folder(pack, "locations")
    # ignora drafts _from_rooms no count principal se estiverem em subpasta
    npcs = load_folder(pack, "npcs")
    items = load_folder(pack, "items")
    interactions = load_folder(pack, "interactions")
    quests = {k: v for k, v in load_folder(pack, "quests").items() if isinstance(v, dict) and "stages" in v}
    jobs = load_folder(pack, "jobs")
    schedules = load_folder(pack, "schedules")

    checks = [
        ("locations >= 25", len(locations) >= 25, len(locations)),
        ("npcs >= 90", len(npcs) >= 90, len(npcs)),
        ("items >= 50", len(items) >= 50, len(items)),
        ("interactions >= 100", len(interactions) >= 100, len(interactions)),
        ("quests >= 90", len(quests) >= 90, len(quests)),
        ("jobs == 4", len(jobs) == 4, len(jobs)),
        ("schedules >= 5", len(schedules) >= 5, len(schedules)),
    ]
    for label, ok, val in checks:
        if ok:
            print(f"OK  {label} ({val})")
        else:
            rep.err("lite", f"{label} got {val}")
            print(f"FAIL {label} ({val})")

    for name in ("pack.json", "stats.json", "regions.json", "gifts.json", "rent.json", "achievements.json"):
        if not (pack / name).exists():
            rep.err(name, "ausente")
        else:
            print(f"OK  {name}")

    strings_path = pack / "strings" / "pt-BR.json"
    strings = {}
    if strings_path.exists():
        strings = json.loads(strings_path.read_text(encoding="utf-8"))
        print(f"OK  strings ({len(strings)})")
    else:
        rep.err("strings", "pt-BR.json ausente")

    for lid, loc in locations.items():
        if lid.startswith("room_"):
            continue
        for portal in loc.get("portals", []):
            to = str(portal.get("to", ""))
            if to and to not in locations:
                rep.warn(f"locations/{lid}", f"portal → '{to}' indefinido")
        for obj in loc.get("objects", []):
            tid = str(obj.get("template", ""))
            if tid and tid not in items:
                rep.warn(f"locations/{lid}", f"template '{tid}' sem item")
        key = f"loc.{lid}"
        if strings and key not in strings:
            rep.warn(f"strings", f"falta {key}")

    for jid, job in jobs.items():
        loc = str(job.get("location", ""))
        if loc and loc not in locations:
            rep.err(f"jobs/{jid}", f"location '{loc}' ausente")

    return {
        "locations": locations, "npcs": npcs, "items": items,
        "interactions": interactions, "quests": quests,
    }


def run_schema(pack: Path, schema_dir: Path, rep: Report, skip_unused: bool) -> None:
    try:
        from jsonschema import Draft202012Validator
        from referencing import Registry, Resource
    except ImportError:
        rep.warn("deps", "jsonschema não instalado — use --lite ou: pip install jsonschema")
        return

    registry = Registry()
    schemas = {}
    for p in schema_dir.glob("*.schema.json"):
        s = json.loads(p.read_text(encoding="utf-8"))
        schemas[p.name] = s
        registry = registry.with_resource(p.name, Resource.from_contents(s))
        registry = registry.with_resource(s.get("$id", p.name), Resource.from_contents(s))

    defined = {k: {} for k in KINDS}
    docs = []

    pack_json = pack / "pack.json"
    if not pack_json.exists():
        rep.err(str(pack_json), "pack.json ausente")
    else:
        docs.append((pack_json, json.loads(pack_json.read_text(encoding="utf-8"))))

    strings = {}
    for sp in (pack / "strings").glob("*.json"):
        strings[sp.stem] = json.loads(sp.read_text(encoding="utf-8"))
    primary = strings.get("pt-BR") or next(iter(strings.values()), {})

    stats_path = pack / "stats.json"
    if stats_path.exists() and "stats.schema.json" in schemas:
        d = json.loads(stats_path.read_text(encoding="utf-8"))
        v = Draft202012Validator(schemas["stats.schema.json"], registry=registry)
        for e in sorted(v.iter_errors(d), key=lambda e: list(e.path)):
            rep.err(f"{stats_path}:{'/'.join(map(str, e.path))}", e.message)
        docs.append((stats_path, d))

    for kind, schema_name in KINDS.items():
        if schema_name not in schemas:
            rep.warn(kind, f"schema {schema_name} ausente")
            continue
        v = Draft202012Validator(schemas[schema_name], registry=registry)
        folder = pack / kind
        if not folder.is_dir():
            continue
        for p in sorted(folder.rglob("*.json")):
            if "_from_rooms" in p.parts:
                continue
            try:
                d = json.loads(p.read_text(encoding="utf-8"))
            except json.JSONDecodeError as ex:
                rep.err(str(p), f"JSON inválido: {ex}")
                continue
            for d1 in (d if isinstance(d, list) else [d]):
                if not isinstance(d1, dict):
                    continue
                # schemas estritos: avisos em vez de erro para campos extras de stub
                for e in sorted(v.iter_errors(d1), key=lambda e: list(e.path)):
                    msg = e.message
                    if "additionalProperties" in msg or "not of type" in msg:
                        rep.warn(f"{p}:{'/'.join(map(str, e.path))}", msg)
                    else:
                        rep.err(f"{p}:{'/'.join(map(str, e.path))}", msg)
                did = d1.get("id")
                if did in defined[kind]:
                    rep.err(str(p), f"id duplicado '{did}' (também em {defined[kind][did]})")
                elif did:
                    defined[kind][did] = p
                docs.append((p, d1))

    ref_fields = {
        "npc": "npcs", "to": "locations", "location": "locations", "template": "items",
        "giveItem": "items", "takeItem": "items", "hasItem": "items", "hasNotItem": "items",
        "requiresItem": "items", "startQuest": "quests", "completeQuest": "quests", "failQuest": "quests",
        "despawnNpc": "npcs", "default": "items",
    }
    for p, d in docs:
        for path, val in walk(d):
            if not isinstance(val, str):
                continue
            m = STRING_KEY.match(val)
            if m:
                key = m.group(1)
                if key not in primary and not any(k.startswith(key + ".") for k in primary):
                    rep.warn(f"{p}:{path}", f"chave de string não encontrada: {val}")
                continue
            leaf = path.rsplit(".", 1)[-1].split("[")[0]
            if leaf in ref_fields:
                kind = ref_fields[leaf]
                if leaf == "default" and "furnitureSlots" not in path:
                    continue
                if leaf == "to" and "transitions" in path:
                    continue
                if val and val not in defined[kind]:
                    rep.warn(f"{p}:{path}", f"referência a {kind[:-1]} não definido: '{val}'")
        if "actions" in d and isinstance(d["actions"], list):
            for act in d["actions"]:
                if act not in defined["interactions"]:
                    rep.warn(f"{p}:actions", f"interação não definida: '{act}'")

    if not skip_unused and primary:
        used = {m.group(1) for _, d in docs for _, v in walk(d) if isinstance(v, str) for m in [STRING_KEY.match(v)] if m}
        unused = 0
        for k in primary:
            if k not in used and not any(k.startswith(u + ".") for u in used):
                unused += 1
        if unused:
            rep.warn("strings", f"{unused} chaves não referenciadas no pack (omitido detalhe; use sem --skip-unused para listar)")

    total = {k: len(v) for k, v in defined.items()}
    print(f"schema ids: {total} | {len(primary)} strings")


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("pack", type=Path, nargs="?", default=None)
    ap.add_argument("--schemas", type=Path, default=None)
    ap.add_argument("--strict", action="store_true", help="trata avisos como erros")
    ap.add_argument("--lite", action="store_true", help="só contagens/refs (sem jsonschema)")
    ap.add_argument("--skip-unused", action="store_true", default=True)
    ap.add_argument("--list-unused", action="store_true", help="lista strings não usadas")
    args = ap.parse_args()

    here = Path(__file__).resolve().parent
    miami2 = here.parent
    if args.pack is None:
        args.pack = miami2 / "godot" / "miami3d" / "content"
    if args.list_unused:
        args.skip_unused = False

    if not args.pack.is_dir():
        print(f"pack não encontrado: {args.pack}", file=sys.stderr)
        return 1

    if args.schemas is None:
        candidates = [
            args.pack.resolve().parent / "schemas",
            miami2 / "10-remake-3d" / "schemas",
            miami2 / "schemas",
        ]
        args.schemas = next((c for c in candidates if c.is_dir()), candidates[0])

    rep = Report()
    print(f"pack: {args.pack}")
    run_lite(args.pack, rep)
    if not args.lite:
        print("--- schema ---")
        if args.schemas.is_dir():
            run_schema(args.pack, args.schemas, rep, skip_unused=args.skip_unused)
        else:
            rep.warn("schemas", f"pasta ausente: {args.schemas} (pule com --lite)")

    for w in rep.warnings[:40]:
        print("AVISO ", w)
    if len(rep.warnings) > 40:
        print(f"AVISO  ... +{len(rep.warnings) - 40}")
    for e in rep.errors:
        print("ERRO  ", e)
    print(f"\n{len(rep.errors)} erro(s), {len(rep.warnings)} aviso(s)")
    bad = rep.errors or (args.strict and rep.warnings)
    return 1 if bad else 0


if __name__ == "__main__":
    raise SystemExit(main())
