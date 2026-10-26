# miami3d — projeto Godot 4.3

Abra **este** `project.godot` no Godot 4.3+.

## Pastas

| Pasta | O que é | Quem mexe |
|---|---|---|
| `core/` | Cérebro operacional (RefCounted, sem Node) | Estável — só estende |
| `game/` | Corpo: bootstrap, main, UI, phases | Cresce por fase |
| `game/phases/a_apartment/` | Cenas/UI da Fase A | Fase A |
| `game/phases/b_social/` | Reserva Fase B | Fase B |
| `content/` | Pack JSON do remake | Conteúdo |
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
