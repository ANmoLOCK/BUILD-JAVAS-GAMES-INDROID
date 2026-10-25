# 02 — Formatos de arquivo (engenharia reversa)

Todos os formatos abaixo foram validados pelas ferramentas em `tools/` contra o JAR real
(1 039 entradas extraídas; 430 sprites decodificados byte a byte; 3 640 strings; 11 salas).

## 1. Índice de recursos — arquivo `0` (10 542 bytes)

```
offset 0      1039 entradas × 10 bytes:
                [0]    pack id (0..37)         [1]    flag interna
                [2..5] tamanho  (uint32 BE)    [6..9] offset no pack descomprimido (uint32 BE)
offset 10390  38 × uint32 BE = tamanho descomprimido de cada pack
```

Carregamento no original (`f.byte_arr_a(id, …)`): abre o `RES_*` do pack, descomprime inteiro
em memória (decoder LZMA embutido na própria classe `f`, ~400 linhas), faz `skip(offset)` e lê
`tamanho` bytes. Mantém o stream aberto enquanto as leituras forem sequenciais no mesmo pack.

### Tabela de packs

| id | Pack | Entradas (ids) | Conteúdo |
|---|---|---|---|
| 0 | RES_SYSTEM | 0–58 | fonte (0), 38 paletas de cor de 772 B (1–38), tabelas (39–48), sprites de UI/HUD (49–57), paleta (58) |
| 1 | RES_SOUNDS | 59–101 | 25 MIDI + 4 WAV (demais slots vazios) |
| 2 | RES_STRINGS | 102–157 | 56 pacotes de texto |
| 3 | RES_WORLDMAP | 158–160 | mapa de Miami (sprite 664×218), ícones, tabela de locais |
| 4 | RES_REACTIONS | 161–167 | tabelas binárias de reações/tópicos dos NPCs |
| 5 | RES_ROOM | 168–203 | salas 0–11 (3 entradas por sala) — 6 presentes |
| 6 | RES_ROOM_2 | 204–239 | salas 12–23 — 5 presentes |
| 7 | RES_GLOBAL_SPRITES | 240–260 | sprites globais (menu, balões, setas, efeitos) |
| 8–17 | RES_GLOBAL_1..10_SPRITES | 261–449 | mobília/objetos genéricos (sofás, camas, portas, árvores, etc.) |
| 18–33 | RES_LOCATION_*_SPRITES | 450–667 | cenário específico de 16 locais (8 vazios neste build) |
| 34 | RES_CHARACTER | 668–677 | esqueletos (homem 672, mulher 673), corpo-base, rostos, sombra |
| 35 | RES_MANPARTS | 678–802 | 125 slots de peças masculinas |
| 36 | RES_WOMANPARTS | 803–927 | 125 slots de peças femininas |
| 37 | RES_TEXTURES | 928–1038 | 56 texturas de piso/parede (42×22, 86×44) com até 59 paletas |

## 2. Packs `RES_*` — LZMA

Header de 13 bytes: `props (lc/lp/pb)`, `dictSize u32 LE`, `uncompressedSize u64 LE`, seguido do
stream. É exatamente o formato `.lzma` ("LZMA alone") — `lzma.LZMADecompressor(format=FORMAT_ALONE)`
em Python descomprime todos os 38 packs com tamanho idêntico ao declarado no índice. Packs
vazios têm 18 bytes (só header + marcador de fim).

## 3. Pacotes de strings (RES_STRINGS)

```
u8   n            largura dos inteiros (2 ou 3 bytes, big-endian)
uN   count
uN × count        offsets relativos ao início da área de dados
dados             strings UTF-8 terminadas em \0
```

Marcações embutidas (processadas pelo motor de texto):

| Tag | Função |
|---|---|
| `\n` | quebra de linha; `]` = quebra de página em diálogo |
| `\pN` | troca de cor/paleta da fonte (p1 normal, p2 destaque, p7/p8 valores −/+) |
| `\mX\m` / `\fX\f` | texto exclusivo para jogador masculino / feminino (concordância de gênero) |
| `\x` | nome do jogador; `\d` nome do par romântico; `\o` nome do local |
| `\v1…\v1` / `\v600…\v600` | variantes de texto por versão/plataforma |
| `%i` | inteiro formatado; `^texto^` destaque de créditos |

## 4. ASprite (magic `0x05DF`) — sprites, animações e fonte

Formato clássico da Gameloft. Layout little-endian:

```
u16 magic = 0xDF05 (bytes DF 05)
u32 flags
[flags & 1]       u16 nModules
                  por módulo: u8 tipo, [flags&2: u8 x, u8 y], u8 w, u8 h
                  (se o byte após o tipo for 0xFF, módulo "especial" de 8 bytes)
[flags & 0x100]   u16 nFModules
                  por fmodule (4 B; 6 B com s16 se flags&0x400): u8 mod, s8 ox, s8 oy, u8 fl
                     fl bits 0-1 = flipX/flipY ; bits 6-7 = bits altos do índice do módulo (até 1023)
                  u16 nFrames ; por frame: (flags&0x800 ? u8 : u16) nFM, u16 fmStart
                  [!(flags&0x1000)] 4 retângulos (s8 ou s16) por frame
                  [flags&0x2000]    4 retângulos de colisão por frame
[flags & 0x10000] u16 nAFrames ; por aframe: u8 frame, u8 duração (ticks), s8 ox, s8 oy, u8 fl
                  u16 nAnims   ; por anim: (flags&0x80000 ? u8 : u16) nAF, u16 afStart
paleta            u16 fmt: 0x8888 = ARGB32 ; 0x6505 = RGB565 (0xF81F = transparente)
                  u8 nPaletas, u8 nCores (0 ⇒ 256) ; cores
u16 pixfmt        0x27F1 RLE (byte>127 ⇒ repete próximo índice (b−128)×)
                  0x1600 4 bpp ; 0x0400 2 bpp ; 0x0200 1 bpp ; 0x5602 8 bpp
                  0x64F0 RLE empacotado: índice = b & mask, run = (b >> bits)+1
por módulo        u16 len, dados
```

Estatística no JAR: 383 sprites em 4 bpp, 28 em 2 bpp, 9 RLE-0x64F0, 6 em 1 bpp, 2 em 8 bpp.
Paletas múltiplas = variantes de cor do mesmo objeto (ex.: 17 cores de sofá, 59 swatches em
`RES_TEXTURES`). A fonte do jogo (entrada 0) é um ASprite cujo módulo = glifo, com tabela de
mapeamento de caracteres (`a.var_byte_arr_a`, 624 = deslocamento para faixa Unicode).

### Esqueletos de personagem (paper-doll)

`0672` (homem) e `0673` (mulher) têm **276/280 módulos, 872/892 frames, 237 animações** e
**nenhum pixel/paleta**. Os índices de módulo são *slots*; na hora de desenhar (`a.a(Graphics…)`)
o motor redireciona faixas de slot para sprites de peças:

| Faixa de slot (homem) | Peça | Sprite de origem | Cor |
|---|---|---|---|
| 0–2 | cabeça/pele (3 vistas) | parts[0] | paleta de pele (`var_int_arr_arr_a`) |
| 3–5 | cabelo (3 vistas) | parts[1 + estiloCabelo] | paleta de cabelo (`_c`) |
| 6–8 / 9–42 | tronco / mangas-top | parts[31 + top] | paleta de roupa (`_b`) |
| 43–55 | pernas/bottom (até 34 poses) | parts[62 + bottom] | paleta de roupa |
| 56–64 | calçado | parts[80 + sapato] | paleta de roupa |
| 65–95 | corpo-base (braços, mãos) | RES_CHARACTER[8] (180 módulos) | pele |
| 96+ | rosto/boca/expressões | RES_CHARACTER[6/7] (33 módulos) | — |

Vetor de aparência do personagem (`f.var_int_arr_j`): `[gênero, tomDePele, cabelo, corCabelo,
top, corTop, bottom, corBottom, sapato, corSapato]` — persistido em `save[0..12]`.

## 5. Salas (RES_ROOM / RES_ROOM_2) — 3 entradas por sala

`entrada = 168 + 3·sala` (sala 0–23). Mapeamento local→sala: `var_int_arr_ab = {0,1,…,20,14,21,22,23,24}`
(26 locais; o local 21 reutiliza a sala 14).

### 5.1 `+2` — Mapa e objetos
Stream de registros de `short LE`: `[tipo, id, x, y, nParams, params…]` (tamanho = nParams+5 shorts).

| tipo | Significado | Campos |
|---|---|---|
| 1001 | grade | `[2]=origemX px, [3]=origemY px, [5]=largura, [6]=altura` → aloca `w×h` bytes de flags |
| 1002 | retângulo de colisão | pos em px → célula via projeção inversa; `[5]=w,[6]=h,[7]=variante (2 ⇒ flag 32, senão 1)` |
| 1003 | célula porta/portal | flag 4 |
| 1005 | zona | flag 16 (`[7]=0`) ou 8 — rotas de NPC/calçada |
| 1006 | zona | flag 64 ou 128 — rua/área de perambulação |
| 1004 | ponto especial | |
| 10 | camada de fundo | sprite, posição, paralaxe, ordenação |
| ≥400 | template de decoração (mobília estática) | `id−400` = índice de template; ordenação por profundidade iso |
| 1 / 2 | objeto interativo (2 = animado) | `[5] sprite pack,[6] sprite,[7] frame,[8] flags (0x2000 roupa, 0x4000, 0x8000),[9..10] offset,[11] camada,[12] string id (nome),[13] ligação` |
| 3 | spawn do jogador | `[6] frame, [7] facing` |
| 4 | NPC | `[6] slot, [7] sprite, [8] flags, [12] modo de escolha (0 aleatório por faixa, 1 fixo, 2 "segundo", 3 por gênero, 4 por missão, 5), [13]/[15] id por gênero, [14] humor inicial, [16] anim, [17] flags, [19], [20] personagem` |
| 5 / 8 | zona de gatilho | retângulo em células + parâmetros (`[13]==1` = ponto de saída) |
| 6 / 9 | área nomeada | pista de dança, fila, etc. |
| 19 | item de closet | |
| 2000 / 9000 / 2101 / 2110 | tabelas auxiliares | horários, portas, ligações entre salas |

Flags de célula usadas pelo A* (`e.java`): bit 1 = bloqueado; máscara de custo adicional
(`& i`) para zonas; `d` evita diagonais que cortem quinas (verifica as duas células ortogonais).

### 5.2 `+1` — Tabela de eventos
Registros de 6 bytes `[offset u16 BE, len u16 BE, tipo u16 BE]`; último byte do arquivo = quantidade.
Tipos observados por sala: 1 (ao entrar), 2, 3, 5 (chamados pelo motor em `f.void_u(tipo)`),
0 (periódico: a cada 5 min de jogo).

### 5.3 `+0` — Bytecode de scripts (missões, diálogos, gatilhos)

```
u8 nGrupos
por grupo: u16 id, u8 nScripts
  por script: u8 tipo, u8 param, [tipo 2|3: u16 extra], u16 nBlocos
    por bloco: u16 ?, u8 nOps, ops…
```

Cada op é `u8 opcode` + operandos de tamanho fixo (tabela recuperada do parser):

| Faixa | Papel | Opcodes (operandos em bytes) |
|---|---|---|
| 11–60 | **condições** (estado de missão, stat, hora, local, relacionamento, item, flag) | 11:4 12:4 13:5 21:4 22:1 23:4 24:4 31:4 32:2 34:4 35:6 36:8 37:2 38:4 39:6 41:4 42:1 43:4 44:4 50:8 60:2 |
| 100–130 | **ações de fluxo/UI** (diálogo, escolha, mensagem, missão, telefone) | 100:4 101:4 102:6 105:4 106:4 107:2 108:2 109:10 110:4 111:8 112:4 113:8 114:2 115:6 116… |
| 130–260 | **ações de mundo** (dar dinheiro/item, alterar stat, teleportar, spawn/anim NPC, agendar encontro — ex. op 137 = agendar `(npc, local, minutos, dia, string)`) | interpretador em `f` (switch com ~100 casos) |
| 200 | fim/salto | 200:2 |

A semântica completa opcode→efeito está no interpretador (switch gigante em `f`, três cópias:
parser de tamanhos, pré-passo e execução). **Para o remake não é necessário emular o bytecode**:
o conteúdo deve ser reescrito em um formato declarativo (ver `06-pipeline-de-conteudo.md`) usando
as 99 missões e os textos como especificação.

## 6. Áudio (RES_SOUNDS)
25 arquivos MIDI (tema, menu, locais, eventos) e 4 WAV curtos (efeitos). O motor suporta
`audio/midi`, `audio/x-wav`, `audio/amr`, `audio/mp3` via JSR-135, com controle de volume e
vibração (`save[79]`).

## 7. Save game (RMS `MiamiNights2`)

Um único record: `3 245` bytes de estado + até `295` bytes de extensão (3 540 no total).
Campos identificados (offsets em bytes, BE para multi-byte):

| Offset | Tamanho | Conteúdo |
|---|---|---|
| 0–12 | 13 | aparência do jogador (0 = gênero: 0 homem / 1 mulher; pele, cabelo, cor, top, bottom, sapato…) |
| 32–33 | | estado de tutorial / evento atual |
| 34–51 | 16 (pula 40 e 48) | **16 stats** (ordem: Fome 34, Sono 35, Higiene 36, Banheiro 37, Boa Forma 38, Cultura 39, Carisma 41, Crime 42, Bondade 43, Dança 44, Loucura 45, Sex Appeal 46, Humor 47, Social 49, Saúde 50, Autoestima 51) |
| 46–49 | 4 | saldo bancário (`fd`) |
| 68–69, 78–79 | | opções: som, vibração (79), setas de direção, dicas |
| 81–84 | 4 | dinheiro (`fc`, codificado por `int_L`) |
| 86–98 | | estado do apartamento / colega de quarto / aluguel |
| 125–140 | 4×int32 | bitfields de desbloqueio (medalhas, locais, conquistas) |
| 150–1798 | 97×17 | **registros de NPC**: `+0` amizade (−100..100), `+3` relacionamento secundário (decai 5/h até piso `+32`), `+4` romance (0..100), `+5`,`+6` flags (bit 2 "tem telefone", bit 8, bit 0x20), `+8` humor (decai 2/h → 0), `+10` id do template/personagem, `+11..14` int32 de flags (tópicos já usados, presentes), `+16` |
| 1801–1804 | 4 | missões ativas (ids) |
| 1805–1808 | 4 | hora do dia em ms (`eZ`, 0..86 400 000) |
| 1809–1810 | 2 | dia atual (`fa`, ≥1) |
| 1855–1859 | | pontuação/contador (`var_int_D`) |
| 2051 | 1 | estado do aluguel (1..4: avisos, multa) |
| 2119–2122 | | flags de roupas/itens |
| 2150 | 1 | **local atual** |
| 2159–2160 | | flags de necessidades críticas / modo relógio |
| 2172 | 1 | festa/evento especial |
| 2176–2187 | 3×int32 | encontro agendado: hora (`fi`), dia (`fj`), NPC (`fk`) |
| 2188–2192 | | tipo de encontro, local de origem, string |
| 2200–2399 | shorts | inventário / itens |
| 3000–3029 | | contadores (3028 pet, 3029 dias de fome…) |
| 3100–3115 | 8×short | roupas possuídas por categoria (`var_short_arr_a = {24,8,11,314,13,87,58,178}` = tamanhos das categorias) |
| 3201–3204 | | pontuação, estado de crime/prisão (3204: 0 livre, 1 procurado se Crime ≥ 80, 2 preso) |
| 3215–3217, 3240–3241 | | contadores diversos |

## 8. Tabelas estáticas relevantes (embutidas em `f.<clinit>`)

* `var_int_arr_arr_u[16]` = `{saveIdx, hudIdx, statIdx, stringId, parâmetroDecaimento, éAtributoNegativo}`
  por stat (ex.: Crime `{42,27,7,296,0,0}`, Social `{49,34,13,301,15,1}`).
* Faixas de nível por stat (`f.b(stat, a,b,c,d,e)` → cumulativo = 100):
  Fome 20/35/55/70/100, Sono 10/25/50/65/100, Higiene 20/30/40/60/100, Banheiro 35/50/75/85/100,
  Boa Forma 10/25/45/60/100, Cultura 10/20/35/65/100, Carisma 10/25/45/65/100, Crime 20/40/60/80/100,
  Bondade 10/25/40/65/100, Dança 10/20/35/65/100, Loucura 10/30/50/70/100, Sex Appeal 10/25/45/60/100,
  Humor 10/20/40/65/100, Social 15/35/60/75/100, Saúde 10/25/60/75/100, Autoestima 20/40/75/90/100.
* Preços de roupas por categoria (`var_short_arr_arr_b`): tops 350/600/1000, bottoms 500/1200/2350,
  sapatos 150, especiais 1000/2500, cores 15/20/35/50, etc.
* Custos de interação/presentes (`var_int_arr_arr_i/j`): matrizes 5×N de "custo de humor/energia" por ação.
* Paletas de pele/cabelo/roupa: 4 cores por tom (`nArray..nArray6`).
* Tamanhos de categoria de item: 8 categorias.
