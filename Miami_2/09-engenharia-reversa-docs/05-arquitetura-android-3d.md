# 05 — Arquitetura do remake 3D para Android

Objetivo: um jogo **3D nativo para Android** (APK/AAB com código ARM64 nativo, sem WebView,
sem emulador J2ME) que reproduza as mecânicas descritas em `03-sistemas-de-jogo.md` e permita
adicionar conteúdo sem recompilar o núcleo.

## 1. Escolha de engine

| Critério | **Godot 4.x (recomendado)** | Kotlin + Filament (NDK) | Unity | Unreal |
|---|---|---|---|---|
| Saída Android | APK/AAB nativo (libgodot ARM64), export oficial | 100 % nativo, controle total | nativo (IL2CPP) | nativo |
| Custo/licença | MIT, sem royalties | Apache 2 | assinatura/royalty por instalação | 5 % royalty |
| Tamanho do APK base | ~25 MB (mobile renderer) | ~8 MB | ~40 MB | >100 MB |
| Renderer para low-end | *Mobile* (Vulkan) e *Compatibility* (GLES3) | Vulkan/GLES | URP | não ideal |
| Paper-doll / skinning modular | nativo (`Skeleton3D`, `MeshInstance3D` compartilhando skeleton) | manual (Filament suporta skinning, resto é seu) | nativo | nativo |
| Pathfinding em grade | `AStarGrid2D` + `NavigationServer3D` | implementar (A\* ≈ 150 linhas) | NavMesh | NavMesh |
| Dados JSON + hot reload | `JSON`, `ResourceLoader`, `FileAccess` em `user://` | kotlinx.serialization | sim | sim |
| Scripting | GDScript (rápido de iterar) e C# | Kotlin | C# | C++/Blueprint |
| Esforço de engine | baixo | alto (UI, áudio, animação, input, cena — tudo manual) | baixo | médio |
| Risco | export Android maduro; comunidade grande | manutenção de motor próprio | mudanças de licença | peso |

**Decisão:** Godot 4 com renderer *Mobile*, GDScript para gameplay, C# opcional para a
simulação se quiser compartilhar código com ferramentas. Se o requisito "nativo" for
interpretado estritamente como "escrito em Kotlin/C++ com o Android SDK/NDK", a alternativa
é **Kotlin + Filament** (motor de render do Google) com a mesma arquitetura de dados abaixo —
o núcleo de simulação proposto é independente da engine justamente para permitir essa troca.

## 2. Visão em camadas

```
┌──────────────────────────────────────────────────────────────┐
│  Apresentação (Godot)                                        │
│  Cenas 3D · câmera 3/4 · UI toque · partículas · áudio       │
├──────────────────────────────────────────────────────────────┤
│  Gameplay (GDScript/C#)                                      │
│  Interações · menus sociais · quests runtime · minigames      │
├──────────────────────────────────────────────────────────────┤
│  Núcleo de simulação (puro, sem nós da engine, testável)     │
│  TimeSystem · StatSystem · RelationshipSystem · Economy      │
│  ScheduleSystem · QuestMachine · RuleInterpreter             │
├──────────────────────────────────────────────────────────────┤
│  Conteúdo (JSON + GLB + OGG) carregado por ContentRegistry   │
│  base pack (res://content) + mods (user://mods/*)            │
└──────────────────────────────────────────────────────────────┘
```

Regra de ouro: **nada no núcleo de simulação referencia nós de cena**. Ele recebe eventos
(`interact(objectId, actionId)`, `tick(minutes)`) e emite eventos (`statChanged`,
`questStageEntered`, `dialogueRequested`). Isso permite testar 100 % da lógica em testes
unitários de linha de comando e trocar a engine de render.

## 3. Estrutura de projeto proposta

```
miami3d/
  project.godot
  core/                     # núcleo de simulação (sem dependência de cena)
    time_system.gd
    stat_system.gd
    relationship_system.gd
    economy_system.gd
    schedule_system.gd
    quest_machine.gd
    rule_interpreter.gd     # avalia condições/ações declarativas (06 §4)
    save_system.gd
    content_registry.gd     # carrega e valida JSON; resolve ids; mods
  game/
    world/                  # Location.tscn, GridMap de células, portais, zonas
    actors/                 # Player.tscn, Npc.tscn, Pet.tscn (paper-doll 3D)
    objects/                # InteractableObject.tscn + ações
    ui/                     # HUD, menu radial, diálogo, agenda/telefone, lojas, mapa
    minigames/              # dança, foto, cartazes
    camera/                 # câmera 3/4 com rotação por 90° e zoom
  content/                  # pacote base (ver 06)
    locations/ npcs/ items/ interactions/ quests/ dialogue/ strings/
  assets/
    models/ (GLB)  animations/  textures/  audio/  ui/
  mods/                     # exemplo de pack de conteúdo externo
  tests/                    # testes do núcleo (gdUnit4 ou GUT)
  tools/                    # validação de JSON (schemas/), importadores
```

## 4. Mapeamento 2D → 3D

| Original | Remake 3D |
|---|---|
| Célula iso 24×12 px | 1 unidade de mundo (1 m). `gx → x`, `gy → z`, `y` = altura |
| Projeção 2:1 | Câmera com `rotation = (-35°, 45°, 0)`, ortográfica (`size ≈ 14`) ou perspectiva FOV 30°. Rotação em passos de 90° (4 vistas) |
| Ponto fixo `<<4` | float; velocidade 3 u/s andando, 6 correndo |
| Flags de célula | `GridMap` lógico (`PackedByteArray w×h`) + `NavigationRegion3D` gerado a partir dele |
| Registros `object` (tipo 1/2) | `InteractableObject` com `footprint`, `anchorCell`, `useCell`, `facing`, `actions[]` |
| `decor_template` (≥ 400) | props GLB instanciados por `MultiMeshInstance3D` |
| Portais (flag 4 / `door_cell`) | `Area3D` → `SceneTransition(locationId, spawnPoint)` |
| Zonas 16/8/64/128 | `Area3D` com `tag` (interior, sombra, praia, pista) |
| Paletas por hora | `WorldEnvironment` + `DirectionalLight3D` animados por curva de 24 h |
| ASprite 237 anims | `AnimationLibrary` ~40 clipes + `AnimationTree` (BlendSpace2D direção) |
| Paper-doll (slots) | 1 `Skeleton3D`; 5 `MeshInstance3D` filhos (head, hair, top, bottom, shoes) trocados em runtime; cor via `ShaderMaterial` com parâmetro `albedo_tint` |
| Fonte bitmap | `Label` com fonte TTF + `RichTextLabel` (tags `\p2` → BBCode `[color]`) |
| Teclado 0–9 | toque: *tap-to-move*, *tap* no objeto/NPC → menu radial, *long press* correr, dois dedos → girar/zoom câmera |
| HUD 320×240 | UI responsiva, *safe area*, escala por DPI |

### Câmera

Câmera 3/4 fixa em 4 orientações (como *The Sims* mobile) evita problemas de oclusão e mantém
a leitura das grades. Paredes voltadas para a câmera são **cortadas** (*cutaway*) via
material com `cull` por normal ou *shader* de altura — reproduz a sensação do mapa iso.

### Iluminação e desempenho (Android)

* Renderer Mobile (Vulkan) com *fallback* Compatibility (GLES 3.0) para devices antigos.
* Sombras: apenas 1 luz direcional com sombra, 1 cascata; luzes de ponto sem sombra.
* Orçamento: ≤ 150 k triângulos por cena, ≤ 60 *draw calls* após `MultiMesh`, texturas
  1024² ASTC/ETC2, atlas por kit de local.
* LOD para NPCs genéricos (o estádio tem 67 NPCs): malha low-poly + animação a 15 fps
  fora da área focal.
* Carregamento de local em *thread* (`ResourceLoader.load_threaded_request`) com tela de
  "Carregando…" curta (o original também tinha).

## 5. Núcleo de simulação — interfaces

```gdscript
# core/time_system.gd
signal minute_tick(minute_of_day: int, day: int)
signal hour_tick(hour: int, day: int)
signal day_tick(day: int)
var scale_seconds_per_minute := 1.0      # 1 s real = 1 min de jogo
func advance_minutes(n: int) -> void     # dormir, trabalho, cirurgia
func is_open(location: LocationDef, minute_of_day: int) -> bool

# core/stat_system.gd
var values: PackedInt32Array             # 16 stats, 0..100
func apply(effects: Array[StatEffect])   # {stat, delta} vindos de JSON
func level(stat: int) -> int             # 0..4 pelos limiares do JSON
func on_hour_tick()                      # taxas naturais do JSON

# core/relationship_system.gd
class NpcState: friendship, romance, mood, flags, last_contact, interactions_today, ...
func interact(npc_id, action_id) -> InteractionResult
func on_hour_tick()                      # decaimentos

# core/quest_machine.gd
func start(quest_id)
func set_stage(quest_id, stage_id)
func notify(event: GameEvent)            # "talked_to", "used_object", "entered", "stat_changed", "time"
# cada stage tem objectives (condições) e transitions (condição → próximo stage + ações)

# core/rule_interpreter.gd
func eval(cond: Dictionary, ctx: Context) -> bool
func run(actions: Array, ctx: Context) -> void
```

Todos os sistemas são `RefCounted`/classes puras, instanciados por um único `Game`
*autoload* que também é o barramento de eventos.

## 6. Save

Substituir o blob RMS por **JSON versionado** em `user://saves/slot_N.json`:

```json
{ "version": 1, "time": {"day": 3, "minute": 540}, "player": {"name": "...", "appearance": [1,0,4,2,7,1,3,5,2,0], "money": 320, "bank": 1000, "location": "south_beach", "cell": [40,22]},
  "stats": {"hunger": 30, "...": 0}, "npcs": {"goldsax": {"friendship": 45, "romance": 0, "mood": 60, "flags": ["known","phone"]}},
  "quests": {"q002_um_bico": {"stage": "deliver", "vars": {"cigars": true}}},
  "inventory": {"flowers": 2}, "home": {"tier": "low", "slots": {"sofa": "sofa_curved_blue"}},
  "flags": {"gnome_3": true}, "schedule": [{"npc": "heather", "location": "lounge", "day": 4, "minute": 1200}] }
```

Migrações por `version`. Opcional: importador do save RMS original (layout em `02` §7) para
testes de paridade.

## 7. Entrada e UX mobile

* *Tap-to-move* com indicador no chão; *tap* em objeto → menu radial com ações
  (ícone + custo + efeito previsto em stats, como dica).
* HUD: 4 necessidades em barras curtas + relógio + dinheiro; botão de agenda/telefone;
  botão de mapa.
* Diálogo social em painel inferior com as 4 abas (CONVERSAR/OFERECER/FLERTAR/OFENDER).
* Minigame de dança: *swipe* nas 4 direções no ritmo.
* Acessibilidade: textos escaláveis, modo daltônico para cores de stat.

## 8. Build Android

* Godot: *Export template* Android, `min SDK 24`, `target SDK` atual, ARM64 (+ ARMv7
  opcional), AAB para Play Store, assinatura por *keystore* de release.
* Permissões: nenhuma além de armazenamento interno (saves em `user://`).
* CI: GitHub Actions com `godot --headless --export-release Android` + testes do núcleo.
* Mods: pasta `Android/data/<pkg>/files/mods/` (acessível via *Storage Access Framework*)
  ou *download* de packs `.zip` validados pelo `ContentRegistry`.

## 9. Riscos e mitigação

| Risco | Mitigação |
|---|---|
| Volume de arte 3D (≈250 props, 100 peças de roupa, 30 presets) | kits reaproveitáveis, *kitbash*, pipeline Blender → GLB com convenções fixas; paper-doll reduz custo de personagens |
| Fidelidade das regras numéricas | núcleo testável + tabela de constantes em JSON; comparar com o original jogando lado a lado |
| Desempenho em low-end | renderer Compatibility, LOD, *baked lighting* onde possível |
| Direitos autorais | nenhuma arte/texto/áudio da Gameloft no projeto; nomes de locais reais de Miami são livres, nomes de personagens/marcas fictícias devem ser recriados |
