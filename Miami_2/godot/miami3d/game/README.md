# game/ — corpo do jogo (Godot 4)

Camada visual/input. O **cérebro** fica em `core/` (GDScript) e `../native/` (C++).
Esta pasta só mostra o mundo, coleta toque e pede ações ao `BrainFacade`.

```
game/
  bootstrap.gd          Autoload — sobe o cérebro
  brain_facade.gd       C++ MnBrain ou GDScript MnGame
  main.tscn / main.gd   Splash → Menu → Play
  flow/                 Splash, menu, play_root (loop 3D)
  world/                Grade, location_controller, portais, zonas
  world/locations/      Uma cena por local (25 + jardim)
  actors/               Player, NPC, Pet, paper-doll
  objects/              Interativos e slots de móvel
  camera/               Câmera isométrica 3/4
  ui/                   HUD, radial, social, phone, mapa…
  minigames/            Dança, foto, cartazes
  fx/                   Corações, Zzz, fedor, moscas, estrelas
  phases/               Conteúdo extra por fase (A/B/C…)
```

**Regra:** não coloque lógica de stats/missões aqui — chame `Bootstrap.game`.
**Fases:** cenas específicas de fase vão em `phases/<letra>_*/`; sistemas genéricos ficam acima.

## Fluxo de execução

1. `Bootstrap` instancia `BrainFacade` (C++ se `.so` presente).
2. `main.tscn` mostra splash → menu (novo/continuar).
3. `flow/play_root.tscn` carrega o local atual via `MnLocationController` + player + `MnIsoCamera`.
4. Toque no chão = pathfinding; toque em objeto = menu radial; NPC = menu social.

## Locais

Definição em `content/locations/*.json`. A cena em `world/locations/<id>.tscn` só instancia o controller genérico; o JSON manda a grade/objetos/NPCs.
