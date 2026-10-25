# BUILD-JAVAS-GAMES-INDROID

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
