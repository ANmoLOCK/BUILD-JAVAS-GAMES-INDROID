class_name MnContentRegistry
extends RefCounted
## Carrega o pack JSON completo (inventário 04 / pipeline 06).

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
var achievements: Dictionary = {}
var regions: Dictionary = {}
var gifts: Dictionary = {}
var surgery: Dictionary = {}
var rent: Dictionary = {}
var phases: Dictionary = {}


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
	achievements = _read_dict(content_dir.path_join("achievements.json"))
	regions = _read_dict(content_dir.path_join("regions.json"))
	gifts = _read_dict(content_dir.path_join("gifts.json"))
	surgery = _read_dict(content_dir.path_join("surgery.json"))
	rent = _read_dict(content_dir.path_join("rent.json"))
	phases = _read_dict(content_dir.path_join("phases.json"))
	# aliases de missão: não poluem o registry de stages
	if quests.has("quest_aliases"):
		quests.erase("quest_aliases")
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


func get_job(id: String) -> Dictionary:
	return jobs.get(id, {})


func get_gift(id: String) -> Dictionary:
	for g in gifts.get("items", []):
		if str(g.get("id", "")) == id:
			return g
	return {}


func get_achievement(id: String) -> Dictionary:
	for a in achievements.get("items", []):
		if str(a.get("id", "")) == id:
			return a
	return {}


func region_of(location_id: String) -> String:
	for r in regions.get("regions", []):
		var locs: Array = r.get("locations", [])
		if location_id in locs:
			return str(r.get("id", ""))
	var loc: Dictionary = get_location(location_id)
	return str(loc.get("region", ""))


func summary() -> Dictionary:
	return {
		"pack": pack.get("id", ""),
		"version": pack.get("version", ""),
		"locations": locations.size(),
		"npcs": npcs.size(),
		"items": items.size(),
		"interactions": interactions.size(),
		"quests": quests.size(),
		"jobs": jobs.size(),
		"schedules": schedules.size(),
		"achievements": achievements.get("items", []).size() if achievements else 0,
		"gifts": gifts.get("items", []).size() if gifts else 0,
		"topic_categories": dialogue_topics.get("categories", []).size() if dialogue_topics else 0,
		"interests": int(dialogue_topics.get("interestCount", 0)) if dialogue_topics else 0,
		"strings": strings.size(),
		"phase_default": phases.get("default_phase", "a") if phases else "a",
		"phase_count": phases.get("order", []).size() if phases else 0,
	}


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
