# Fase G — Mods / packs externos

Sem locais fixos. Packs em `res://mods/` ou `user://mods/` com `pack.json`.
Loader: `core/mod_loader.gd` · guia: `CRIADORES.md` · exemplo: `res://mods/example_pack/`.

```gdscript
Bootstrap.game.start_phase("g")
Bootstrap.game.load_mods()
```
