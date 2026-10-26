# Fases progressivas 0–G (operacionais)

Fonte: `content/phases.json` · runtime: `MnPhaseCatalog` + `MnPhaseDirector` + `MnModLoader`.

## Fase 0 — Base ✅
Extração 00–08, docs, schemas, tools (`validate_content.py`, `mn2_extract_all.py`).

## A–G — o que o diretor faz no New Game

| Fase | Bootstrap | Pronto quando |
|---|---|---|
| A | Apto LOW, necessidades | 1 dia sem desmaio |
| B | `q_landlord`, $40, NPC landlord | tutorial senhorio + jardim |
| C | `south_beach` + missões q001–q005 | praia → chaves do apto |
| D | unlock empregos + NPCs Huggy/Hal/… | 4 jobs pagam e avançam tempo |
| E | `q_gnomes`, dating/casa/pets | namoro, anões, pet |
| F | todos locais restantes, home tier ≥1 | checklist 04 / final |
| G | `load_mods` (`user://mods` + `res://mods`) | zip de mod aparece no jogo |

API:

```gdscript
Bootstrap.game.start_phase("c")     # bootstrap completo
Bootstrap.game.set_phase("d")       # só unlocks
Bootstrap.game.audit_phase("b")     # checklist arquivos/content
Bootstrap.game.load_mods()          # Fase G
```

Menu principal: seletor de fase A–G antes de Novo jogo.

## Expansão (G)
Ver `game/phases/g_mods/CRIADORES.md` e `mods/example_pack/`.
