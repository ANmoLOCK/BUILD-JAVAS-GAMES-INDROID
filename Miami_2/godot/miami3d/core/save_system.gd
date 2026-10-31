class_name MnSaveSystem
extends RefCounted
## Save JSON versionado em user://saves/.

const VERSION := 1
var save_dir: String = "user://saves"


func setup(dir: String = "user://saves") -> void:
	save_dir = dir
	DirAccess.make_dir_recursive_absolute(save_dir)


func path_for(slot: int) -> String:
	return save_dir.path_join("slot_%d.json" % slot)


func save_game(game, slot: int = 0) -> Error:
	var data := {
		"version": VERSION,
		"phase": game.phases.current if game.get("phases") else "a",
		"time": game.time.to_dict(),
		"player": game.appearance.to_dict(),
		"stats": game.stats.to_dict(),
		"economy": game.economy.to_dict(),
		"inventory": game.inventory.to_dict(),
		"npcs": game.relationships.to_dict(),
		"quests": game.quests.to_dict(),
		"world": game.world.to_dict(),
		"home": game.home.to_dict(),
		"pets": game.pets.to_dict(),
		"jobs": game.jobs.to_dict(),
		"dating": game.dating.to_dict(),
		"crime": game.crime.to_dict(),
	}
	var path := path_for(slot)
	var f := FileAccess.open(path, FileAccess.WRITE)
	if f == null:
		return ERR_CANT_CREATE
	f.store_string(JSON.stringify(data, "\t"))
	return OK


func load_game(game, slot: int = 0) -> Error:
	var path := path_for(slot)
	if not FileAccess.file_exists(path):
		return ERR_FILE_NOT_FOUND
	var f := FileAccess.open(path, FileAccess.READ)
	var data = JSON.parse_string(f.get_as_text())
	if typeof(data) != TYPE_DICTIONARY:
		return ERR_INVALID_DATA
	_migrate(data)
	if game.get("phases") and data.has("phase"):
		game.phases.set_phase(str(data.get("phase", "a")))
	game.time.from_dict(data.get("time", {}))
	game.appearance.from_dict(data.get("player", {}))
	game.strings.player_name = game.appearance.player_name
	game.strings.player_gender = game.appearance.gender
	game.stats.from_dict(data.get("stats", {}))
	game.economy.from_dict(data.get("economy", {}))
	game.inventory.from_dict(data.get("inventory", {}))
	game.relationships.from_dict(data.get("npcs", {}))
	game.quests.from_dict(data.get("quests", {}))
	game.world.from_dict(data.get("world", {}))
	game.home.from_dict(data.get("home", {}))
	game.pets.from_dict(data.get("pets", {}))
	game.jobs.from_dict(data.get("jobs", {}))
	game.dating.from_dict(data.get("dating", {}))
	game.crime.from_dict(data.get("crime", {}))
	# saves antigos sem unlocked → reaplica fase
	if game.world.unlocked_locations.is_empty() and game.get("phases"):
		game.apply_phase_unlocks()
	return OK


func _migrate(data: Dictionary) -> void:
	var v := int(data.get("version", 0))
	# futuras migrações: while v < VERSION: ...
	data["version"] = VERSION
	if v < 1:
		pass
