# 08 — Plano progressivo Godot 4: cérebro + universo + expansão

Este é o **plano operacional** para fabricar o remake 3D. Não estima calendário: cada fase tem
arquivos a criar, checklist do inventário original (`04`) e critério de "pronto".

Referências obrigatórias:
* Regras → `03-sistemas-de-jogo.md`
* Inventário → `04-inventario-de-conteudo.md`
* Arquitetura → `05-arquitetura-android-3d.md`
* Formato de conteúdo → `06-pipeline-de-conteudo.md`
* Dados extraídos → `../00`…`../08`, `../CATALOGO.md`
* Exemplo já validado → `../10-remake-3d/`

---

## 0. Ideia em uma frase

**Cérebro** (simulação pura, sem gráficos) + **corpo** (Godot 3D / Android) + **memória**
(JSON de conteúdo) + **músculos** (arte GLB/animações). O cérebro nunca depende do Godot;
o Godot nunca inventa regras — só mostra e coleta input.

```
┌─────────────────────────────────────────────────────────────┐
│  JOGADOR (toque Android)                                    │
└──────────────────────┬──────────────────────────────────────┘
                       ▼
┌─────────────────────────────────────────────────────────────┐
│  CORPO — Godot 4.x                                          │
│  Cenas 3D · câmera · UI · áudio · AnimationTree · export APK│
└──────────────────────┬──────────────────────────────────────┘
                       ▼  eventos (tick, interact, talk, enter…)
┌─────────────────────────────────────────────────────────────┐
│  CÉREBRO — core/ (puro, testável sem Godot)                 │
│  Time · Stats · Relationships · Economy · Schedule · Quests │
│  RuleInterpreter · ContentRegistry · Save · WorldState      │
└──────────────────────┬──────────────────────────────────────┘
                       ▼  lê / escreve
┌─────────────────────────────────────────────────────────────┐
│  MEMÓRIA — content/*.json + packs em user://mods/           │
│  locations · npcs · items · interactions · quests · dialogue│
│  jobs · schedules · stats · strings · achievements          │
└─────────────────────────────────────────────────────────────┘
                       ▲
┌──────────────────────┴──────────────────────────────────────┐
│  MÚSCULOS — assets/                                         │
│  models/*.glb · animations · textures · audio · ui          │
└─────────────────────────────────────────────────────────────┘
```

---

## 1. Mapa completo de arquivos do projeto Godot

Raiz real do projeto Godot: **`Miami_2/godot/miami3d/`** (ver `Miami_2/godot/PHASES.md`).
Schemas continuam em `Miami_2/10-remake-3d/schemas/`; o pack de runtime fica em
`godot/miami3d/content/`.

### 1.1 Cérebro — `core/` (nenhum `Node`, nenhum `extends Node`)

| Arquivo | Responsabilidade | Fonte das regras |
|---|---|---|
| `core/game.gd` | Orquestra sistemas; barramento de eventos; tick | — |
| `core/types.gd` | Enums: `StatId`, `SocialMenu`, `EventKind`, flags NPC | `03` §4–6 |
| `core/time_system.gd` | Dia/minuto, escala 1 s = 1 min, `advance_minutes`, horários | `03` §3 |
| `core/stat_system.gd` | 16 stats, taxas/h, limiares, avisos, colapso | `03` §4, `content/stats.json` |
| `core/relationship_system.gd` | 97 slots × registro (amizade/romance/humor/flags/interesses) | `03` §5 |
| `core/economy_system.gd` | Dinheiro, banco (juros), aluguel, fiança, multas | `03` §8 |
| `core/inventory_system.gd` | Itens, stack, presentes, quest items | `04` §9 |
| `core/schedule_system.gd` | Rotinas NPC: local + janela de horário | `03` §5.3 |
| `core/quest_machine.gd` | Máquinas de estado das 99 missões | `03` §7, `04` §7 |
| `core/rule_interpreter.gd` | Avalia `when` / executa `do` (linguagem do `06` §4) | `06` §4 |
| `core/dialogue_system.gd` | Menus sociais, assuntos, reações like/neutral/dislike | `03` §6 |
| `core/dating_system.gd` | SAIR JUNTO: convite → compromisso → sequência no local | `03` §6.3 |
| `core/job_system.gd` | 4 empregos, turnos, promoções (medalhões) | `03` §8, `04` §10 |
| `core/crime_system.gd` | Crime ≥ 80 → prisão, fiança, testemunhas | `03` §4.2 |
| `core/home_system.gd` | Níveis LOW/MID A/MID B/HI, slots de móvel, anões, colega | `03` §10 |
| `core/pet_system.gd` | Cão (3 raças) + gato: fome, treino, ações | `03` §10 |
| `core/appearance_system.gd` | Vetor `[gênero,pele,cabelo,…]` + Sex Appeal | `03` §9 |
| `core/world_state.gd` | Local atual, célula, flags globais, mapa desbloqueado | `03` §1, §11 |
| `core/content_registry.gd` | Carrega/valida JSON; resolve `@strings`; merge de packs/mods | `06` |
| `core/save_system.gd` | Save JSON versionado + migrações | `05` §6 |
| `core/string_table.gd` | Resolve tags `{player}`, `{m:…\|f:…}`, BBCode | `02` / `03` §6.4 |
| `core/rng.gd` | RNG seedável (paridade de testes) | — |
| `core/events.gd` | Sinais: `minute_tick`, `stat_changed`, `quest_stage`, … | — |

### 1.2 Corpo — `game/` (cenas Godot)

| Arquivo / pasta | Função |
|---|---|
| `game/bootstrap.gd` | Autoload: instancia `Game` + `ContentRegistry` |
| `game/main.tscn` | Splash → menu → novo/continuar |
| `game/world/location_controller.gd` | Carrega local, aplica grade, spawna objetos/NPCs |
| `game/world/grid_map.gd` | Flags de célula, A\*, conversão célula↔mundo |
| `game/world/portal.gd` | `Area3D` → troca de local |
| `game/world/zone.gd` | Tags indoor/shade/beach/dancefloor |
| `game/world/cutaway_walls.gd` | Esconde paredes voltadas à câmera |
| `game/world/locations/*.tscn` | Uma cena por local (25) |
| `game/actors/player.tscn` + `.gd` | Tap-to-move, paper-doll, AnimationTree |
| `game/actors/npc.tscn` + `.gd` | Rotina, menu social, pathfinding |
| `game/actors/pet.tscn` + `.gd` | Cão/gato |
| `game/actors/paper_doll.gd` | Troca malhas dos 5 slots + tint |
| `game/actors/animation_map.gd` | Estado lógico → clipe 3D |
| `game/objects/interactable.tscn` + `.gd` | Footprint, useCell, menu de ações |
| `game/objects/furniture_slot.gd` | Slot de móvel no apartamento |
| `game/camera/iso_camera.gd` | 3/4, 4 rotações de 90°, zoom |
| `game/ui/hud.tscn` | 4 necessidades, relógio, dinheiro |
| `game/ui/radial_menu.tscn` | Ações de objeto |
| `game/ui/social_menu.tscn` | CONVERSAR / OFERECER / FLERTAR / OFENDER |
| `game/ui/dialogue_panel.tscn` | Falas + tags |
| `game/ui/phone.tscn` | Agenda, estatísticas, mensagens, missões |
| `game/ui/city_map.tscn` | 9 regiões / 25 locais |
| `game/ui/character_creator.tscn` | Gênero + 10 slots de aparência |
| `game/ui/closet.tscn` / `shop.tscn` / `bank_atm.tscn` | Lojas e banco |
| `game/ui/pause_menu.tscn` | Salvar / opções / sair |
| `game/minigames/dance.tscn` | Sequência de setas (4 estilos) |
| `game/minigames/photo.tscn` | Selfie de perfil |
| `game/minigames/posters.tscn` | Trabalho de publicidade |
| `game/fx/*.tscn` | Corações, Zzz, fedor, moscas, estrelas |

### 1.3 Memória — `content/` (já existe o exemplo; expandir)

| Pasta / arquivo | Cobre o inventário |
|---|---|
| `content/pack.json` | Metadados do pack base |
| `content/stats.json` | 16 stats + prisão/fiança |
| `content/strings/pt-BR.json` (+ `en.json` depois) | Todos os textos do remake |
| `content/locations/*.json` | **25** locais (`04` §1) |
| `content/npcs/*.json` | **94** nomes / **97** slots (`04` §2) |
| `content/items/*.json` | Objetos, móveis, presentes, comida, roupas, quest (`04` §4, §9) |
| `content/interactions/*.json` | **139** ações de objeto + sociais (`04` §5–6) |
| `content/quests/*.json` | **99** missões (`04` §7) |
| `content/dialogue/topics.json` | 38 categorias × 175 interesses × falas (`04` §6) |
| `content/dialogue/reactions.json` | Ofendido / tédio / saudação |
| `content/jobs/*.json` | 4 empregos (`04` §10) |
| `content/schedules/*.json` | Rotinas reutilizáveis |
| `content/achievements.json` | 19 títulos (`04` §8) |
| `content/regions.json` | 9 regiões do mapa da cidade |
| `content/gifts.json` | Tabela rápida dos 8 presentes |
| `content/surgery.json` | Lipo / rino / lifting / implantes |
| `content/rent.json` | $300 / mansão $2000, prazos, avisos |

Schemas (já em `../schemas/`):
`common`, `location`, `npc`, `item`, `interaction`, `quest`, `stats`
— acrescentar depois: `job.schema.json`, `schedule.schema.json`, `dialogue.schema.json`,
`achievement.schema.json`.

### 1.4 Músculos — `assets/`

| Pasta | Conteúdo |
|---|---|
| `assets/models/characters/rig_human.glb` | Rig único |
| `assets/models/characters/heads/`, `hair/`, `tops/`, `bottoms/`, `shoes/` | Paper-doll (~30+31+30+13) |
| `assets/models/npc_unique/` | Cabeças do elenco principal |
| `assets/models/furniture/` | 60 móveis |
| `assets/models/props/` | ~250 props de decoração (por kit de local) |
| `assets/models/pets/` | 3 cães + gato (+ ave, crocodilo) |
| `assets/models/kits/<local>/` | Chão, paredes, kits por região |
| `assets/animations/anims_human.glb` | Clipes (idle/walk/run/sit/sleep/eat/drink/dance×4/kiss/fight/faint/swim/piano/lift/sweep/cook/work_*/pee/shower/wave/talk/laugh/angry…) |
| `assets/textures/`, `assets/audio/`, `assets/ui/` | PBR, OGG, ícones HUD |

### 1.5 Ferramentas e testes

| Arquivo | Função |
|---|---|
| `../tools/mn2_extract_all.py` (+ individuais) | Regenera referência 2D |
| `../tools/validate_content.py` | Valida packs |
| `../tools/room_to_godot.py` | `07-salas/room_NN.json` → placeholders na cena |
| `../tools/appearance_preview.py` | Preview do vetor paper-doll |
| `miami3d/tests/test_*.gd` | Testes do cérebro (SceneTree headless) |
| `miami3d/tests/text_day.gd` | "Jogo de texto" de um dia |

### 1.6 O que NÃO entra no remake (mas fica como referência)

Pastas `../00`…`../08` (JAR, classes, sprites Gameloft, strings originais, MIDI original).
Usar só para medir paridade e posicionar placeholders — **arte/áudio/texto do remake são próprios**.

---

## 2. Cérebro operacional — contrato de eventos

Todo o corpo fala com o cérebro só por estes eventos:

**Entrada (corpo → cérebro)**

| Evento | Quando |
|---|---|
| `tick_real(delta_s)` | Cada frame; o `TimeSystem` acumula até virar minuto de jogo |
| `interact(object_id, action_id)` | Jogador escolhe ação no radial |
| `talk(npc_id, social_action_id, payload?)` | Menu social (assunto, presente, flerte…) |
| `enter_location(location_id, spawn_id)` | Portal / mapa / teleporte |
| `leave_location()` | — |
| `use_phone(action, …)` | Agenda, ligar, pagar aluguel no ATM |
| `buy(item_id)` / `equip(…)` / `place_furniture(slot, item)` | Lojas / closet |
| `start_minigame_result(id, won, score)` | Dança, cartazes, foto |
| `advance_time_request(minutes)` | Dormir / trabalho / cirurgia (confirmado na UI) |

**Saída (cérebro → corpo)**

| Evento | Corpo reage com |
|---|---|
| `minute_tick` / `hour_tick` / `day_tick` | Luz, rotinas, HUD |
| `stat_changed` / `warning` / `collapse` | Barras, avisos, cutscene de desmaio |
| `dialogue_requested` | Painel de diálogo |
| `quest_stage_entered` / `quest_completed` | Marcador no mapa, notificação |
| `spawn_npc` / `despawn_npc` / `move_npc` | Instanciar / remover / pathfind |
| `teleport` / `unlock_location` | Trocar cena / ícone no mapa |
| `play_sound` / `play_music` / `cutscene` | Áudio / câmera |
| `notify` | Toast ATENÇÃO / DICA / MISSÃO |
| `save_hint` | Autosave em pontos seguros |

O `RuleInterpreter` é o coração: qualquer gatilho de local, estágio de missão ou ação social
vira `when` + `do` em JSON — **sem bytecode novo**.

---

## 3. Checklist do inventário original → fase que cobre

### 3.1 Locais (25) — `04` §1

| Fase | Locais |
|---|---|
| A | `player_apartment` (LOW) + `apartment_garden` + `first_street` |
| B | `police_station` (prólogo) |
| C | `south_beach` (prólogo praia) |
| D | `restaurant_yuca`, `glight_club`, `press_office`, `stadium` (empregos) |
| E | `little_havana`, `ocean_drive`, `coconut_grove`, `lounge`, `beauty_salon`, `cuban_cafe` |
| F | aptos NPC / Heather-Dean, `mansion`, `everglades`, porto/iate, `pelican_island`, `key_biscayne`, Mid/Hi apartment, Miami Beach |
| Expansão | qualquer local novo via pack JSON + cena |

### 3.2 Sistemas / cérebro

| Sistema | Fase mínima |
|---|---|
| Time + 4 necessidades + colapso | A |
| 12 stats restantes + Crime/prisão | B–C |
| Relacionamento + 4 menus sociais + assuntos | B |
| QuestMachine + RuleInterpreter | B |
| Economia + ATM + aluguel | B |
| Paper-doll + creator | B |
| Jobs ×4 | D |
| Dating / SAIR JUNTO | E |
| Home tiers + 60 móveis + 7 anões | E–F |
| Pets | E |
| Cirurgia / Sex Appeal | E |
| Dança minigame | D |
| Mapa 9 regiões + 25 portais | C–F |
| Mods / packs externos | G |

### 3.3 Conteúdo numérico (paridade)

| Item | Qtd | Fase que completa |
|---|---|---|
| Locais | 25 | F |
| NPCs nomeados | 94 | F |
| Stats | 16 | A–C |
| Classes de objeto | 77 | F |
| Ações de objeto | 139 | E–F |
| Menus/opções sociais | 4 + ~55 | B–E |
| Categorias / interesses / falas | 38 / 175 / ~845 | B–F (pode começar com subset) |
| Missões | 99 | F |
| Presentes | 8 | B |
| Móveis | 60 | E–F |
| Conquistas | 19 | F |
| Empregos | 4 | D |
| Anões | 7 | E |
| Raças de cão | 3 + gato | E |
| Animações lógicas | ~40 clipes (cobertura das 237) | B–F |

---

## 4. Fases progressivas (operacionais)

Cada fase = commit jogável. Arte começa em **placeholder** (CSG/primitivos + kits baixos) e
é substituída por GLB sem mudar o cérebro.

### Fase 0 — Base já feita (repositório atual) ✅

* Extração 00–08, docs 01–07, schemas, `content/` exemplo, tools.
* **Pronto:** `validate_content.py --strict` verde; `mn2_extract_all.py` reproduz pastas.

### Fase A — Cérebro vivo + apartamento jogável (MVP)

**Arquivos a criar**
* `miami3d/project.godot`, `export_presets.cfg` (Android)
* `core/` completo mínimo: `game`, `time`, `stat`, `inventory`, `world_state`,
  `content_registry`, `rule_interpreter`, `save`, `string_table`, `events`
* `game/world/` + cenas `player_apartment`, `apartment_garden`, `first_street` (placeholders
  gerados de `07-salas/`)
* `game/actors/player` (cápsula + paper-doll vazio)
* `game/ui/hud` + radial
* Expandir `content/`: stats, 3 locais, itens do apartamento, interações básicas, strings pt-BR
* `tests/test_stats.gd`, `tests/text_day.gd`

**Checklist inventário:** Fome/Sono/Higiene/Banheiro; ações dormir/banho/geladeira/banheiro;
portal apartamento↔rua; ciclo 24 h.

**Pronto quando:** 1 dia de jogo no editor (e idealmente APK) sem desmaio, só com necessidades.

### Fase B — Personagem, NPC, diálogo, 1 missão, economia

**Arquivos:** `appearance_system`, `relationship_system`, `dialogue_system`, `quest_machine`,
`economy_system`, `character_creator`, `social_menu`, `dialogue_panel`, `phone` (parcial),
`npc.tscn`, `paper_doll.gd`, animações idle/walk/talk, ATM, `content/npcs/landlord.json` +
missão `q_landlord` (já esboçada), presentes básicos.

**Checklist:** creator; 1 NPC com 2 estrelas; CONVERSAR/OFERECER; dinheiro; aluguel lembrete.

**Pronto quando:** tutorial do senhorio + jardim jogável.

### Fase C — Prólogo (praia → delegacia → amigo)

**Arquivos:** locais `south_beach`, `police_station`; NPCs Scott/Callie, polícia, inspetor;
missões 0–5; Crime/fiança; mapa parcial (2–3 ícones); cutscenes simples.

**Pronto quando:** do “acordar na praia” até as chaves do apartamento.

### Fase D — Quatro empregos + skills

**Arquivos:** `job_system`; locais Yuca, Glight, Press, Stadium; NPCs Huggy, Hal, Opal, Charm,
Spillbeard; missões de emprego; minigames dança + cartazes; stats Dança/Carisma/Cultura.

**Pronto quando:** os 4 empregos contratam, pagam e avançam o relógio.

### Fase E — Vida social plena + casa + pets

**Arquivos:** `dating_system`, `home_system`, `pet_system`; assuntos (subset→completo);
encontros; 60 móveis + loja; 7 anões; Pet Shop; Clínica (cirurgia); Lounge/Coconut/Ocean/Little Havana.

**Pronto quando:** namoro, colega de quarto, decorar casa, achar anões, ter um pet.

### Fase F — Paridade de história

**Arquivos:** locais restantes; 99 missões; 19 conquistas; mansão; Everglades/tesouro; arco
mafioso (escolha); Mid/Hi apartment; elenco completo; diálogo completo.

**Pronto quando:** checklist `04` marcado; final "Sua Própria História".

### Fase G — Expansão (caminho para mais coisas)

**Arquivos:** loader de `user://mods/<pack>/`; `pack.json` com `dependencies`; merge `actions+`;
docs `CRIADORES.md`; opcional editor in-game (Tool); schemas novos.

**Receitas (sem recompilar o APK):**

| Quero… | Arquivos |
|---|---|
| Novo local | `locations/x.json` + `assets/models/kits/x/` + portal em outro local |
| Novo NPC | `npcs/x.json` + `schedules/x.json` (+ head GLB se único) |
| Nova missão | `quests/x.json` + strings + gatilho em location/npc |
| Novo móvel/roupa | `items/x.json` + GLB no slot |
| Nova ação | `interactions/x.json` + incluir em `actions` do item |
| Novo emprego | `jobs/x.json` |
| Novo assunto | entrada em `dialogue/topics.json` |
| Novo pack inteiro | pasta `mods/meu_pack/` com `pack.json` |

**Pronto quando:** um `.zip` de mod adiciona local+NPC+missão e aparece no jogo.

### Fase H — Polimento Android

Export AAB, LOD, Compatibility renderer, safe area, pt-BR+en, crash reporting, store listing.
(Pode começar em paralelo a partir da Fase A.)

---

## 5. Ordem de modelagem 3D (não bloqueia o cérebro)

1. **Placeholders** (CSGBox / capsules) — Fases A–B  
2. **Kit apartamento + rua** (chão, parede, 10 props) — A–B  
3. **Rig humano + 5 slots mínimos** (1 opção cada) — B  
4. **Expandir roupas/cores** — C–E  
5. **Kits por região** (praia, boate, estádio…) — C–F  
6. **Elenco único (cabeças)** — C–F  
7. **Pets / FX / UI final** — E–H  

Trocar um placeholder por GLB = **zero mudança no cérebro**; só o path no JSON/`mesh`.

---

## 6. Ordem de implementação sugerida ao pedir "faz a próxima fase"

1. `Fase A` (cérebro + apartamento)  
2. `Fase B` (NPC + missão senhorio)  
3. `Fase C` (prólogo)  
4. `Fase D` (empregos)  
5. `Fase E` (social/casa/pets)  
6. `Fase F` (paridade)  
7. `Fase G` (mods) em paralelo a partir de E  
8. `Fase H` (store) no fim  

Cada pedido deve citar a fase: ex. *“implementa a Fase A do plano 08”*.

---

## 7. Matriz “não esquecer nenhum arquivo” (auditoria)

Antes de declarar Fase F pronta, conferir:

- [x] 25 `content/locations/*.json` + 25 `game/world/locations/*.tscn` (3 detalhados + stubs; jardim extra)
- [x] Pack conteúdo: npcs/items/interactions/quests/dialogue/jobs/schedules/achievements/regions/gifts/surgery/rent
- [x] `assets/` + `MnAssetRegistry` / `MnMeshFactory` (placeholders GLB, paper-doll, kits, anims, UI)
- [x] `room_to_godot.py` + `appearance_preview.py` + `validate_content.py --lite` + `tests/test_*.gd`
- [ ] 94 `content/npcs/*.json` (ou generativos + overrides do elenco)
- [ ] 16 entradas em `stats.json`
- [ ] ≥ 77 templates em `items/` (objetos) + 60 móveis + 8 presentes + roupas + quest items
- [ ] ≥ 139 `interactions/`
- [ ] 99 `quests/`
- [ ] `dialogue/topics.json` com 38 categorias
- [ ] 4 `jobs/`
- [ ] 19 `achievements`
- [ ] `regions.json` (9)
- [ ] Todos os sistemas da tabela §1.1 existem e têm teste
- [ ] Todas as UIs da tabela §1.2 existem
- [ ] `validate_content.py --strict` verde no pack base e em 1 mod de exemplo
- [ ] Save carrega/salva um jogo no fim do prólogo
- [ ] APK Android abre no device de teste

---

## 8. Relação com o que já está no repo

| Já existe | Uso neste plano |
|---|---|
| `Miami_2/00`…`08` | Referência visual/espacial para Fases A–F |
| `09` docs 01–07 | Regras e inventário |
| `10-remake-3d/schemas` | Validação desde Fase A |
| `10-remake-3d/content` | Semente da Fase A (apartamento/jardim/rua/senhorio) |
| `tools/*` | Regenerar referência; validar; depois `room_to_godot` |

O próximo passo concreto de código, quando você pedir, é **criar `miami3d/` e a Fase A**.
