# Guia para criadores — packs / mods (Fase G)

Sem recompilar o APK: solte um pack em `user://mods/<id>/` (ou `res://mods/` no projeto).

## Estrutura mínima

```
meu_pack/
  pack.json
  locations/x.json      # opcional
  npcs/x.json
  quests/x.json
  items/x.json
  interactions/x.json
  jobs/x.json
  schedules/x.json
  strings/pt-BR.json
  dialogue/topics.json  # opcional (append)
```

### pack.json

```json
{
  "id": "meu_pack",
  "version": "0.1.0",
  "dependencies": ["base"],
  "priority": 10,
  "locale": "pt-BR"
}
```

`priority` menor carrega primeiro. `dependencies` avisa se o pack base/outro mod falta.

## Receitas

| Quero… | Arquivos |
|---|---|
| Novo local | `locations/x.json` + cena em `game/world/locations/` (ou reutilizar) + portal |
| Novo NPC | `npcs/x.json` + `schedules/x.json` |
| Nova missão | `quests/x.json` + strings |
| Novo móvel/roupa | `items/x.json` + GLB |
| Nova ação | `interactions/x.json` |
| Novo emprego | `jobs/x.json` |
| Novo assunto | `dialogue/topics.json` |

## Carregar no jogo

1. Defina `miami/phase` = `g` **ou** `Bootstrap.game.set_phase("g")` / `start_phase("g")`.
2. O bootstrap da fase G chama `MnModLoader.load_all`.
3. Ou manualmente: `Bootstrap.game.load_mods()`.

Exemplo versionado: `res://mods/example_pack/` (pier + pescador + missão).

## Validação

```bash
# pack base
python3 tools/validate_content.py miami3d/content --lite
# (strict quando schemas disponíveis)
```

Schemas do remake ficam em `Miami_2/10-remake-3d/schemas` — use-os ao publicar o `.zip`.
