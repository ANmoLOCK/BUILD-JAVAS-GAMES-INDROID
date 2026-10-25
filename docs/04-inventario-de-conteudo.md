# 04 — Inventário de conteúdo

Lista do que existe no jogo original, por categoria, com o **id usado nos dados** (índice no
pacote de strings indicado). Serve como *checklist* de paridade para o remake e como base
para o conteúdo novo. Os textos em si não estão aqui (direitos da Gameloft); gere-os
localmente com `tools/mn2_strings.py --txt`.

## 1. Locais (25) — pacote 13, ids 2–27

A coluna "Id local" segue a ordem dos nomes no pacote 13 (que é a ordem usada pelo menu
IR AO MAPA e pela tabela `var_int_arr_ab`); a coluna "Sala" vem dessa tabela. Tipo/notas
foram inferidos dos objetos e NPCs presentes em cada mapa (`tools/mn2_rooms.py`).

| Id local | Nome | Sala | Tipo | Notas |
|---|---|---|---|---|
| 0 | First Street / Downtown | 0 | rua | hub inicial; delegacia, jornal, caixa |
| 1 | Delegacia | 1 | interior | cela, inspetor, guarda |
| 2 | Glight Club | 2 | boate | bar, DJ, pista (dança) |
| 3 | Escritório do Jornal | 3 | interior | Opal, classificados |
| 4 | Estádio (Degubas) | 4 | exterior | figurante, 67 NPCs (torcida) |
| 5 | Clínica de Beleza | 5 | interior | cirurgias, barbearia |
| 6 | Apartamento de Heather/Dean | 6 | interior | |
| 7 | Grand Avenue / Coconut Grove | 7 | rua | boutique, gelatos, cinema |
| 8 | Lounge | 8 | interior | encontros |
| 9 | South Beach | 9 | praia | maior mapa (107×106); prólogo; espreguiçadeiras, detector de metal |
| 10 | Cuban Cafe | 10 | interior | |
| 11 | Little Havana | 11 | rua | Sanchez, charutos |
| 12 | Restaurante (Yuca) | 12 | interior | Hal Pachinko, pizza, sushi |
| 13 | Ocean Drive | 13 | rua | hotel, carrinho de comida |
| 14 | Apartamento (jogador, LOW) | 14 | interior | móveis, closet, jardim |
| 15 | Barco / Pelican Port | 15 | exterior | capitão |
| 16 | Iate | 16 | interior | festa |
| 17 | Everglades | 17 | exterior | crocodilos, caça ao tesouro |
| 18 | Mansão | 18 | interior | Elizabeth/Xavier |
| 19 | Downtown | 19 | rua | |
| 20 | Coconut Grove | 20 | rua | |
| 21 | Apartamento de NPC | 14 | interior | reutiliza sala 14 |
| 22 | Miami Beach | 21 | praia | |
| 23 | Pelican Island | 22 | exterior | |
| 24 | Key Biscayne | 23 | exterior | |

Mapa da cidade (pacote 1, ids 33–57) agrupa em 9 regiões: Downtown, South Beach, Little
Havana, Ocean Drive, Coconut Grove, Light House, Pelican Island, Key Biscayne, Everglades.

## 2. NPCs (97 slots, 94 nomes) — pacote 11

**Elenco de história (ids 0–22, 84–93):**

| Id | Nome | Papel |
|---|---|---|
| 0 | Proprietário (Joey) | senhorio; anões; aluguel |
| 1 | Goldsax | empresária; empregos; galeão |
| 2 | M. Sanchez | mafioso; charutos; Gran Kahuna |
| 3 / 4 | Dean / Heather | interesse romântico (oposto ao gênero do jogador) |
| 5 / 6 | Scott / Callie | melhor amigo(a); preso no prólogo |
| 7 | Danny | festa |
| 8 | Amy | |
| 9 | Beatrice | dona do Westwood (cão) |
| 10 | Inspetor | polícia; arco mafioso |
| 11 | Hal Pachinko | dono do Restaurante Yuca; entregas |
| 12 | DJ | Glight Club |
| 13 | Spillbeard | coordenador de figurantes |
| 14 | Opal | chefe de publicidade (gêmea) |
| 15 | Charm | gerente da boate (gêmea) |
| 16 | Guarda | delegacia; identidade perdida |
| 17 | Capitão | caça ao tesouro |
| 18 / 19 | Nip / Took | cabeleireiros |
| 20 | Mortadella | agência de modelos |
| 21 | Médico(a) | clínica |
| 22 | Segurança | show |
| 84 | Huggy | bico de entrega |
| 85 | John | encanador |
| 86 | Coco (Vitamin Coco) | vende vitaminas |
| 87 | Açougueiro | |
| 88 | Chefão | máfia |
| 89 | Pet Shop Boy | vende cães |
| 90 / 91 | Xavier / Elizabeth | dono(a) da mansão |
| 92 | Shaman | Everglades |
| 93 | Mia | |

**Genéricos (ids 23–83):** 30 nomes masculinos (Paco … John) e 31 femininos (Jordi … Ava),
aparência sorteada, interesses sorteados. Servem de população das ruas e alvos de
relacionamento livre.

## 3. Stats (16) — pacote 15

Fome, Sono, Higiene, Banheiro, Boa Forma, Cultura, Carisma, Crime, Bondade, Dança, Loucura,
Sex Appeal, Humor, Social, Saúde, Autoestima. Detalhes em `03-sistemas-de-jogo.md` §4.

## 4. Objetos interativos (77 classes) — pacote 12

Sair, Palmeira, Caixa de correio, Caixa de jornais, Detector de metal, Banco, Lixeira,
Espreguiçadeira, Restaurante, Café, Areia da praia, Geladeira, Chuveiro, Closet, Banheiro,
Cama, Computador, Pia, Porta da cela, Chaves, Pote de café, Scott/Callie, Jornal, Água,
Comida, Cozinha, Barbearia, Anão, Parquímetro, Lâmpada, Pizza, Bar, Mesa do DJ, Sofá, Tela,
Som, Console de jogo, TV, Banco supino, Parede, Cartazes, Jack, Carrinho de comida,
Plataforma, Sala de cirurgia, Clínica de beleza, Mesa de operação, Escultura, Cesto de
roupas, Iluminação, Boutique de moda, Fonte, Cinema, Gelatos, Loja, Telefone, Gran Kahuna,
Westwood, Planta, Piscina, Jacuzzi, Globetrotter, Gato, Cão, Mesa, Caixa automático, Radar,
Estante, Bronzeamento, Ir, Pia, Piano, Cadeira, Pet Shop Boy, Quadro, Sonda, Ave.

## 5. Ações de objeto (139) — pacote 13, ids 28–166

Agrupadas por função (o id original está entre parênteses):

* **Necessidades:** Urinar (28), Dormir (36), Cochilar (37), Lanchar (38), Comer (43),
  Usar banheiro (48), Lavar-se (50), Se arrumar (51), Secar o cabelo (52), Tomar banho
  (61), Vomitar (69), Relaxar (88), Arrumar a cama (80), Lavar louças (81), Limpar (101).
* **Comida/bebida:** Café (42), Bebida especial (44), Vitamina (45), Suco de frutas (47),
  Hambúrguer (66), Salada (67), Sorvete (68), Cappuccino (82), Chá (83), Torta de maçã
  (84), Pizza (85), Fruta (86), Leite (87), Sorvete de creme/morango/baunilha/caramelo
  (124–127), Presunto defumado (128), Bebida espanhola (129), Queijo francês (130), Sushi
  (131).
* **Cozinhar (Cultura/Fome):** Cozinhar (62), Fazer hambúrguer (157), Preparar salada
  (158), Fazer pizza (159), Fazer torta de maçã (160), Preparar sushi (161).
* **Crime:** Roubar correspondência (31), Roubar jornal (33), Roubar dinheiro (34), Roubar
  (57), Corromper (58), Vandalizar (59), Roubar chaves (104), Fazer grafite (140), Comer
  lixo (40), Cavar (46).
* **Bondade:** Pôr lixo (30), Pôr dinheiro (35), Dar dinheiro (142), Dar sanduíche (143),
  Regar a planta (145), Alimentar animal (63).
* **Cultura/lazer:** Ler notícias (32), Ver pessoas (39), Bronzear-se (41), Admirar arte
  (117), Programa de TV (93), Ler revista em quadrinhos (94), Romance (95), Livro erótico
  (96), Vídeos engraçados (97), Sites pagos (98), Checar email (99), Filme de terror /
  europeu / comédia / romance (74, 75, 132, 133), Notícias (76), Jogar videogame (77), Mass
  Infection / Treino Cerebral / Paris Nights / Bubble Bash 2 (89–92, jogos Gameloft na TV),
  Tocar piano (164), Nadar (165), Mixar música (139), Discurso (154), Cantar hino (155),
  Cantar à capela (79), Pular na cama (78).
* **Boa forma:** Levantar pesos (100), Polichinelo (162), Alongamento (163).
* **Dança:** Dançar techno / salsa / pop / metal (70–73).
* **Beleza:** Sala de cirurgia (116), Lipoaspiração (118), Rinoplastia (119), Lifting (120),
  Implantes de gelatina (121), Mudar imagem do perfil (113), Trocar de roupa (54), eSHOP
  (53), Closet/Abrir (55).
* **Trabalho:** Jogar cartazes no lixo (102), Colar cartazes (103), Entregar pizza (105),
  Conferir emprego (106), Entregar a caixa (107), Servir bebidas (109), Bebida esquecida
  (110), Figurante (114), Seguir câmera (115), Treinar modelos (141).
* **Animais:** Alimentar (148), Brigar (149), Brincar (150), Treinar: sentar (151), Assustar
  (146), Perturbar (147), Pet Shop Boy (153).
* **Telefone:** Enviar mensagem (29, 166), Pedir pizza (134), Chamar a polícia (135), Ligar
  para o fã clube dos Degubas (136), Ligar para a mãe (137).
* **Ambiente:** Música lig./desl. (111, 112), Luzes lig./desl. (122, 123), Vasculhar (138),
  Tirar um sarro (144), Sala de visitas (49), Ir (56), Anão (60), Cozinha/Restaurante (64,
  65), Caixa automático (152), Pia (156), Comprar vitamina (108).

## 6. Interação social — pacotes 10, 24, 20, 21, 22, 23, 27, 30

* 4 menus raiz + 55 opções (pacote 10).
* 38 categorias de assunto (pacote 24) × 175 interesses (pacote 20).
* 845 falas de tópico (pacote 21), 20 reações ofendidas (22), 20 reações de tédio (23).
* 90 saudações por humor/relacionamento (27), 157 "dicas de NPC" contextuais (30: o que o
  NPC quer agora — presente, banho, beijo…).
* 50 textos de encontro (25), 30 textos de telefonema de convite (28).

## 7. Missões (99) — pacote 18 (remetente, título, texto)

| # | Remetente | Título | # | Remetente | Título |
|---|---|---|---|---|---|
| 0 | Polícia | Vá até a Delegacia | 50 | Heather/Dean | Jantar |
| 1 | Polícia | Encontre Scott/Callie | 51 | Ceviche | Treinar modelos |
| 2 | Scott/Callie | Um Bico | 52 | Scott/Callie | Agenciador(a) de Modelos |
| 3 | Scott/Callie | Encontre o cachorro | 53 | Charm | Substituir o DJ! |
| 4 | Scott/Callie | Plano | 54 | Scott/Callie | DJ |
| 5 | Scott/Callie | Pague a fiança | 55 | Scott/Callie | Detetive particular |
| 6 | Goldsax | Classificados | 56 | Mortadella | Modelos – Garotos e Garotas |
| 7 | Huggy | Faça amizade com Huggy | 57 | Capitão do navio | Velho marinheiro |
| 8 | Huggy | Entrega | 58 | Hal Pachinko | Recompensa |
| 9 | Hal Pachinko | Consiga dinheiro com Huggy | 59 | Hal Pachinko | Pizza vitaminada |
| 10 | Gêmeas | Fale com a Opal | 60 | Inspetor | Faça amizade com o chefão |
| 11 | Opal | Leve o cachorro até Goldsax | 61 | Heather/Dean | Jogo de futebol |
| 12 | Scott/Callie | Chaves do apartamento | 62 | Proprietário | Chance |
| 13 | Proprietário | Faça amizade com o proprietário | 63 | Beatrice | Salve Westwood |
| 14 | Encanador | Tome um banho | 64 | Heather/Dean | Imobiliária Palm |
| 15 | Encanador | Geladeira | 65 | Elizabeth/Xavier | Faça amizade |
| 16 | Encanador | Troque de roupa | 66 | Elizabeth/Xavier | Entre na mansão |
| 17 | Proprietário | Conheça o apartamento | 67 | Elizabeth/Xavier | Beije |
| 18 | Scott/Callie | Plano | 68 | Elizabeth/Xavier | Amasso? |
| 19 | Scott/Callie | Alimentar o gato | 69 | Scott/Callie | Decore a casa |
| 20 | Inspetor | Vá ao apartamento | 70 | Scott/Callie | Encontre o DJ |
| 21 | Inspetor | Vá ao apartamento | 71 | DJ | Dance com o DJ |
| 22 | Scott/Callie | Personalize sua casa | 72 | DJ | Encontre o segurança |
| 23 | Scott/Callie | Detetive particular | 73 | Segurança | Ingresso para Show |
| 24 | Spillbeard | Trabalho: Figurante | 74 | Charm | Encontre cirurgiões plásticos |
| 25 | Opal | Trabalho: Assistente de Publicidade | 75 | Scott/Callie | Comece a festa! |
| 26 | Charm | Trabalho: Bartender | 76 | Sanchez | Procurando vitamina? |
| 27 | Hal (Rest. Yuca) | Trabalho: Entregador(a) | 77 | Guarda | Encontre minha identidade |
| 28 | Proprietário | Anões | 78 | MN2 | Chefão ou Inspetor |
| 29 | Spillbeard | Faça amizade com o Coordenador | 79 | Sanchez | Ajuda do Sanchez |
| 30 | Spillbeard | Trabalho de Figurante | 80 | Tira | Nós voltaremos... |
| 31 | Câmera | Oferta? | 81 | Scott/Callie | Pequeno desvio? |
| 32 | Scott/Callie | Experimente tudo! | 82 | Charm | Me convide para dançar |
| 33 | Opal | Cartazes | 83 | Scott/Callie | Presente |
| 34 | Chefe de Publicidade | Pagamento | 84 | Scott/Callie | Dar um mergulho |
| 35 | Scott/Callie | FESTA!!! | 85 | Opal | Flores |
| 36 | Hal Pachinko | Entrega de Pizzas | 86 | Elizabeth/Xavier | Mansão |
| 37 | Charm | Servir bebidas | 87 | Elizabeth/Xavier | Visitas |
| 38 | Scott/Callie | MN2TV | 88 | Nip e Took | Corte de Cabelo |
| 39 | MC | Luzes! | 89 | Capitão | Caça ao Tesouro! |
| 40 | MC | Música! | 90 | Capitão | Caça ao Tesouro! |
| 41 | MC | Festa! | 91 | MN2 | Sua Própria História |
| 42 | MC | Visite sua amiga/seu amigo | 92 | DJ | $1.000 |
| 43 | Heather/Dean | Novas roupas | 93 | Segurança | $500 |
| 44 | Goldsax | Galeão Espanhol Perdido | 94 | Heather/Dean | Fique mais sexy! |
| 45 | Sanchez | Oferta? Ofensa? | 95 | Transeunte | Pequeno desvio? |
| 46 | Sanchez | Gran Kahuna | 96 | Transeunte | Dar um mergulho |
| 47 | Guarda | Crocodilos adoram pizza! | 97 | Proprietário | Recompensa pelos Anões |
| 48 | Goldsax | Mapa | 98 | Scott/Callie | Sinta-se em casa |
| 49 | Goldsax | Amizade ou briga? | | | |

Pacotes de diálogo de missão por NPC: 33 (Huggy), 34 (Beatrice/Westwood), 35 (Charm), 36
(Opal), 37 (festa), 38 (Heather/Dean), 40 (Ceviche), 42 (Goldsax), 44/49 (Joey), 45
(Sanchez), 46 (polícia/Coco), 47 (encanador, classificados), 48, 51 (guarda), 52 (mansão),
32 (aluguel), 41 (fiança), 2 (presentes de NPC), 16 (avisos de necessidade), 29 (tutorial).

## 8. Conquistas / títulos (19) — pacote 9

Bronze/Silver/Gold Medallion; Figurante; Bartender; Assistente de Publicidade; Anão
Apaixonado / de Praia / Gourmet / Policial / Fashion / Degubas / de Segurança (7 anões);
Black Skull; Entregador(a); Agenciador(a) de Modelos; DJ; Detetive Particular; Chefão da
Máfia.

## 9. Itens

* **Presentes (8):** Bebida Especial $5, Flores $10, Dinheiro $20, Pres. Sexy $50, Camisa
  Pólo $15, Ingresso $20, Lingerie $25, Vitamina.
* **Roupas:** 30 cabelos (pacote 4), 31 tops (6), 30 bottoms (7), 13 calçados (8) — cada
  string tem versão masc./fem. (`\m…\m\f…\f`), em até 6 cores.
* **Móveis (60, pacote 31):** 3 sofás × 6 cores, 3 camas × 6 cores, 4 cômodas/armários,
  2 TVs, 4 almofadas, 2 computadores, 2 cadeiras × 6 cores.
* **Animais:** Scottish Terrier, French Bulldog, Beagle (pacote 5) + gato.
* **Itens de missão:** chaves, charutos, cartazes, caixa, identidade, mapa do tesouro,
  ingresso, anões ×7.

## 10. Empregos (4) — pacote 47

Figurante, Assistente de Publicidade, Bartender, Entrega de Pizza (ver `03` §8).

## 11. Áudio

| Entrada | Tipo | Uso |
|---|---|---|
| RES_SOUNDS, 24 entradas | MIDI | título, 4 estilos de dança, ambiente por região (praia, rua, boate, interior), tensão (polícia), vitória/derrota |
| 6 entradas | WAV 8 kHz mono | cliques de UI, moeda, latido, miado, beijo, soco |
| 1 entrada | AMR | jingle Gameloft |

## 12. Arte (para dimensionar a produção 3D)

| Pack | Conteúdo | Equivalente 3D |
|---|---|---|
| RES_MANPARTS / WOMANPARTS | ~100 peças × 3 vistas × paletas | ~100 malhas modulares + materiais |
| RES_TEXTURES (56 sprites) | tiles de chão/parede por região | ~10 kits de tiles/texturas PBR |
| RES_OBJECTS (ids ≥ 400 nas salas) | ~300 templates de decoração/móvel | ~250 props (muitos reaproveitáveis) |
| RES_NPCS | 30 cabeças/roupas únicas de elenco | 30 presets de paper-doll |
| RES_ANIMALS | cães ×3, gato, ave, crocodilo | 6 rigs animais |
| RES_HUD / RES_MENU | ícones de stat, fontes, mapa de Miami, molduras | UI vetorial |
| RES_FX | partículas (corações, Zzz, fedor, moscas, estrelas) | partículas GPU |
