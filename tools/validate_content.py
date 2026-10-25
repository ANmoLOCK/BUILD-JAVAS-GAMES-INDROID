#!/usr/bin/env python3
"""Valida um pack de conteúdo (content/ ou mods/<pack>/) contra os schemas em schemas/.

Além da validação estrutural (JSON Schema), confere referências cruzadas:
chaves de string (@...) existentes, ids de itens/NPCs/locais/interações/quests
referenciados que não foram definidos, e ids duplicados.

Uso:
    python3 tools/validate_content.py content/ [--schemas schemas/] [--strict]

Requer:  pip install jsonschema
"""
import argparse
import json
import re
import sys
from pathlib import Path

try:
    from jsonschema import Draft202012Validator
    from referencing import Registry, Resource
except ImportError:  # pragma: no cover
    sys.exit("instale a dependência: pip install jsonschema")

KINDS = {
    "locations": "location.schema.json",
    "npcs": "npc.schema.json",
    "items": "item.schema.json",
    "interactions": "interaction.schema.json",
    "quests": "quest.schema.json",
}
STRING_KEY = re.compile(r"^@([A-Za-z0-9_.]+)$")


def load_schemas(schema_dir: Path):
    registry = Registry()
    schemas = {}
    for p in schema_dir.glob("*.schema.json"):
        s = json.loads(p.read_text(encoding="utf-8"))
        schemas[p.name] = s
        registry = registry.with_resource(p.name, Resource.from_contents(s))
        registry = registry.with_resource(s.get("$id", p.name), Resource.from_contents(s))
    return schemas, registry


def walk(obj, path=""):
    """Gera (caminho, valor) para todas as folhas."""
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


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("pack", type=Path)
    ap.add_argument("--schemas", type=Path, default=Path(__file__).resolve().parent.parent / "schemas")
    ap.add_argument("--strict", action="store_true", help="trata avisos como erros")
    a = ap.parse_args()

    schemas, registry = load_schemas(a.schemas)
    rep = Report()
    defined = {k: {} for k in KINDS}
    docs = []

    pack_json = a.pack / "pack.json"
    if not pack_json.exists():
        rep.err(str(pack_json), "pack.json ausente")
    else:
        docs.append((pack_json, json.loads(pack_json.read_text(encoding="utf-8"))))

    strings = {}
    for sp in (a.pack / "strings").glob("*.json"):
        strings[sp.stem] = json.loads(sp.read_text(encoding="utf-8"))
    if not strings:
        rep.warn(str(a.pack / "strings"), "nenhum arquivo de strings")
    primary = next(iter(strings.values()), {})

    stats_path = a.pack / "stats.json"
    if stats_path.exists():
        d = json.loads(stats_path.read_text(encoding="utf-8"))
        v = Draft202012Validator(schemas["stats.schema.json"], registry=registry)
        for e in sorted(v.iter_errors(d), key=lambda e: list(e.path)):
            rep.err(f"{stats_path}:{'/'.join(map(str, e.path))}", e.message)
        docs.append((stats_path, d))

    for kind, schema_name in KINDS.items():
        v = Draft202012Validator(schemas[schema_name], registry=registry)
        for p in sorted((a.pack / kind).glob("*.json")):
            try:
                d = json.loads(p.read_text(encoding="utf-8"))
            except json.JSONDecodeError as ex:
                rep.err(str(p), f"JSON inválido: {ex}")
                continue
            # um arquivo pode conter uma definição ou uma lista delas
            for d1 in (d if isinstance(d, list) else [d]):
                for e in sorted(v.iter_errors(d1), key=lambda e: list(e.path)):
                    rep.err(f"{p}:{'/'.join(map(str, e.path))}", e.message)
                did = d1.get("id") if isinstance(d1, dict) else None
                if did in defined[kind]:
                    rep.err(str(p), f"id duplicado '{did}' (também em {defined[kind][did]})")
                elif did:
                    defined[kind][did] = p
                docs.append((p, d1))

    # Referências cruzadas
    ref_fields = {
        "npc": "npcs", "to": "locations", "location": "locations", "template": "items",
        "giveItem": "items", "takeItem": "items", "hasItem": "items", "hasNotItem": "items",
        "requiresItem": "items", "startQuest": "quests", "completeQuest": "quests", "failQuest": "quests",
        "despawnNpc": "npcs", "default": "items",
    }
    for p, d in docs:
        for path, val in walk(d):
            if isinstance(val, str):
                m = STRING_KEY.match(val)
                if m:
                    key = m.group(1)
                    # prefixos de saudação (@greet.x) resolvem para @greet.x.0..4
                    if key not in primary and not any(k.startswith(key + ".") for k in primary):
                        rep.err(f"{p}:{path}", f"chave de string não encontrada: {val}")
                    continue
                leaf = path.rsplit(".", 1)[-1].split("[")[0]
                if leaf in ref_fields:
                    kind = ref_fields[leaf]
                    if leaf == "default" and "furnitureSlots" not in path:
                        continue
                    if leaf == "to" and "transitions" in path:  # destino é um stage, não um local
                        continue
                    if val not in defined[kind]:
                        rep.warn(f"{p}:{path}", f"referência a {kind[:-1]} não definido neste pack: '{val}'")
        if "actions" in d and isinstance(d["actions"], list):
            for act in d["actions"]:
                if act not in defined["interactions"]:
                    rep.warn(f"{p}:actions", f"interação não definida neste pack: '{act}'")
        if "quest" in json.dumps(d):
            for path, val in walk(d):
                if path.endswith("quest.id") or path.endswith("setStage.quest"):
                    if val not in defined["quests"]:
                        rep.warn(f"{p}:{path}", f"quest não definida neste pack: '{val}'")

    # Chaves de string nunca usadas
    used = {m.group(1) for _, d in docs for _, v in walk(d) if isinstance(v, str) for m in [STRING_KEY.match(v)] if m}
    for k in primary:
        if k not in used and not any(k.startswith(u + ".") for u in used):
            rep.warn(f"strings:{k}", "chave de string não usada")

    for w in rep.warnings:
        print("AVISO ", w)
    for e in rep.errors:
        print("ERRO  ", e)
    total = {k: len(v) for k, v in defined.items()}
    print(f"\n{total} | {len(primary)} strings | {len(rep.errors)} erro(s), {len(rep.warnings)} aviso(s)")
    bad = rep.errors or (a.strict and rep.warnings)
    sys.exit(1 if bad else 0)


if __name__ == "__main__":
    main()
