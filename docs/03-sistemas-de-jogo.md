# 03 — Sistemas de jogo (especificação de comportamento)

Este documento descreve **como o jogo funciona** em termos independentes de engine, extraído do
código descompilado (`f.java`, `d.java`, `e.java`). Cada seção termina com uma nota
**"No remake 3D"** dizendo como portar o sistema. Constantes numéricas são as do build 1.0.3.

Convenção: `f.X` = campo estático da classe principal; `d.X` = campo de instância de ator.

> Grau de confiança: constantes em **negrito** foram lidas diretamente do código (escala de
> tempo, taxas de necessidade, limiares, layout de registros, projeção, A\*). Valores de
> efeito de ações individuais (ex.: quanto COMER reduz Fome, preços de cada item) estão em
> tabelas de dados dentro de `f.java` com centenas de entradas; os números citados aqui são
> amostras representativas — para o remake eles devem ser **parâmetros de design** ajustáveis
> em JSON, não cópias exatas.

---

## 1. Mundo, salas e projeção isométrica

### 1.1 Locais × salas (mapas)

O jogo tem **25 locais lógicos** (ids 0–24, nomes no pacote de strings 13 e 1) e **11 mapas
físicos** ("salas"). A tabela `f.var_int_arr_ab` converte local → sala:

```
local:  0  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24
sala :  0  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20 14 21 22 23  (local 21 → sala 14, 22→21 ...)
```

(na prática a tabela é `{0..20, 14, 21, 22, 23, 24}`: os quatro apartamentos de NPC
compartilham a sala 14 e os apartamentos do jogador são variantes).

Mapas presentes neste build (os demais são carregados de packs de expansão / não existem):

| Sala | Grade (células) | Objetos | NPCs | Zonas gatilho | Bytes de script |
|---|---|---|---|---|---|
| 0  | 80×70   | 198 | 22 | 25 | 9 155 |
| 1  | 87×45   | 161 | 19 | 22 | 7 144 |
| 4  | 80×75   | 185 | 67 | 16 | 9 965 |
| 6  | 31×32   | 64  | 6  | 19 | 5 022 |
| 8  | 14×19   | 46  | 5  | 9  | 2 596 |
| 9  | 107×106 | 241 | 44 | 33 | 28 508 |
| 13 | 52×75   | 245 | 31 | 33 | 16 007 |
| 14 | 40×29   | 158 | — | 26 | 13 170 |
| 15, 17, 21 | ver `rooms_summary.json` | | | | |

Use `tools/mn2_rooms.py` para gerar o ASCII de cada grade e os JSON de objetos.

### 1.2 Célula → tela

Losango de 24×12 px (proporção 2:1). Com origem `(P, Q)` do registro `grid` (tipo 1001):

```
sx = P + (gx - gy) * 12
sy = Q + (gx + gy) * 6
```

Inversa (divisão inteira truncada, como em Java):

```
gx = ((sy - Q) * 256 + (sx - P) * 128) / 3072
gy = ((sy - Q) * 256 - (sx - P) * 128) / 3072
```

Posições de atores são guardadas em **ponto fixo com 4 bits de fração** (`célula << 4`), ou
seja, 16 sub-passos por célula. A altura (`z`) existe apenas para saltos/animações de UI.

### 1.3 Camadas e ordem de desenho

* Camada de chão (tiles do registro `grid` + `layer` tipo 10) desenhada primeiro.
* Objetos e atores ordenados por `gx + gy` (profundidade iso) e, em empate, por `gy`.
* Objetos grandes têm *footprint* (retângulos `collision_rect` 1002) e **âncora** separada
  do pé do sprite (campo `anchor` nos registros `object`).

### 1.4 Flags por célula (bitmask de 8 bits)

| Bit | Origem | Significado |
|---|---|---|
| 1   | 1002 param 0 | bloqueado (parede/móvel) |
| 32  | 1002 param 1 | bloqueado só para NPC (jogador passa) |
| 4   | 1003 | porta/portal — ao pisar dispara troca de sala |
| 16, 8 | 1005 | zona "interior" / zona de "sombra" (muda música/ambiente) |
| 64, 128 | 1006 | zona de evento especial (praia, água, pista de dança) |

**No remake 3D:** mantenha a **grade lógica** (1 célula = 1 unidade de mundo). Converta
`(gx, gy)` → `(x = gx, z = gy)` em 3D e use câmera ortográfica ou perspectiva fechada a
~35° (visual 3/4 do original). Footprints viram volumes de navegação (NavMesh por célula ou
grid pathfinding). As flags por célula viram *layers* de navegação.

---

## 2. Movimento e pathfinding

* Classe `e` implementa **A\*** em grade com **8 direções**.
* Custo reto = 10; diagonal = 14 por padrão (`e.a(int)` permite outra constante, usada para
  NPCs "preguiçosos").
* Diagonal **não** é permitida se qualquer uma das duas células ortogonais adjacentes estiver
  bloqueada (evita atravessar quinas).
* Heurística: Manhattan × 10. Lista aberta é um heap manual sobre arrays de `short`.
* Limite de nós = `w × h` da sala; se não houver caminho, o ator anda até a célula alcançável
  mais próxima do destino.
* Velocidade do jogador: 4 sub-passos (de 16) por tick a 10–12 fps → ~3 células/s. NPCs 2–3
  sub-passos. Correr (tecla pressionada por >400 ms) dobra.
* Ao chegar ao destino de uma interação, o ator **se vira** para a direção definida no slot
  de interação do objeto (campo `facing` nos registros 1/2) antes de tocar a animação.

**No remake 3D:** A\* idêntico sobre a mesma grade, ou NavMesh da engine. Preserve a regra de
quina e a velocidade em células/s para manter o *feel* das distâncias.

---

## 3. Tempo

| Constante | Valor |
|---|---|
| Escala | **1 segundo real = 1 minuto de jogo** (`f.eZ` em ms; `eZ % 3600000 / 60000` = minuto) |
| Dia | 1 440 min; `f.fa` = número do dia desde o início |
| Semana | 7 dias; aluguel cobrado por semana |
| Início | Dia 0, por volta de 8h (prólogo na praia) |
| Pausa | Tempo congela em menus, diálogos e cutscenes |
| Atalhos | Dormir/cochilar avança o relógio; ações demoradas (trabalho, cirurgia, filme) avançam 30–120 min ("30 minutos se passaram.") |

### Horários de funcionamento

Cada local tem `[abre, fecha]` em horas (string 90 do pacote 1: "Este lugar está aberto de
%i am às %i am!"). Fora do horário o portal recusa a entrada. Locais 24 h: apartamento,
Downtown, South Beach.

### Agendamento (encontros e compromissos)

Op 137 do script e a ação SAIR JUNTO gravam um compromisso `{npc, local, dia, minuto}` em
`f.fi/fj/fk`. Ao chegar o momento, o jogo notifica ("Você tem um encontro em \o!"); o NPC é
teletransportado ao local; chegar >60 min atrasado cancela e reduz romance.

### Ciclo dia/noite

Quatro faixas de luz (manhã 6–11, dia 11–18, entardecer 18–21, noite 21–6) que trocam a
paleta do tile set (paletas alternativas no ASprite da sala) e a música ambiente.

**No remake 3D:** um `TimeSystem` autoritativo que emite eventos `minuteTick`, `hourTick`,
`dayTick`. Iluminação direcional + skybox animados pelas 4 faixas. Mantenha a escala 1:60.

---

## 4. Necessidades e stats

### 4.1 Tabela de 16 stats

Índice `k` abaixo é o id do stat (pacote de strings 15). Valores 0–100.

| k | Nome | Tipo | Variação natural | Limiares de nível (5 faixas) |
|---|---|---|---|---|
| 0 | Fome | necessidade | **+2/h** (sobe = pior) | 20 / 35 / 55 / 70 / 100 |
| 1 | Sono | necessidade | **+3/h** | 20 / 40 / 60 / 80 / 100 |
| 2 | Higiene | necessidade | **−1/h** (desce = pior) | 20 / 40 / 60 / 80 / 100 |
| 3 | Banheiro | necessidade | **+1/h** | 25 / 50 / 75 / 90 / 100 |
| 4 | Boa Forma | habilidade | 0 | 20 / 40 / 60 / 80 / 100 |
| 5 | Cultura | habilidade | 0 | idem |
| 6 | Carisma | habilidade | 0 | idem |
| 7 | Crime | reputação | 0 (só por ações) | 20 / 40 / 60 / **80** / 100 |
| 8 | Bondade | reputação | 0 | 20 / 40 / 60 / 80 / 100 |
| 9 | Dança | habilidade | 0 | idem |
| 10 | Loucura | estado | **−5/h** (efeito de "vitamina") | 20 / 40 / 60 / 80 / 100 |
| 11 | Sex Appeal | atributo | 0 (roupa + cirurgia) | idem |
| 12 | Humor | estado | derivado das necessidades | idem |
| 13 | Social | atributo | derivado de nº de amigos | idem |
| 14 | Saúde | estado | +1/h se necessidades ok | idem |
| 15 | Autoestima | estado | derivado | idem |

Fonte: `f.var_int_arr_arr_u` = `{saveIdx, hudIdx, statIdx, stringId, decayParam, negativeFlag}` e as
tabelas de limiares adjacentes.

### 4.2 Regras de necessidade

* Avisos em 3 níveis (strings 64–75 do pacote 1): aviso leve → aviso severo → **colapso**.
* Colapso: Fome 100 → desmaia, é alimentado, perde Saúde; Sono 100 → dorme no chão, perde
  tempo; Higiene 0 → NPCs recusam conversa, banho forçado; Banheiro 100 → "se molhou", perde
  Higiene e Autoestima.
* Ações de objeto modificam stats por tabela (ex.: DORMIR −60 Sono em 8 h; COCHILAR −20 em
  2 h; COMER −40 Fome; TOMAR BANHO +50 Higiene; LEVANTAR PESOS +5 Boa Forma, +10 Fome).
* **Humor** = média ponderada das 4 necessidades invertidas; Humor < 40 bloqueia FLERTAR.
* **Crime ≥ 80** → próxima vez que um policial vê o jogador, prisão (string 80/91). Crime
  cai 1/h enquanto preso. Fiança: $200 (cai para menos após 2 h; mín. $40; máx. $500 com
  reincidência).

**No remake 3D:** classe `StatSystem` com a tabela acima como dados (`content/stats.json`).
Toda a lógica de decaimento roda por `hourTick` (ou fracionada por minuto para suavidade).

---

## 5. Relacionamentos e NPCs

### 5.1 Registro do NPC (17 bytes, 97 slots a partir do offset 150 do save)

| Byte | Campo | Faixa |
|---|---|---|
| 0 | amizade | −100..100 |
| 1 | romance | 0..100 |
| 2 | humor atual | 0..100 |
| 3 | flags: conhecido (1), telefone (2), namorando (4), colega de quarto (8), inimigo (16), bloqueado (32) |
| 4–5 | último contato (minuto do dia / dia) |
| 6 | local atual (id) |
| 7–8 | horário de rotina (chega/sai) |
| 9 | nº de presentes recebidos hoje |
| 10 | nº de conversas hoje (anti-farm) |
| 11–13 | 3 interesses favoritos (ids 0–174) |
| 14 | interesse odiado |
| 15 | estado de missão vinculado |
| 16 | reservado |

### 5.2 Dinâmica

* **Humor do NPC** decai 2/h até 50; sobe com elogios/presentes.
* **Amizade** em 5 "estrelas" (0–20, 20–40, 40–60, 60–80, 80–100). Muitas missões exigem
  "2 Estrelas" ou "3 Estrelas" (texto `\p2 2 Estrelas\p1`).
* **Romance** só sobe por FLERTAR e exige amizade ≥ 2 estrelas e Humor do NPC ≥ 50.
* **Decaimento**: relacionamento secundário (romance ou amizade negativa) −5/h até um piso
  (amizade não desce abaixo do nível de estrela já conquistado −10).
* Repetir a mesma ação 3× no mesmo dia dá retorno decrescente e depois negativo
  ("Uau, atingi um novo nível de tédio!").
* OFENDER / BRIGAR reduz amizade −20, aumenta Crime +5 e pode chamar a polícia se houver um
  NPC `Guarda`/`Tira` na sala.
* Colega de quarto: um NPC com amizade ≥ 4 estrelas pode receber OFERECER QUARTO; passa a
  dormir no apartamento e paga metade do aluguel.
* Namoro: NAMORAR com romance ≥ 80; TERMINAR zera romance e −30 amizade.

### 5.3 Rotinas

Cada NPC tem **local de rotina + janela de horário** (bytes 6–8). Fora da janela ele não
existe em cena. NPCs de missão são movidos por script (op 100/101 = spawn/despawn em
célula). NPCs genéricos (ids 23–83) são preenchidos aleatoriamente por sala com aparência
sorteada do paper-doll.

**No remake 3D:** `RelationshipSystem` com o mesmo registro (como struct serializável). As
rotinas viram um `ScheduleComponent` por NPC (lista de `{dias, horaInício, horaFim, local,
célula}`), editável em JSON.

---

## 6. Diálogo e interação social

### 6.1 Menus

Menu raiz (pacote 10): **CONVERSAR · OFERECER · FLERTAR · OFENDER** (+ SAIR JUNTO, VISITAR,
PEDIR TELEFONE etc. quando desbloqueados).

| Menu | Opções | Efeito principal |
|---|---|---|
| CONVERSAR | ASSUNTO, PIADA, ELOGIO, TALENTO, SOBRE VOCÊ/MIM/OS OUTROS, ANIMAR, INCENTIVO | amizade, humor do NPC |
| OFERECER | PRESENTE (8 itens), TROCAR ITEM, OFERECER QUARTO, SE DESCULPAR | amizade/romance |
| FLERTAR | ELOGIAR, DANÇA, BEIJO NO ROSTO, BEIJO NA BOCA, AMASSO, PASSAR A NOITE, NAMORAR | romance |
| OFENDER | BRINCADEIRA, INSULTO, CRITICAR, BRIGAR, ENGANAR, EXPULSAR COLEGA | −amizade, +Crime |

### 6.2 Assuntos

* 38 **categorias** (pacote 24) × ~4–5 **interesses** = 175 interesses (pacote 20).
* 845 **falas de tópico** (pacote 21): cada interesse tem ~4–5 falas (jogador e NPC).
* Cada NPC tem 3 interesses favoritos e 1 odiado. Reação:
  * favorito → +8 amizade, +10 humor, fala positiva, desbloqueia "X gosta de Y" na agenda;
  * neutro → +2 amizade (pacote 23: respostas de tédio após repetição);
  * odiado → −10 amizade, −15 humor (pacote 22: respostas ofendidas).
* Falas são escolhidas por **(interesse, polaridade, índice aleatório)**.

### 6.3 Encontros (SAIR JUNTO)

Fluxo (pacote 25): convidar → escolher local (RESTAURANTE YUCA, GLIGHT CLUB, LOUNGE, CINEMA,
ESTÁDIO, apartamento) → NPC avisa "passo em casa antes" → compromisso agendado → no local:
sequência de pedidos do NPC (conversar, presente, dançar, comer, beijo…) em ordem de
intimidade; cada pedido atendido +romance; 2 recusas → encontro termina mal. Sair do local
encerra o encontro.

### 6.4 Tags de texto

`\x` nome do jogador · `\d` nome do NPC · `\o` local · `\mA\m\fB\f` masc./fem. do **jogador**
· `\p2…\p1` destaque · `]` quebra de página · `\v1…\v1`/`\v600…\v600` variantes por estado.

**No remake 3D:** sistema de diálogo orientado a dados: `content/dialogue/topics.json`
(categoria → interesses → falas), `npcs/*.json` com gostos. A árvore de menus é fixa, mas as
opções têm condições (`requires: {friendship: 2, mood: 50}`) declaradas em JSON.

---

## 7. Missões e scripts

### 7.1 Estrutura

* 99 missões (pacote 18: remetente, título, texto × 99). Até 3 ativas na agenda; a tela
  MISSÃO mostra remetente/título/texto e permite TROCAR DE MISSÃO (qual aparece no HUD).
* Estado de missão = bytes no save (`[52..149]` bitfield/estágio). Cada missão é uma
  **máquina de estados pequena** conduzida por scripts da sala.
* Recompensas: dinheiro, itens, roupas exclusivas ("traje exclusivo no closet"), medalhões
  (Bronze/Silver/Gold), conquistas (pacote 9: 19 títulos).

### 7.2 Gatilhos por sala

Cada sala tem (ver `02-formatos-de-arquivo.md` §5.2–5.3):

1. **Eventos**: tipo 1 = ao entrar, tipo 0 = a cada 5 min de jogo, tipo 2 = ao interagir
   com objeto X, tipo 3 = ao falar com NPC X, tipo 5 = ao pisar em zona X.
2. **Script bytecode**: grupos de gatilho `cond* → ação*`. Condições comparam estado de
   missão, stat, dinheiro, hora, item, relacionamento. Ações: dar missão, mover/spawn NPC,
   diálogo (id de string), cutscene (câmera + animação), dar/tirar dinheiro, mudar stat,
   agendar (op 137), teleportar para local, tocar som, desbloquear local no mapa.

### 7.3 Linha principal (resumo narrativo)

1. Prólogo: acorda em South Beach sem memória; polícia → delegacia → encontra Scott/Callie
   preso por "raptar um cachorro" → arranja bico com Huggy (entrega de charutos) → paga
   fiança.
2. Apartamento: proprietário Joey (2 estrelas), encanador John, tutorial de necessidades,
   anões de jardim roubados (7 colecionáveis pelo mapa).
3. Empregos: Figurante (Spillbeard, estádio/TV), Assistente de Publicidade (Opal, cartazes),
   Bartender (Charm, Glight Club), Entregador (Hal Pachinko, Restaurante Yuca). Cada um tem
   missões de habilidade (Dança, Carisma, Cultura).
4. Arco Heather/Dean (colega do colégio), festas, MN2TV, Ceviche (modelos), DJ substituto,
   Galeão Espanhol / Caça ao Tesouro (Capitão, Pelican Island), mafioso Sanchez × Inspetor
   (escolha), mansão de Elizabeth/Xavier (aluguel $2 000 ou "beijo" por metade).
5. Final aberto ("Sua Própria História"): dinheiro, mansão, relacionamentos.

**No remake 3D:** não porte o bytecode. Modele cada missão como **grafo de estágios** em JSON
(`quests/*.json`: `stages[] → {onEnter, objectives[], transitions[]}`) e os gatilhos de sala
como componentes (`TriggerVolume`, `InteractableObject.onUse`, `Npc.onTalk`). Um
interpretador declarativo de condições/ações (ver `06-pipeline-de-conteudo.md` §4) cobre
tudo o que o bytecode faz.

---

## 8. Economia, empregos e itens

| Item | Regra |
|---|---|
| Dinheiro inicial | $0 (ganha $50 na primeira entrega) |
| Aluguel | $300/semana (prazo até 12h do dia seguinte; 2 avisos; depois despejo → dorme na praia) |
| Mansão | $2 000/semana (ou $1 000 com romance) |
| Banco (MELON BANK) | depósito/saque em caixas automáticos; juros 1 %/dia sobre saldo; doações (+Bondade) |
| ROUBAR (correio, jornal, dinheiro) | +$5–50, +Crime 5–15 |
| Multas | fiança $40–500; vandalismo $100 |
| Presentes | Bebida $5, Flores $10, Dinheiro $20, Pres. Sexy $50, Camisa Pólo $15, Ingresso $20, Lingerie $25, Vitamina (Coco) |
| Comida | Hambúrguer/Salada/Sorvete/Pizza/Sushi $3–15 → −Fome 20–50, alguns +Boa Forma ou −Saúde |
| Vitamina | +Loucura 40 (decai 5/h); Loucura > 60 muda falas e sprites de andar |
| Cirurgia (Clínica) | Lipo/Rino/Lifting/Implantes $200–500 → +Sex Appeal 10–20 cada |
| Roupas (Boutique / eSHOP) | $20–150 por peça; +Sex Appeal ou +Carisma conforme item |
| Móveis | 60 itens (pacote 31), $50–600, 6 cores; aumentam Autoestima/Humor ao usar |

### Empregos (pacote 47 "CLASSIFICADOS")

| Emprego | Chefe | Local | Requisito | Pagamento |
|---|---|---|---|---|
| Figurante | Spillbeard | Estádio / set MN2TV | Carisma ★2 | $60/turno |
| Assistente de Publicidade | Opal | Escritório do Jornal → ruas | Cultura ★1 | $40 + bônus por cartaz |
| Bartender | Charm | Glight Club | Dança ★2 | $80 + gorjetas |
| Entregador(a) de pizza | Hal Pachinko | Restaurante Yuca → cidade | — | $30/entrega, tempo limite |

Turnos avançam o relógio em 2–4 h e sobem Fome/Sono. Promoções (medalhões) aumentam o
pagamento em 50 %/100 %.

**No remake 3D:** `EconomySystem` + `InventorySystem`; itens e preços em `content/items.json`,
empregos em `content/jobs.json` com `shift` (duração, efeitos em stats, pagamento, requisitos).

---

## 9. Personagem (paper-doll)

* **Esqueleto único** por gênero (ASprite 0672 masc., 0673 fem.): 237 animações, 872/892
  frames, 276/280 módulos **sem pixels**: cada módulo é um slot.
* Slots: cabeça (3 vistas × 3 tons de pele), cabelo (30 estilos × 3 vistas × 4 cores),
  top (31 × 3 vistas × 6 cores), bottom (30 × 34 poses de perna × 6 cores), calçado (13).
* O jogo troca a **tabela de módulos** do esqueleto apontando para RES_MANPARTS /
  RES_WOMANPARTS e escolhe a paleta pelo índice de cor.
* Vetor de aparência (save `[3100..3109]`):
  `[gênero, pele, cabelo, corCabelo, top, corTop, bottom, corBottom, calçado, corCalçado]`.
* Animações principais (ids úteis): idle ×8 direções, andar ×8, correr ×8, sentar, dormir,
  comer, beber, dançar ×4 estilos, beijo, briga, cair (desmaio), nadar, tocar piano, levantar
  peso, varrer, cozinhar, trabalhar (bar / cartaz / entrega).
* Foto de perfil: tira "selfie" do rosto (TIRAR FOTO) para a agenda.

**No remake 3D:** esqueleto humanoide único + **malhas modulares** (cabeça, cabelo, top,
bottom, calçado) com *skinning* no mesmo rig; cor = parâmetro de material. O mesmo vetor
de 10 ints descreve a aparência. Animações: um `AnimationTree` com estados equivalentes aos
237 clipes (agrupáveis em ~40 clipes + blend de direção).

---

## 10. Apartamento, móveis e animais

* 4 níveis de moradia: LOW (inicial), MID A, MID B (mudança por missão/renda), HI (mansão).
  Cada nível é uma variante do mapa 14/21 com mais slots de móvel.
* Slots de móvel: registro `closet_item` (19) e zonas `area_b`; cada slot aceita categoria
  (sofá, cama, cômoda, TV, almofada, computador, cadeira). Comprar substitui o item do slot.
* Móveis dão ações extra (TV: PROGRAMA DE TV/NOTÍCIAS/MASS INFECTION…; computador: CHECAR
  EMAIL/SITES PAGOS/eSHOP; cama de designer: dorme mais rápido).
* Anões de jardim: 7 colecionáveis (pacote 9, ids 6–12) escondidos pelo mapa; cada um
  encontrado volta ao jardim; todos → recompensa do proprietário.
* Animais: cão (Scottish Terrier, French Bulldog, Beagle — Pet Shop Boy) e gato
  (de Scott/Callie). Ações: ALIMENTAR, BRINCAR, TREINAR: SENTAR, BRIGAR, ASSUSTAR. Animal com
  fome segue o jogador e late; treinado dá +Bondade.
* Colega de quarto e namorado(a) podem morar no apartamento (rotina noturna lá).

**No remake 3D:** o apartamento é uma cena com `FurnitureSlot` por categoria; catálogo em
`content/furniture.json`. Animais são NPCs com `ScheduleComponent` fixo no apartamento e
um conjunto reduzido de necessidades (fome, carinho).

---

## 11. Loop de jogo e estados (máquina de estados do canvas `f`)

```
SPLASH → LOGO → MENU PRINCIPAL ─┬─ NOVO JOGO → CRIAÇÃO DE PERSONAGEM → PRÓLOGO → JOGO
                                 └─ CONTINUAR → JOGO
JOGO ──┬── PAUSA (CONTINUAR, MAPA, OPÇÕES, AJUDA, SALVAR, MENU PRINCIPAL)
       ├── MAPA DA CIDADE (viagem instantânea; alguns locais bloqueados até missão)
       ├── AGENDA (telefone: contatos, estatísticas, mensagens, missões)
       ├── MENU DE INTERAÇÃO (objeto ou NPC)
       ├── DIÁLOGO / CUTSCENE
       ├── LOJA (closet, boutique, móveis, pet shop)
       └── MINIGAME (dança: sequência de setas; foto; cartazes)
```

Tick: 10–12 fps lógicos; entrada de 12 teclas (0–9, *, #) + softkeys. O remake deve mapear
para toque: *tap-to-move*, toque no objeto abre menu radial, *swipe* para câmera.

### Minigame de dança

Sequência de 4–8 setas (↑↓←→) por ritmo; acerto +pontos; 3 erros encerram. Pontuação →
+Dança e +romance se dançando com NPC. Quatro estilos (TECHNO, SALSA, POP, METAL) mudam o
tempo (BPM) e a animação.
