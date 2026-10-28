# miami3d — projeto Godot 4.3

Abra **este** `project.godot` no Godot 4.3+.

## Pastas

| Pasta | O que é | Quem mexe |
|---|---|---|
| `core/` | Cérebro + `EVENT_CONTRACT.md` + `phase_catalog.gd` | Estável — só estende |
| `game/` | Corpo 3D + event bridge + fachada | Cresce por fase |
| `game/flow/` | Splash → menu → play_root | Loop principal |
| `game/world/locations/` | 25 cenas de local (controller + JSON) | Mundo |
| `game/world/streamer/` | WorldStreamer (chunks + coords globais, opt-in) | Quase open-world |
| `content/world_streamer/` | `world_map.json` (âncoras / chunks) | Mundo contínuo |
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

## WorldStreamer (quase open-world)

Pacote fonte: `Miami_2/Miami WorldStreamer/`.

- Default: `miami/world_mode="discrete"` (jogo clássico por local — **não quebra**).
- Opt-in: `miami/world_mode="stream"` → carrega quarteirões perto do player; indoor continua discreto.
- Reinstalar cópia no projeto: `bash "../Miami WorldStreamer/tools/install_into_miami3d.sh"` (a partir de `miami3d` use o path do pacote).

## Android

Preset em `export_presets.cfg` (`com.miami3d.game`). Precisa do Android Build Template no Godot.
