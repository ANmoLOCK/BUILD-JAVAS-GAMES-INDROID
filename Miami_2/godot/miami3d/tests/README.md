# tests/ — cérebro headless

Suites no estilo SceneTree (sem dependência de GUT/gdUnit4). Cada arquivo é
executável sozinho:

```bash
cd miami3d
godot4 --path . --headless -s res://tests/text_day.gd
godot4 --path . --headless -s res://tests/test_stats.gd
./tests/run_all.sh
```

| Script | Cobre |
| --- | --- |
| `text_day.gd` | 24 h + ações + save/load (GDScript) |
| `text_day_native.gd` | Idem via `MnBrain` C++ |
| `test_content_registry.gd` | Contagens do pack |
| `test_stats.gd` | Stats / efeitos |
| `test_economy.gd` | Cash, banco, aluguel |
| `test_asset_registry.gd` | Assets / anim map |
| `test_interactions.gd` | Dormir / banho / portal |
| `test_event_commands.gd` | Contrato: phone/buy/equip/furniture/minigame/time |
| `test_phases.gd` | Fases A–G: locais cumulativos + sistemas |
| `test_phase_ops.gd` | Bootstrap A–G, checklist, merge de mods |
| `run_all.sh` | CI local |

Se `godot4` não estiver no PATH, `run_all.sh` cai na validação Python do pack/assets.
