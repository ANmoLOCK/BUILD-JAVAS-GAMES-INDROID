class_name MnWorldState
extends RefCounted
## Local atual, célula, flags globais, mapa desbloqueado.

var events: MnEvents
var location_id: String = ""
var spawn_id: String = ""
var cell: Vector2i = Vector2i.ZERO
## Célula global (WorldStreamer). Opcional — saves antigos ignoram.
var global_cell: Vector2i = Vector2i.ZERO
var facing: String = "S"
var flags: Dictionary = {} # String -> bool
var unlocked_locations: Dictionary = {} # id -> true
var achievements: Dictionary = {}


func setup(ev: MnEvents) -> void:
	events = ev


func set_flag(flag: String, value: bool = true) -> void:
	flags[flag] = value
	if events:
		events.flag_changed.emit(flag, value)


func clear_flag(flag: String) -> void:
	set_flag(flag, false)


func has_flag(flag: String) -> bool:
	return bool(flags.get(flag, false))


func unlock_location(id: String) -> void:
	unlocked_locations[id] = true
	if events:
		events.unlock_location.emit(id)


func lock_location(id: String) -> void:
	unlocked_locations.erase(id)
	if events:
		events.lock_location.emit(id)


func is_unlocked(id: String) -> bool:
	## Default fechado — MnGame.apply_phase_unlocks() libera os da fase.
	if unlocked_locations.is_empty():
		return false
	return bool(unlocked_locations.get(id, false))


func set_location(id: String, spawn: String = "", c: Vector2i = Vector2i.ZERO) -> void:
	location_id = id
	spawn_id = spawn
	if c != Vector2i.ZERO:
		cell = c
	if events:
		events.location_changed.emit(id)


func unlock_achievement(id: String) -> void:
	if achievements.get(id, false):
		return
	achievements[id] = true
	if events:
		events.achievement_unlocked.emit(id)


func to_dict() -> Dictionary:
	return {
		"location": location_id,
		"spawn": spawn_id,
		"cell": [cell.x, cell.y],
		"global_cell": [global_cell.x, global_cell.y],
		"facing": facing,
		"flags": flags.duplicate(),
		"unlocked": unlocked_locations.keys(),
		"achievements": achievements.keys(),
	}


func from_dict(d: Dictionary) -> void:
	location_id = str(d.get("location", ""))
	spawn_id = str(d.get("spawn", ""))
	var ca: Array = d.get("cell", [0, 0])
	cell = Vector2i(int(ca[0]), int(ca[1]) if ca.size() > 1 else 0)
	var ga: Array = d.get("global_cell", [0, 0])
	global_cell = Vector2i(int(ga[0]), int(ga[1]) if ga.size() > 1 else 0)
	facing = str(d.get("facing", "S"))
	flags = d.get("flags", {}).duplicate()
	unlocked_locations.clear()
	for u in d.get("unlocked", []):
		unlocked_locations[str(u)] = true
	achievements.clear()
	for a in d.get("achievements", []):
		achievements[str(a)] = true
