# Boot — Miami Life

Fluxo de abertura (substitui splash Gameloft do Java original):

```
Coral Pulse (estúdio)  →  Loading Miami Life  →  Menu principal  →  Play
```

## Trocar nomes / arte

Edite só `content/brand.json`:

| Campo | Exemplo |
|---|---|
| `studio_name` / `studio_legal` | Seu estúdio (no lugar de Gameloft) |
| `game_title` | `Miami Life` |
| `assets.*` | Paths dos PNGs em `assets/ui/brand/` |

Sugestões de estúdio no JSON: Coral Pulse, Neon Palm Studio, Tideshift Interactive, Bayline Games, Sunset Circuit.

## Placeholders IA atuais

- `coral_pulse_studio.png` — marca do estúdio
- `miami_life_logo.png` — logo do game
- `miami_life_hero.png` — fundo full-bleed menu/loading
