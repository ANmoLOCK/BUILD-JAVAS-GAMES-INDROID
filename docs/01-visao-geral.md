# 01 — Visão geral do jogo original

## Identificação

| Campo | Valor |
|---|---|
| Arquivo analisado | `Miami 2 PR-BR.jar` (654 731 bytes) |
| Nome | **Miami Nights 2: The City Is Yours** |
| Publisher / estúdio | Gameloft SA — estúdio de Barcelona (créditos no pacote de strings 0) |
| Plataforma | J2ME — MIDP 2.0 / CLDC 1.0 (celulares 2009, telas 320×240 e 240×320) |
| Versão | `MIDlet-Version: 1.0.3`, build de 20/07/2009 |
| Idioma do build | Português do Brasil (3 640 strings, 56 pacotes) |
| MIDlet principal | `GloftMMN2` → canvas `f` |
| Gênero | Simulador de vida social estilo *The Sims* em **isometria 2:1**, mundo aberto por "salas" (locais de Miami), com ciclo dia/noite, necessidades, relacionamentos, empregos, missões e customização de personagem/apartamento |

## Estrutura do JAR

```
META-INF/MANIFEST.MF
GloftMMN2.class         MIDlet (ciclo de vida: startApp/pauseApp/destroyApp)
f.class     374 KB      Canvas principal: loop, estados, render iso, UI, scripts, save, áudio
d.class      41 KB      Ator/objeto do mundo (jogador, NPC, mobília, zonas, portais)
a.class      14 KB      ASprite — formato de sprite/animação/fonte da Gameloft (magic 0x05DF)
b.class      25 KB      IGP — "In-Game Promotion" (catálogo "Mais Jogos!"); irrelevante p/ gameplay
c.class     0,7 KB      Helper do tutorial de movimento (sequência de teclas)
e.class       3 KB      Pathfinder A* em grade, 8 direções
0            10 KB      ÍNDICE de recursos (1 039 entradas) + tamanhos dos 38 packs
RES_*        38 packs   Cada um é um stream LZMA ("lzma alone", header de 13 bytes)
dataIGP, icon.png, menutitle.png
```

Todo o código foi ofuscado (nomes `a`–`f`), mas a lógica é totalmente recuperável com um
descompilador (CFR 0.152 foi usado). As ferramentas em `tools/` reconstroem os formatos de
dados sem depender do código Java.

## Resumo técnico (o que importa para o remake 3D)

| Sistema | Como funciona no original | Referência |
|---|---|---|
| Mundo | 11 mapas ("salas") em grade isométrica de até 107×106 células; 25 locais lógicos reutilizam mapas | `03-sistemas-de-jogo.md` §1 |
| Projeção | 2:1, losango de 24×12 px; `sx = P + (gx−gy)·12`, `sy = Q + (gx+gy)·6` | §1 |
| Movimento | Posição em ponto fixo (`célula << 4`), A* 8 direções com custo 10 reto / diagonal configurável, flags de colisão por célula | §2 |
| Tempo | **1 s real = 1 min de jogo**; dia de 1 440 min; horários de funcionamento por local; agendamento de encontros | §3 |
| Necessidades | 4 necessidades (Fome, Sono, Higiene, Banheiro) com taxa por hora + 12 habilidades/atributos; 16 stats no total, cada um com 5 faixas de nível | §4 |
| Relacionamentos | 97 slots de NPC × 17 bytes: amizade (−100..100), romance (0..100), humor, flags; decaimento por hora | §5 |
| Diálogo | 4 menus (CONVERSAR / OFERECER / FLERTAR / OFENDER) → 38 categorias de assunto, 175 interesses, 845 falas de tópico, reações por gostos do NPC | §6 |
| Missões | 99 missões (remetente, título, texto) acionadas por **bytecode de scripts** por sala (1 238 grupos de gatilhos) | §7 |
| Economia | Dinheiro, banco (MELON BANK: depósito com rendimento, doações), aluguel $300/semana (mansão $2 000), 4 empregos, fiança, multas | §8 |
| Personagem | Paper-doll: esqueleto de 237 animações × 872 frames; peças (pele, cabelo, top, bottom, calçado) com 3 vistas e paletas de cor | §9 |
| Apartamento | 4 níveis (LOW/MID A/MID B/HI), 60 móveis compráveis em 6 cores, 7 anões de jardim colecionáveis, animais (3 raças de cão + gato) | §10 |
| Save | 1 record RMS "MiamiNights2" de 3 245 bytes (+295 de extensão) | `02-formatos-de-arquivo.md` §7 |

## Por que isto é um bom candidato a remake 3D

* O **modelo de dados é limpo**: grade lógica + objetos com footprint + slots de interação. Isso
  mapeia diretamente para um mundo 3D em grade (como *The Sims*), mantendo a câmera 3/4.
* O **personagem já é modular** (paper-doll). Em 3D isso vira esqueleto único + malhas
  intercambiáveis + cores de material — exatamente a mesma arquitetura.
* A **lógica de simulação** (necessidades, humor, relacionamento, tempo) é independente de
  renderização; pode ser portada 1:1 e testada sem engine.
* O **conteúdo é orientado a dados** (strings, salas, scripts, tabelas). O caminho para
  "implementar mais conteúdo" é formalizar esses dados em JSON com schema (ver `06-pipeline-de-conteudo.md`).

## Aviso legal

Código, arte, textos e áudio do JAR pertencem à Gameloft. Este repositório contém apenas
**documentação de engenharia reversa e ferramentas** que operam sobre um JAR fornecido pelo
usuário. Nenhum recurso extraído (sprites, textos, música) deve ser commitado nem redistribuído.
O remake deve usar **arte, música e textos próprios**; a documentação serve como especificação
de design e de formatos.
