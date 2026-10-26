# Contrato de eventos — cérebro ↔ corpo

Todo o corpo Godot (`game/`) fala com o cérebro só por estes eventos.
Implementação: `MnGame` + `MnEvents` (`core/`), espelho em `BrainFacade`, reações em `MnEventBridge`.

## Entrada (corpo → cérebro)

| Comando | API | Quando |
|---|---|---|
| `tick_real(delta_s)` | `BrainFacade.tick_real` | Cada frame (`Bootstrap._process`) |
| `interact(object_id, action_id)` | `.interact` | Menu radial |
| `talk(npc_id, social_action_id, payload?)` | `.talk` | Menu social |
| `enter_location(location_id, spawn_id)` | `.enter_location` | Portal / mapa / teleporte |
| `leave_location()` | `.leave_location` | Antes de trocar de local |
| `use_phone(action, payload?)` | `.use_phone` | Agenda, ligar, ATM |
| `buy(item_id)` | `.buy` | Loja |
| `equip(item_id?, payload?)` | `.equip` | Closet / boutique |
| `place_furniture(slot, item)` | `.place_furniture` | Slot de móvel |
| `start_minigame_result(id, won, score)` | `.start_minigame_result` | Fim de dança/cartazes/foto |
| `advance_time_request(minutes)` | `.advance_time_request` | Dormir / trabalho / cirurgia |

### `use_phone` — ações

`stats` / `agenda` · `quests` · `call` · `deposit` · `withdraw` · `pay_rent` · `open_map` · `save`

## Saída (cérebro → corpo)

| Sinal (`MnEvents`) | Corpo (`MnEventBridge`) |
|---|---|
| `minute_tick` / `hour_tick` / `day_tick` | HUD + luz do sol |
| `stat_changed` / `warning` / `collapse` | Barras, toast ATENÇÃO, FX desmaio |
| `dialogue_requested` | `DialoguePanel` |
| `quest_stage_entered` / `quest_completed` | Toast MISSÃO + marcador no mapa |
| `spawn_npc` / `despawn_npc` / `move_npc` | `LocationController` |
| `teleport` / `unlock_location` | Troca cena / ícone mapa |
| `play_sound` / `play_music` / `cutscene` | Áudio / FX câmera |
| `notify` | Toast ATENÇÃO / DICA / MISSÃO |
| `save_hint` | Autosave slot 0 |
| `minigame_requested` | Instancia minigame e devolve resultado |

## Regra

- UI **não** mexe em `economy` / `inventory` / `home` direto — chama a fachada.
- Lógica de stats/missões fica no cérebro; o corpo só mostra e coleta input.
