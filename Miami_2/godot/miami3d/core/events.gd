class_name MnEvents
extends RefCounted
## Barramento de sinais do cérebro. O corpo (Godot) conecta aqui.

signal minute_tick(minute_of_day: int, day: int)
signal hour_tick(hour: int, day: int)
signal day_tick(day: int)

signal stat_changed(stat_id: String, value: int, level: int)
signal warning(stat_id: String, text_key: String)
signal collapse(stat_id: String, text_key: String)

signal dialogue_requested(payload: Dictionary)
signal notify(text_key: String)
signal quest_stage_entered(quest_id: String, stage_id: String)
signal quest_completed(quest_id: String)
signal quest_failed(quest_id: String)

signal spawn_npc(npc_id: String, cell: Vector2i, facing: String)
signal despawn_npc(npc_id: String)
signal move_npc(npc_id: String, cell: Vector2i, run: bool)

signal teleport(location_id: String, spawn_id: String)
signal unlock_location(location_id: String)
signal lock_location(location_id: String)

signal play_sound(sound_id: String)
signal play_music(music_id: String)
signal cutscene(payload: Dictionary)
signal minigame_requested(payload: Dictionary)
signal achievement_unlocked(achievement_id: String)

signal money_changed(cash: int, bank: int)
signal inventory_changed
signal flag_changed(flag: String, value: bool)
signal location_changed(location_id: String)
signal save_hint
