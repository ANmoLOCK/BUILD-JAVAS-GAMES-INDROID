# tools/ — extração, validação e ponte Godot

Python 3 (≥ 3.8). As ferramentas `mn2_*` usam **apenas a biblioteca padrão** e
regeneram, a partir do JAR em `../00-original/`, as pastas `01`–`08` de `Miami_2/`.

Atalho a partir do projeto Godot:

```bash
cd godot/miami3d
./tools/run_tools_pipeline.sh help
```

## Mapa da etapa

| Arquivo | Função |
| --- | --- |
| `mn2_extract_all.py` (+ `mn2_unpack` / `strings` / `asprite` / `rooms`) | Regenera referência 2D |
| `validate_content.py` | Valida packs (`--lite` sem jsonschema) |
| `room_to_godot.py` | `07-salas/room_NN.json` → placeholders de cena + JSON |
| `appearance_preview.py` | Preview PNG do vetor paper-doll |
| `../godot/miami3d/tests/test_*.gd` | Testes headless do cérebro |
| `../godot/miami3d/tests/text_day.gd` | “Jogo de texto” de um dia |

## Tudo de uma vez (extração)

```bash
cd Miami_2
python3 tools/mn2_extract_all.py "00-original/Miami 2 PR-BR.jar" . --cfr /caminho/cfr.jar
```

## Validar o pack do remake

```bash
# rápido (contagens + refs) — padrão recomendado no dia a dia
python3 tools/validate_content.py godot/miami3d/content --lite

# completo (JSON Schema) — requer: pip install jsonschema
python3 tools/validate_content.py godot/miami3d/content
python3 tools/validate_content.py godot/miami3d/content --strict
```

## Salas → Godot

```bash
python3 tools/room_to_godot.py 07-salas --all
# escreve:
#   godot/miami3d/content/locations/_from_rooms/<id>.from_room.json
#   godot/miami3d/game/world/locations/_generated/room_NN.tscn
#   tools/_out/room_to_godot_report.md
```

Os JSON `.from_room` são rascunhos (grade/blocked/objetos genéricos). Locais curados
(`player_apartment`, etc.) não são sobrescritos a menos que `--write-live`.

## Paper-doll preview

```bash
python3 tools/appearance_preview.py --vector 0,1,3,2,4,1,2,0,1,3 -o /tmp/doll.png
python3 tools/appearance_preview.py --npc landlord -o /tmp/landlord.png
python3 tools/appearance_preview.py --gallery -o godot/miami3d/assets/ui/previews/
```

## Passo a passo (ferramentas individuais)

```bash
python3 tools/mn2_unpack.py "00-original/Miami 2 PR-BR.jar" /tmp/mn2
python3 tools/mn2_strings.py /tmp/mn2 /tmp/mn2/strings.json --txt
python3 tools/mn2_asprite.py /tmp/mn2 /tmp/mn2/png
python3 tools/mn2_rooms.py /tmp/mn2 /tmp/mn2/rooms
```

## Dependências

* `mn2_*.py`, `room_to_godot.py`, `appearance_preview.py`: só stdlib.
* `validate_content.py` (modo schema): `jsonschema >= 4.18`.
* Testes Godot: `godot4` no PATH (opcional; senão use `--lite` / `validate_assets.py`).
