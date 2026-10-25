# BUILD-JAVAS-GAMES-INDROID

Engenharia reversa de jogos Java (J2ME) para servir de base a remakes **3D nativos para
Android**. Primeiro título: **Miami Nights 2: The City Is Yours** (Gameloft, 2009).

## O que há aqui

| Pasta | Conteúdo |
|---|---|
| `docs/` | Documentação completa da engenharia reversa e do plano de remake (em português) |
| `tools/` | Scripts Python que extraem e decodificam todos os formatos do JAR original e validam o conteúdo do remake |
| `schemas/` | JSON Schema do formato de conteúdo do remake (locais, NPCs, itens, interações, missões, stats) |
| `content/` | Pacote de conteúdo de exemplo (apartamento + rua + senhorio + 2 missões) que valida contra os schemas |

### Documentação

1. [`01-visao-geral.md`](docs/01-visao-geral.md) — identificação do jogo, estrutura do JAR, resumo técnico
2. [`02-formatos-de-arquivo.md`](docs/02-formatos-de-arquivo.md) — índice de recursos, LZMA, strings, ASprite, salas, scripts, save
3. [`03-sistemas-de-jogo.md`](docs/03-sistemas-de-jogo.md) — mundo iso, movimento/A\*, tempo, necessidades, relacionamentos, diálogo, missões, economia, paper-doll, apartamento
4. [`04-inventario-de-conteudo.md`](docs/04-inventario-de-conteudo.md) — 25 locais, 97 NPCs, 16 stats, 139 ações, 99 missões, itens, empregos
5. [`05-arquitetura-android-3d.md`](docs/05-arquitetura-android-3d.md) — escolha de engine (Godot 4 / Kotlin+Filament), camadas, mapeamento 2D→3D, save, build Android
6. [`06-pipeline-de-conteudo.md`](docs/06-pipeline-de-conteudo.md) — formato JSON, linguagem de regras, receitas para adicionar conteúdo, pipeline de arte
7. [`07-roadmap.md`](docs/07-roadmap.md) — fases de implementação com critérios de pronto

### Início rápido

```bash
# extrair e decodificar o jogo original (saída em build/, ignorada pelo git)
python3 tools/mn2_unpack.py "Miami 2 PR-BR.jar" build/mn2
python3 tools/mn2_strings.py build/mn2 build/mn2/strings.json --txt
python3 tools/mn2_asprite.py build/mn2 build/mn2/png
python3 tools/mn2_rooms.py build/mn2 build/mn2/rooms

# validar o conteúdo do remake
pip install jsonschema
python3 tools/validate_content.py content/ --strict
```

## Aviso legal

O JAR, seu código, arte, textos e áudio pertencem à Gameloft. Este repositório contém apenas
documentação e ferramentas; **nenhum recurso extraído é redistribuído** e o remake deve usar
arte, música e textos próprios.
