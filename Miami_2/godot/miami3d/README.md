# miami3d — projeto Godot 4.3

Abra **este** `project.godot` no Godot 4.3+.

## Pastas

| Pasta | O que é | Quem mexe |
|---|---|---|
| `core/` | Cérebro + `EVENT_CONTRACT.md` + `phase_catalog.gd` | Estável — só estende |
| `game/` | Corpo 3D + event bridge + fachada | Cresce por fase |
| `game/flow/` | Splash → menu → play_root | Loop principal |
| `game/world/locations/` | 25 cenas de local (controller + JSON) | Mundo |
| `game/phases/` | Pastas A–G + boot/checklist + CRIADORES | Progressão |
| `content/phases.json` | Locais, sistemas, bootstrap A–G | Conteúdo |
| `mods/` | Packs externos (exemplo Fase G) | Expansão |
| `core/phase_director.gd` | New Game por fase + audit | Cérebro |
| `content/` | Pack JSON completo (25 locais, 94 NPCs, 99 missões, 4 jobs…) | Conteúdo |
| `assets/` | Models, animações, texturas, áudio, UI (placeholders) | Arte |
| `tools/` | generate/validate content + assets + `run_tools_pipeline.sh` | Conteúdo/Arte |
| `tests/` | `test_*.gd`, `text_day.gd`, `run_all.sh` | CI / local |
| `tests/` | Testes headless do cérebro | CI / local |

## Rodar

```bash
# Editor
godot4 miami3d/project.godot

# Teste do cérebro (24 h + ações + save)
godot4 --headless -s miami3d/tests/text_day.gd
# (rode de dentro de miami3d/ ou passe --path miami3d)
```

## Android

Preset em `export_presets.cfg` (`com.miami3d.game`). Precisa do Android Build Template no Godot.
