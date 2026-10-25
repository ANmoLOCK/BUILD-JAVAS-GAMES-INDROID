# 06 — Pipeline de conteúdo (como adicionar mais jogo sem tocar no núcleo)

O original já era orientado a dados (strings, salas, scripts, tabelas em arrays). O remake
formaliza isso em **JSON validado por JSON Schema** (`schemas/`) e organizado em **packs**.
Um pack é uma pasta (ou `.zip`) com `pack.json` e subpastas por tipo. O pack base fica em
`content/`; packs extras (expansões, mods) são carregados de `user://mods/` e **sobrepõem ou
adicionam** por `id`.

## 1. Layout de um pack

```
content/
  pack.json                 # id, versão, dependências, ordem de carga
  strings/pt-BR.json        # tabela de textos (chave → texto com tags)
  stats.json                # 16 stats: taxas, limiares, avisos
  locations/*.json          # 1 arquivo por local: grade, objetos, NPCs, portais, zonas, horário
  npcs/*.json               # elenco: aparência, gostos, rotina, diálogo de saudação
  items/*.json              # presentes, comida, roupas, móveis, itens de missão
  interactions/*.json       # ações de objeto (DORMIR, COMER…) e sociais (ELOGIO…)
  quests/*.json             # máquinas de estado de missão
  dialogue/topics.json      # categorias → interesses → falas
  dialogue/reactions.json   # reações por polaridade/humor
  jobs/*.json               # empregos e turnos
  schedules/*.json          # rotinas reutilizáveis
```

Ids são `snake_case` únicos **globalmente por tipo** (`location:south_beach`,
`npc:goldsax`). Um pack pode referenciar ids de outro pack declarado em `dependencies`.

## 2. Formatos (resumo; schemas completos em `schemas/*.schema.json`)

### 2.1 `pack.json`

```json
{ "id": "base", "version": "1.0.0", "name": "Miami 3D — base", "dependencies": [], "priority": 0 }
```

### 2.2 Location

```json
{
  "id": "south_beach", "name": "@loc.south_beach", "region": "south_beach",
  "scene": "res://game/world/south_beach.tscn",
  "openHours": [0, 24], "music": "beach_day", "indoor": false,
  "grid": { "width": 107, "height": 106 },
  "spawn": { "cell": [40, 22], "facing": "S" },
  "portals": [ { "cell": [0, 50], "to": "ocean_drive", "spawn": "from_beach" } ],
  "zones":   [ { "rect": [10, 10, 30, 20], "tag": "beach" } ],
  "objects": [ { "id": "lounger_1", "template": "sun_lounger", "cell": [12, 14], "facing": "E" } ],
  "npcs":    [ { "npc": "huggy", "schedule": "huggy_default" }, { "generic": true, "count": 8 } ],
  "triggers": [ { "on": "enter", "when": { "quest": {"id": "q000_police", "stage": "start"} }, "do": [ {"dialogue": "@q000.intro"} ] } ]
}
```

A grade e a colisão vêm da cena 3D (NavMesh) mas a **lógica** continua em células: o
`ContentRegistry` gera o `PackedByteArray` de flags a partir dos `footprint` dos objetos e
das `zones`.

### 2.3 Object template e interactions

```json
{ "id": "bed_designer", "name": "@obj.bed", "mesh": "res://assets/models/furniture/bed_designer.glb",
  "footprint": [2, 3], "useCell": [0, 3], "facing": "N",
  "category": "bed", "price": 450, "colors": ["green","blue","red","yellow","orange","white"],
  "actions": ["sleep_fast", "nap", "jump_on_bed"] }
```

```json
{ "id": "sleep_fast", "name": "@act.sleep", "animation": "sleep", "durationMinutes": 420,
  "requires": { "stat": {"sleep": {">=": 20}} },
  "effects": [ {"stat": "sleep", "delta": -80}, {"stat": "hunger", "delta": 15} ],
  "advancesTime": true, "cooldownMinutes": 0 }
```

Ações sociais usam o mesmo formato com `target: "npc"` e efeitos em `friendship/romance/mood`
e `requires` sobre o relacionamento (`{"friendshipLevel": {">=": 2}, "npcMood": {">=": 50}}`).

### 2.4 NPC

```json
{ "id": "goldsax", "name": "@npc.goldsax", "gender": "f",
  "appearance": [1, 1, 12, 2, 5, 0, 9, 3, 4, 1],
  "likes": ["business", "fashion", "money"], "dislikes": ["pets"],
  "schedule": "goldsax_default", "greetings": "@greet.business",
  "phoneUnlock": { "friendshipLevel": 2 }, "dateable": false }
```

### 2.5 Quest (máquina de estados)

```json
{ "id": "q002_um_bico", "sender": "npc:scott", "title": "@q002.title", "text": "@q002.text",
  "start": "talk_huggy",
  "stages": {
    "talk_huggy": {
      "objective": "@q002.obj1",
      "onEnter": [ {"markMap": "little_havana"} ],
      "transitions": [ { "when": {"event": "talked_to", "npc": "huggy", "friendshipLevel": {">=": 2}},
                         "do": [ {"giveItem": "cigars"}, {"dialogue": "@q002.huggy_ok"} ], "to": "deliver" } ]
    },
    "deliver": {
      "objective": "@q002.obj2",
      "transitions": [ { "when": {"event": "talked_to", "npc": "hal_pachinko", "hasItem": "cigars"},
                         "do": [ {"takeItem": "cigars"}, {"money": 50}, {"stat": {"charisma": 5}}, {"achievement": "courier"} ], "to": "done" } ]
    },
    "done": { "final": true, "onEnter": [ {"startQuest": "q005_pague_a_fianca"} ] }
  } }
```

### 2.6 Dialogue topics

```json
{ "categories": [ { "id": "sports", "name": "@topic.sports",
    "interests": [ { "id": "football", "name": "@int.football",
      "lines": { "player": ["@l.football.p1", "@l.football.p2"], "npcLike": ["@l.football.y1"], "npcNeutral": ["@l.football.n1"], "npcDislike": ["@l.football.d1"] } } ] } ] }
```

### 2.7 Strings

`strings/pt-BR.json` é um mapa `chave → texto`. Tags suportadas (herdadas do original):
`{player}`, `{npc}`, `{place}`, `{m:…|f:…}` (gênero do jogador), `[b]…[/b]` destaque,
`\n` e `|` quebra de página. Qualquer campo que começa com `@` nos outros JSON é uma chave
de string. Novos idiomas = novo arquivo `strings/<locale>.json`.

## 3. Como "implementar mais conteúdo" — receitas

| Quero… | Faço… |
|---|---|
| Um novo local | `locations/novo.json` + cena GLB/TSCN; adiciono portal em um local existente; (opcional) entrada no mapa `regions` |
| Um novo NPC | `npcs/novo.json` + `schedules/novo.json`; se tiver cabeça única, GLB em `assets/models/heads/` |
| Um novo móvel/objeto | `items/novo.json` (template) + `interactions/*.json` para as ações + GLB |
| Uma nova ação em objeto existente | nova entrada em `interactions/` e acrescento o id em `actions` do template (packs podem fazer *merge* de arrays com `"actions+": [...]`) |
| Uma nova missão | `quests/nova.json` + strings; gatilho de início por `triggers` de local, `onTalk` de NPC ou `onEnter` de outra quest |
| Novo assunto de conversa | nova categoria/interesse em `dialogue/topics.json` e incluir nos `likes` de NPCs |
| Novo emprego | `jobs/novo.json` (`shifts`, `requires`, `pay`, `promotions`) + objeto "CONFERIR EMPREGO" |
| Novo item de roupa | `items/` com `slot: "top"`, `mesh`, `colors`, `statBonus` |
| Novo minigame | único caso que exige código: cena Godot + registrar `minigame:<id>` como ação |

Validação: `python3 tools/validate_content.py content/ --strict` (já incluído; usa os
schemas em `schemas/` e confere referências cruzadas e chaves de string). Qualquer arquivo em
`items/`, `interactions/`, `npcs/`, `quests/` ou `locations/` pode conter **uma definição ou
uma lista** de definições (útil para agrupar ações pequenas, como em
`content/interactions/apartment_basics.json`). O `ContentRegistry` repete a validação em
runtime em *debug*.

## 4. Linguagem de regras (substitui o bytecode de scripts)

Condições (`when`) — objeto JSON; chaves combinadas com AND; `anyOf`/`not` para OR/NOT:

| Chave | Exemplo | Equivalente no original |
|---|---|---|
| `event` | `"talked_to"`, `"used_object"`, `"entered"`, `"left"`, `"time"`, `"stat_changed"`, `"item_gained"`, `"date_started"` | tipo de evento da sala (0,1,2,3,5) |
| `npc`, `object`, `location` | id | parâmetros do evento |
| `quest` | `{"id":"q1","stage":"x"}` | comparação de estado de missão |
| `stat` | `{"hunger": {"<": 50}}` | op 21/22 |
| `friendshipLevel`, `romance`, `npcMood` | `{">=": 2}` | leitura do registro NPC |
| `money` | `{">=": 300}` | op 31 |
| `hasItem` / `hasNotItem` | id | op 41/42 |
| `time` | `{"hour": {">=": 20}}`, `{"dayOfWeek": 0}` | op 60 |
| `flag` | `"gnome_3"` | bits do save |
| `random` | `0.3` | op 50 |
| `appearance` | `{"gender": "m"}` | gênero |

Ações (`do`) — lista ordenada:

| Ação | Exemplo | Equivalente |
|---|---|---|
| `dialogue` | `"@key"` ou `{"npc":"x","lines":["@a","@b"]}` | op 100/102 |
| `money`, `bank` | `50`, `-200` | op 31/32 |
| `stat` | `{"hunger": -20}` | op 21 |
| `relationship` | `{"npc":"x","friendship": 10,"romance": 5,"mood": 10}` | op 105–108 |
| `giveItem` / `takeItem` | id | op 41/43 |
| `startQuest`, `setStage`, `completeQuest`, `failQuest` | id / `{"quest":"q","stage":"s"}` | tabela de missões |
| `spawnNpc` / `despawnNpc` / `moveNpc` | `{"npc":"x","cell":[3,4],"facing":"S"}` | op 100/101/109 |
| `teleport` | `{"location":"x","spawn":"y"}` | op 110 |
| `advanceTime` | minutos | "30 minutos se passaram" |
| `schedule` | `{"npc":"x","location":"y","inMinutes":120}` | op 137 |
| `unlockLocation` / `lockLocation` | id | op 111 |
| `setFlag` / `clearFlag` | id | bits do save |
| `cutscene` | `{"camera":"cam_1","anim":"x"}` | op 113 |
| `playSound`, `playMusic` | id | op 114 |
| `achievement` | id | pacote 9 |
| `minigame` | `{"id":"dance","style":"salsa","onWin":[…],"onLose":[…]}` | estado de minigame |
| `notify` | `"@key"` | caixa ATENÇÃO/DICA |

O interpretador tem ~300 linhas e é totalmente testável sem engine.

## 5. Pipeline de arte (convenções)

* Blender → GLB (glTF 2.0), unidade 1 m = 1 célula, eixo Y para cima, origem no **canto
  da célula âncora**, nome do mesh = id do item.
* Personagem: rig humanoide único (`rig_human`), malhas de roupa com `Armature` modifier
  apontando para o mesmo rig; slots = nomes de mesh `head_*`, `hair_*`, `top_*`,
  `bottom_*`, `shoes_*`. Material com parâmetro `tint` para cores.
* Animações: um GLB `anims_human.glb` com todos os clipes; nomes `idle`, `walk`, `run`,
  `sit`, `sleep`, `eat`, `drink`, `dance_techno`, `dance_salsa`, `dance_pop`, `dance_metal`,
  `kiss`, `fight`, `faint`, `swim`, `piano`, `lift`, `sweep`, `cook`, `work_bar`,
  `work_poster`, `work_delivery`, `pee`, `shower`, `wave`, `talk`, `laugh`, `angry`.
* Texturas: 1024² máx., ASTC no export Android; atlas por kit de local.
* Áudio: OGG Vorbis 44,1 kHz; música em *loop*; nomes = ids referenciados em JSON.

## 6. Usando os dados do original como referência (sem copiar)

As ferramentas em `tools/` produzem, a partir do JAR do usuário, JSON intermediários
(`rooms/room_NN.json`, `strings.json`, `manifest.json`). Eles **não** vão para o repositório,
mas servem para:

1. Reconstruir o layout de cada local (posição de objetos, portais, spawn) ao modelar a cena
   3D — importe `room_NN.json` num *addon* Blender ou num script Godot que posiciona
   *placeholders* na grade.
2. Conferir contagens e ids ao escrever o conteúdo próprio (paridade).
3. Rodar testes de paridade da simulação (mesmas taxas, mesmos limiares).
