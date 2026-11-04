# Neon Nightlife — personagem principal (M + F)

Estilo **Everwind híbrido 2D/3D** implementado no Miami Life.

## O que entra no jogo

| Peça | Path |
|------|------|
| Corpo M/F | `textures/body_*_front.jpg` |
| Faces (6 expressões × 2) | `faces/faces_sheet.jpg` |
| Avarias (6 estados) | `overlays/avarias_sheet.jpg` |
| Presets | `manifest.json` + `content/appearance_presets.json` |

## Runtime

- `MnNeonPartFactory` — billboard 2D + volume 3D + face + óculos (M)
- `MnPaperDoll` — detecta vetor Neon e monta o híbrido
- `MnAnimController` — todos os clips de `MnAnimationMap` (idle/walk/run/dance_*/fight/faint/…)
- Avarias: `dirty · wet · bruised · sweaty · dusty · tired` via higiene/energia/flags

## Vetores

```
M [0, 2, 8, 0, 12, 4, 10, 0, 6, 0]
F [1, 2, 10, 0, 18, 0, 8, 0, 9, 0]
```

Creator default = Neon Nightlife. `new_game` grava o vetor no appearance system.
