# content/ — pack base do Miami 3D

Dados do remake (sem arte). O cérebro (`core/` / `native/`) e o corpo (`game/`) só leem daqui via `MnContentRegistry`.

Alinhado ao inventário `09-engenharia-reversa-docs/04-inventario-de-conteudo.md` e ao pipeline `06-pipeline-de-conteudo.md`.

## Layout

| Arquivo / pasta | Cobre |
| --- | --- |
| `pack.json` | Metadados do pack base |
| `stats.json` | 16 stats + prisão/fiança |
| `strings/pt-BR.json` (+ `en.json` stub) | Textos do remake |
| `locations/*.json` | 25 locais (+ jardim) |
| `npcs/*.json` | 94 nomes / slots (elenco + genéricos) |
| `items/*.json` | Props, móveis, roupas, presentes, quest, pets |
| `interactions/*.json` | Ações de objeto + sociais |
| `quests/*.json` | 99 missões (+ `q_landlord` / `q_gnomes` curadas) |
| `dialogue/topics.json` | 38 categorias × 175 interesses |
| `dialogue/reactions.json` | Ofendido / tédio / saudações |
| `jobs/*.json` | 4 empregos |
| `schedules/*.json` | Rotinas reutilizáveis |
| `achievements.json` | 19 títulos |
| `regions.json` | 9 regiões do mapa |
| `gifts.json` | 8 presentes |
| `surgery.json` | Lipo / rino / lifting / implantes |
| `rent.json` | $300 / mansão $2000 |

## Regenerar

Textos e catálogos vêm dos packs extraídos em `Miami_2/05-strings/`:

```bash
python3 tools/generate_content_pack.py
python3 tools/validate_content_pack.py
```

Arquivos curados (apartamento, senhorio, dormir…) estão em `PRESERVE` no gerador e não são sobrescritos.

## Regra

Novo conteúdo = novo JSON (ou entrada no array do arquivo de categoria). Não copie lógica de stats/missões para `game/` — o cérebro interpreta estes dados.
