# game/ — corpo do jogo (Godot 4)

Camada visual/input. O **cérebro** fica em `core/` (GDScript) e `../native/` (C++).
Esta pasta só mostra o mundo, coleta toque e pede ações ao `BrainFacade`.

```
game/
  bootstrap.gd          Autoload — sobe o cérebro + tick_real
  brain_facade.gd       Comandos corpo→cérebro (C++ ou GDScript)
  event_bridge.gd       Sinais cérebro→corpo (luz, toast, NPC, save…)
  main.tscn / main.gd   Splash → Menu → Play
  flow/                 Splash, menu, play_root (loop 3D)
  world/                Grade, location_controller, portais, zonas
  world/locations/      Uma cena por local (25 + jardim)
  actors/               Player, NPC, Pet, paper-doll
  objects/              Interativos e slots de móvel
  camera/               Câmera isométrica 3/4
  ui/                   HUD, radial, toast, phone, mapa, loja…
  minigames/            Dança, foto, cartazes
  fx/                   Corações, Zzz, fedor, moscas, estrelas
  phases/               Conteúdo extra por fase (A/B/C…)
```

**Regra:** não coloque lógica de stats/missões aqui — chame `Bootstrap.game` (comandos) e deixe o `MnEventBridge` reagir aos sinais.
**Contrato:** ver `../core/EVENT_CONTRACT.md`.
**Fases:** ver `phases/README.md` e `content/phases.json`. Locais cumulativos; sistemas com `min_phase`.
Troque `miami/phase` no `project.godot` (a…g) ou chame `Bootstrap.game.set_phase("d")`.

## Fluxo de execução

1. `Bootstrap` instancia `BrainFacade` (C++ se `.so` presente) e chama `tick_real` todo frame.
2. `main.tscn` mostra splash → menu (novo/continuar).
3. `flow/play_root.tscn` liga o `MnEventBridge` e carrega o local via `MnLocationController`.
4. Toque no chão = pathfinding; objeto = radial → `interact`; NPC = social → `talk`; loja/ATM/closet → `buy` / `use_phone` / `equip`.

## Locais

Definição em `content/locations/*.json`. A cena em `world/locations/<id>.tscn` só instancia o controller genérico; o JSON manda a grade/objetos/NPCs.
