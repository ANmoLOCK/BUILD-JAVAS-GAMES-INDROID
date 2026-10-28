# Arquitetura — Miami WorldStreamer (nível 2)

## Objetivo

Cidade **contínua ao ar livre** com **streaming por chunks**, sem quebrar o contrato do cérebro (`enter_location`, quests, fases, saves).

## Dual mode (não quebra o game)

| Modo | Quem carrega o mundo | Quando |
|---|---|---|
| `discrete` (padrão) | `MnLocationController` — 1 local por vez | Compatível com tudo que já existe |
| `stream` | `MnWorldStreamer` — N chunks perto do player | Opt-in via `miami/world_mode=stream` |

Indoor **sempre** usa o caminho discreto (overlay / troca de cena). Outdoor em `stream` vira costura caminhável.

## Contrato cérebro ↔ corpo

```
cérebro (MnGame)                corpo (streamer)
─────────────────               ─────────────────
enter_location(id, spawn)  →    focus_location / ensure_chunk
leave_location()           →    (noop em costura outdoor; unload indoor)
world.location_id          ←    sync quando player cruza POI/zona
world.cell (local)         ↔    global_cell via MnWorldCoords
```

O cérebro **não** conhece chunks. Quests, NPCs e unlocks continuam por `location_id`.

## Coords globais

```
global_cell = origin_cell(location) + local_cell
world_pos   = (global_cell + 0.5) * cell_size   # XZ, Y=0
chunk_coord = floor(global_cell / chunk_size)
```

Âncoras em `content/world_map.json` → `anchors[location_id]`.

## Streaming

1. Player em `global_cell` → `chunk_coord`
2. Carrega chunks com Chebyshev ≤ `load_radius`
3. Descarta chunks com distância > `unload_radius`
4. Cada chunk outdoor instancia 1+ `MnChunkView` (JSON do local + offset)
5. Grade composta (`MnGridMap` global) alimenta pathfinding do player

## Portais

| Tipo | Em `stream` | Em `discrete` |
|---|---|---|
| outdoor → outdoor (seam) | Anda / teleporte de costura + `enter_location` sync | Troca cena |
| outdoor → indoor | Pause streamer + `LocationController.load` | Troca cena |
| indoor → outdoor | Fecha indoor + `streamer.focus_location` | Troca cena |
| city_map travel | `streamer.focus` se outdoor; senão discreto | Igual hoje |

## Pastas

```
Miami_2/Miami WorldStreamer/     ← pacote (fonte + docs)
  content/world_map.json
  godot/*.gd
  tools/validate_world_streamer.py
  tools/install_into_miami3d.sh

miami3d/game/world/streamer/     ← runtime Godot (cópia instalada)
miami3d/content/world_streamer/  ← world_map no res://
```

## Migração segura

1. Ship com `mode_default: discrete`
2. Validar âncoras com `validate_world_streamer.py`
3. Ativar `stream` em playtest (First Street ↔ Downtown)
4. Só então tornar stream o default de uma fase futura
