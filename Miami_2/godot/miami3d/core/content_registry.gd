class_name MnContentRegistry
extends RefCounted
## Carrega o pack JSON (locations, npcs, items, interactions, quests, strings, stats).

var content_dir: String = "res://content"
var pack: Dictionary = {}
var stats: Dictionary = {}
var strings: Dictionary = {}
var locations: Dictionary = {}
var npcs: Dictionary = {}
var items: Dictionary = {}
var interactions: Dictionary = {}
var quests: Dictionary = {}
var jobs: Dictionary = {}
var schedules: Dictionary = {}
var dialogue_topics: Dictionary = {}
var dialogue_reactions: Dictionary = {}


func load_pack(dir: String = "") -> Error:
	if dir != "":
		content_dir = dir
	pack = _read_dict(content_dir.path_join("pack.json"))
	stats = _read_dict(content_dir.path_join("stats.json"))
	var locale := str(pack.get("locale", "pt-BR"))
	strings = _read_dict(content_dir.path_join("strings/%s.json" % locale))
	_load_folder("locations", locations)
	_load_folder("npcs", npcs)
	_load_folder("items", items)
	_load_folder("interactions", interactions)
	_load_folder("quests", quests)
	_load_folder("jobs", jobs)
	_load_folder("schedules", schedules)
	var topics_path := content_dir.path_join("dialogue/topics.json")
	if FileAccess.file_exists(topics_path):
		dialogue_topics = _read_dict(topics_path)
	var react_path := content_dir.path_join("dialogue/reactions.json")
	if FileAccess.file_exists(react_path):
		dialogue_reactions = _read_dict(react_path)
	return OK


func get_interaction(id: String) -> Dictionary:
	return interactions.get(id, {})


func get_item(id: String) -> Dictionary:
	return items.get(id, {})


func get_location(id: String) -> Dictionary:
	return locations.get(id, {})


func get_npc(id: String) -> Dictionary:
	return npcs.get(id, {})


func get_quest(id: String) -> Dictionary:
	return quests.get(id, {})


func _load_folder(folder: String, into: Dictionary) -> void:
	var path := content_dir.path_join(folder)
	var dir := DirAccess.open(path)
	if dir == null:
		return
	dir.list_dir_begin()
	var fn := dir.get_next()
	while fn != "":
		if not dir.current_is_dir() and fn.ends_with(".json"):
			var data = _read_any(path.path_join(fn))
			if typeof(data) == TYPE_DICTIONARY and data.has("id"):
				into[str(data["id"])] = data
			elif typeof(data) == TYPE_ARRAY:
				for d in data:
					if typeof(d) == TYPE_DICTIONARY and d.has("id"):
						into[str(d["id"])] = d
		fn = dir.get_next()
	dir.list_dir_end()


func _read_dict(path: String) -> Dictionary:
	var data = _read_any(path)
	return data if typeof(data) == TYPE_DICTIONARY else {}


func _read_any(path: String):
	if not FileAccess.file_exists(path):
		return {}
	var f := FileAccess.open(path, FileAccess.READ)
	if f == null:
		return {}
	var data = JSON.parse_string(f.get_as_text())
	return data if data != null else {}
