# BUILD-JAVAS-GAMES-INDROID

## Acesso rápido

| Quero ver… | Link direto |
|---|---|
| **A pasta principal do projeto (comece aqui)** | [`Miami_2/README.md`](Miami_2/README.md) |
| O código principal do jogo (33 mil linhas: loop, render, UI, scripts, save) | [`Miami_2/02-codigo-descompilado/f.java`](Miami_2/02-codigo-descompilado/f.java) |
| A classe de entrada (MIDlet) | [`Miami_2/02-codigo-descompilado/GloftMMN2.java`](Miami_2/02-codigo-descompilado/GloftMMN2.java) |
| O que cada classe faz | [`CLASSES.md`](Miami_2/02-codigo-descompilado/CLASSES.md) |
| Como o jogo funciona (regras, números, sistemas) | [`03-sistemas-de-jogo.md`](Miami_2/09-engenharia-reversa-docs/03-sistemas-de-jogo.md) |
| Como fazer o remake 3D para Android | [`05-arquitetura-android-3d.md`](Miami_2/09-engenharia-reversa-docs/05-arquitetura-android-3d.md) |
| Como adicionar conteúdo novo | [`06-pipeline-de-conteudo.md`](Miami_2/09-engenharia-reversa-docs/06-pipeline-de-conteudo.md) |
| **Plano progressivo Godot** | [`08-plano-progressivo-godot.md`](Miami_2/09-engenharia-reversa-docs/08-plano-progressivo-godot.md) |
| **Projeto Godot 4 (Fase A — cérebro rodando)** | [`Miami_2/godot/README.md`](Miami_2/godot/README.md) |
| Lista de todos os recursos extraídos | [`CATALOGO.md`](Miami_2/CATALOGO.md) |

## Do que se trata

Este projeto pega um jogo antigo de celular feito em Java (J2ME) — **Miami Nights 2: The City
Is Yours**, da Gameloft (2009) — e o "abre por dentro" para entender como ele funciona:
como os arquivos são guardados, como os gráficos são desenhados, quais são as regras do jogo
(fome, sono, dinheiro, amizades, missões) e quanto conteúdo existe (locais, personagens,
objetos, falas).

Com isso documentado, o objetivo é **recriar o jogo em 3D como um app nativo de Android**,
mantendo as mesmas mecânicas, mas com gráficos novos e uma estrutura em que seja fácil
**adicionar mais conteúdo** (novos bairros, personagens, missões, móveis) só editando arquivos
JSON, sem mexer no código do motor.

Em resumo, aqui dentro há três coisas:

1. **O jogo original desmontado** — JAR, código descompilado, sprites, textos, mapas e áudio,
   organizados por etapa e com nome em cada arquivo (pastas `00` a `08`).
2. **A documentação da engenharia reversa** — explica os formatos e as regras do jogo em
   detalhes (pasta `09`).
3. **A base do remake** — o plano de arquitetura para Android 3D, o formato de conteúdo com
   validação automática e um pacote de exemplo (pasta `10` e `tools/`).

Engenharia reversa de jogos Java (J2ME) para servir de base a remakes **3D nativos para
Android**. Um jogo por pasta central.

| Jogo | Pasta | Estado |
|---|---|---|
| **Miami Nights 2: The City Is Yours** (Gameloft, 2009) | [`Miami_2/`](Miami_2) | extração completa (1 039 recursos, 3 640 textos, 430 sprites, 11 mapas, áudio, código descompilado), documentação em 7 partes, schemas + conteúdo de exemplo do remake |

## Estrutura de uma pasta de jogo

```
<Jogo>/
  00-original/              JAR original
  01-jar-extraido/          conteúdo bruto do JAR
  02-codigo-descompilado/   fontes Java (CFR) + papel de cada classe
  03-indice-e-packs/        índice de recursos decodificado + packs descomprimidos
  04-entradas/<pack>/       cada recurso em arquivo próprio, com id, nome e extensão
  05-strings/               textos por pacote
  06-sprites/<pack>/        sprites renderizados em PNG + animações JSON
  07-salas/                 mapas (grade ASCII + JSON)
  08-audio/                 MIDI / WAV / AMR
  09-engenharia-reversa-docs/   documentação (formatos, sistemas, inventário, arquitetura 3D, pipeline, roadmap)
  10-remake-3d/             schemas JSON + pacote de conteúdo de exemplo
  tools/                    scripts que geram tudo acima a partir do JAR
  CATALOGO.md               tabela id → pack → tipo → nome
```

Comece por [`Miami_2/README.md`](Miami_2/README.md).

## Aviso legal

Os JARs, seu código, arte, textos e áudio pertencem aos respectivos publishers (Gameloft).
Este repositório é privado e guarda esse material **apenas como referência de estudo**; o
remake deve usar arte, música e textos próprios, e nada das pastas 00–08 deve ser
redistribuído ou incluído no jogo publicado.
