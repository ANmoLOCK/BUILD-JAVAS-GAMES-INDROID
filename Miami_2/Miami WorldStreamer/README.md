# Miami WorldStreamer

Pacote de **streaming por chunks** para o remake 3D — cidade contínua outdoor, indoor discreto, **sem quebrar** `enter_location` / fases / saves.

## Como funciona

- **Default do jogo:** modo `discrete` (igual hoje — 1 local por vez).
- **Opt-in:** `miami/world_mode=stream` no `project.godot` (ou `Bootstrap.world_mode`).
- Outdoor vira costura caminhável entre quarteirões (`MnWorldStreamer`).
- Indoor continua em `MnLocationController`.
- O cérebro só vê `location_id`; coords globais ficam no corpo.

Ver [ARCHITECTURE.md](./ARCHITECTURE.md).

## Conteúdo

| Arquivo | Papel |
|---|---|
| `content/world_map.json` | Âncoras, chunks 64×64, seams outdoor |
| `godot/*.gd` | `MnChunkCatalog`, `MnWorldCoords`, `MnChunkView`, `MnWorldStreamer`, `MnStreamBridge` |
| `tools/validate_world_streamer.py` | Valida âncoras vs `content/locations` |
| `tools/install_into_miami3d.sh` | Copia runtime para o projeto Godot |

## Instalar no projeto Godot

```bash
bash "Miami_2/Miami WorldStreamer/tools/install_into_miami3d.sh"
```

Isso atualiza:

- `miami3d/game/world/streamer/*.gd`
- `miami3d/content/world_streamer/world_map.json`

## Ativar streaming

Em `miami3d/project.godot`:

```ini
[miami]
world_mode="stream"
```

Ou no menu/debug: `Bootstrap.set_world_mode("stream")`.

Voltar ao clássico: `world_mode="discrete"`.

## Validar

```bash
python3 "Miami_2/Miami WorldStreamer/tools/validate_world_streamer.py"
```
