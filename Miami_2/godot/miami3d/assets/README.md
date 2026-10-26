# assets/ — músculos do Miami 3D

Arte e áudio do remake. **Não** contém assets Gameloft; só placeholders + contratos de path.

| Pasta | Conteúdo |
| --- | --- |
| `models/characters/` | `rig_human.glb` + paper-doll (heads/hair/tops/bottoms/shoes) |
| `models/npc_unique/` | Cabeças do elenco |
| `models/furniture/` | Catálogo de móveis (~60) |
| `models/props/` | Props / decoração |
| `models/pets/` | Cães, gato, ave, crocodilo |
| `models/kits/<local>/` | Chão/parede por local |
| `animations/` | Biblioteca de clipes humanos |
| `textures/` | PBR shared + por kit/região |
| `audio/` | Música e SFX (OGG) |
| `ui/` | Ícones HUD / itens / logo |

## Como funciona no jogo

`MnAssetRegistry` resolve `id` → path. Se o `.glb`/`.ogg` ainda não existe, usa
`models/_shared/placeholder.glb` ou malha procedural (`MnMeshFactory`).

Quando a arte final chegar: grave o arquivo no path do `manifest` / `.stub.json` e
remova o stub (ou marque `"status": "ready"`).

## Regenerar árvore

```bash
python3 tools/scaffold_assets.py
python3 tools/validate_assets.py
```
