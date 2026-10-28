# Miami_2 — Miami Nights 2: The City Is Yours (Gameloft, 2009)

Pasta central com **tudo** o que foi extraído do JAR `Miami 2 PR-BR.jar`, organizado por
etapa de engenharia reversa, mais a documentação, as ferramentas e a base do remake 3D.

**Atalhos:** código principal do jogo → [`02-codigo-descompilado/f.java`](02-codigo-descompilado/f.java) ·
entrada (MIDlet) → [`GloftMMN2.java`](02-codigo-descompilado/GloftMMN2.java) ·
regras do jogo → [`03-sistemas-de-jogo.md`](09-engenharia-reversa-docs/03-sistemas-de-jogo.md) ·
plano 3D Android → [`05-arquitetura-android-3d.md`](09-engenharia-reversa-docs/05-arquitetura-android-3d.md) ·
**plano progressivo** → [`08-plano-progressivo-godot.md`](09-engenharia-reversa-docs/08-plano-progressivo-godot.md) ·
**projeto Godot 4 (comece a jogar/implementar aqui)** → [`godot/README.md`](godot/README.md)

## Do que se trata, em poucas palavras

*Miami Nights 2* é um simulador de vida (estilo *The Sims*) para celulares de 2009: você cria
um personagem, cuida de fome, sono, higiene e banheiro, faz amigos e namora, trabalha, paga
aluguel, decora o apartamento e cumpre 99 missões por 25 locais de Miami, em visão isométrica.
Esta pasta desmonta o jogo original peça por peça e documenta cada formato e regra para que
ele possa ser recriado em 3D no Android, com um sistema de conteúdo em JSON que permite
acrescentar novos locais, personagens e missões sem recompilar o jogo.

| Etapa | Pasta | Arquivos | O que é |
|---|---|---|---|
| 00 | [`00-original/`](00-original) | 1 | O JAR original (654 KB, MIDlet `GloftMMN2` v1.0.3) |
| 01 | [`01-jar-extraido/`](01-jar-extraido) | 50 | Conteúdo bruto do JAR: 7 classes, `META-INF/MANIFEST.MF`, índice `0`, 38 packs `RES_*` (LZMA), `icon.png`, `menutitle.png`, `dataIGP` |
| 02 | [`02-codigo-descompilado/`](02-codigo-descompilado) | 8 | Fontes Java recuperadas com CFR (`f.java` = 33 k linhas do jogo) + [`CLASSES.md`](02-codigo-descompilado/CLASSES.md) com o papel de cada classe |
| 03 | [`03-indice-e-packs/`](03-indice-e-packs) | 32 | Índice `0` decodificado ([`indice.json`](03-indice-e-packs/indice.json), [`indice.csv`](03-indice-e-packs/indice.csv)) e os 30 packs não vazios descomprimidos em `packs/` |
| 04 | [`04-entradas/`](04-entradas) | 606 | As 1 039 entradas de recurso separadas por pack (`NN_RES_*/`), cada uma com id, nome e extensão (`0102_strings_pack00_….bin`, `0170_sala00_mapa.bin`, `0672_esqueleto_paperdoll_masc.asprite`…) — 433 vazias omitidas |
| 05 | [`05-strings/`](05-strings) | 58 | 3 640 textos pt-BR: [`strings.json`](05-strings/strings.json), `strings_todos.txt` e um `.txt` por pacote (`pack18_missoes.txt`, `pack11_nomes_de_npc.txt`, `pack21_falas_de_topico.txt`…) |
| 06 | [`06-sprites/`](06-sprites) | 1 305 | 430 sprites ASprite renderizados: `_frames_palK.png` (uma folha por paleta), `_modules.png` e `.json` com as animações (ex.: `34_RES_CHARACTER/0672_…` = esqueleto de 237 animações) |
| 07 | [`07-salas/`](07-salas) | 23 | Os 11 mapas: `room_NN.txt` (grade ASCII com paredes, portas, zonas), `room_NN.json` (objetos, NPCs, spawn, gatilhos, eventos, bytecode) e `rooms_summary.json` |
| 08 | [`08-audio/`](08-audio) | 29 | 25 músicas MIDI + 4 efeitos WAV |
| 09 | [`09-engenharia-reversa-docs/`](09-engenharia-reversa-docs) | 7 | Documentação: formatos, sistemas de jogo, inventário, arquitetura Android 3D, pipeline de conteúdo, roadmap |
| 10 | [`10-remake-3d/`](10-remake-3d) | — | Base do remake: `schemas/` (JSON Schema do conteúdo) e `content/` (pack de exemplo validado) |
| — | [`Miami WorldStreamer/`](Miami%20WorldStreamer) | — | Quase open-world: streaming por chunks + coords globais (opt-in, sem quebrar discrete) |
| — | [`tools/`](tools) | 7 | Scripts Python que geram as etapas 01–08 a partir do JAR e validam o conteúdo do remake |
| — | [`CATALOGO.md`](CATALOGO.md) | 1 | Tabela das 1 039 entradas: id, pack, tipo, bytes, nome |

## Documentação (etapa 09)

1. [`01-visao-geral.md`](09-engenharia-reversa-docs/01-visao-geral.md) — identificação, estrutura do JAR, resumo técnico
2. [`02-formatos-de-arquivo.md`](09-engenharia-reversa-docs/02-formatos-de-arquivo.md) — índice, LZMA, strings, ASprite, salas, opcodes de script, save
3. [`03-sistemas-de-jogo.md`](09-engenharia-reversa-docs/03-sistemas-de-jogo.md) — iso, A\*, tempo, necessidades, relacionamentos, diálogo, missões, economia, paper-doll
4. [`04-inventario-de-conteudo.md`](09-engenharia-reversa-docs/04-inventario-de-conteudo.md) — 25 locais, 97 NPCs, 139 ações, 99 missões, itens
5. [`05-arquitetura-android-3d.md`](09-engenharia-reversa-docs/05-arquitetura-android-3d.md) — Godot 4 / Kotlin+Filament, mapeamento 2D→3D, save, build
6. [`06-pipeline-de-conteudo.md`](09-engenharia-reversa-docs/06-pipeline-de-conteudo.md) — formato JSON, linguagem de regras, como adicionar conteúdo
7. [`07-roadmap.md`](09-engenharia-reversa-docs/07-roadmap.md) — fases de implementação (resumo)
8. [`08-plano-progressivo-godot.md`](09-engenharia-reversa-docs/08-plano-progressivo-godot.md) — **plano operacional**: cérebro, mapa de arquivos, checklist do inventário, fases A–H e caminho para mods

## Regenerar tudo

```bash
cd Miami_2
python3 tools/mn2_extract_all.py "00-original/Miami 2 PR-BR.jar" . --cfr /caminho/cfr.jar
python3 tools/validate_content.py 10-remake-3d/content --strict
```

## Como navegar pelos ids

* Entrada `NNNN` → linha em [`CATALOGO.md`](CATALOGO.md) → arquivo em `04-entradas/NN_PACK/NNNN_*` → render em `06-sprites/NN_PACK/NNNN_*`.
* Pacote de strings `P` → entrada `102 + P` → `05-strings/packPP_*.txt`.
* Sala `R` → entradas `168 + 3R` (script), `+1` (eventos), `+2` (mapa) → `07-salas/room_RR.*`.
* Esqueletos do personagem: entradas `0672` (masc.) e `0673` (fem.) em `34_RES_CHARACTER`; peças em `35_RES_MANPARTS` / `36_RES_WOMANPARTS`.

## Aviso legal

Todo o material das etapas 00–08 pertence à Gameloft e está aqui, em repositório privado,
apenas como referência de estudo para o remake. Não redistribua nem inclua esses arquivos no
jogo publicado; o remake deve usar arte, textos e áudio próprios.
