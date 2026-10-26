class_name MnPhaseCatalog
extends RefCounted
## Catálogo de fases A–G: locais cumulativos + sistemas com fase mínima.
## Fonte: content/phases.json (alinhado ao plano progressivo §3).

const ORDER_DEFAULT := ["a", "b", "c", "d", "e", "f", "g"]

var doc: Dictionary = {}
var current: String = "a"
var aliases: Dictionary = {}
var _order: Array = []
var _index: Dictionary = {} # phase_id -> int


func load_from(path: String = "res://content/phases.json") -> Error:
	if not FileAccess.file_exists(path):
		push_warning("phases.json ausente: " + path)
		_boot_fallback()
		return ERR_FILE_NOT_FOUND
	var f := FileAccess.open(path, FileAccess.READ)
	if f == null:
		_boot_fallback()
		return ERR_CANT_OPEN
	var data = JSON.parse_string(f.get_as_text())
	if typeof(data) != TYPE_DICTIONARY:
		_boot_fallback()
		return ERR_PARSE_ERROR
	doc = data
	aliases = doc.get("aliases", {}).duplicate()
	_order = doc.get("order", ORDER_DEFAULT).duplicate()
	_rebuild_index()
	current = str(doc.get("default_phase", "a")).to_lower()
	return OK


func load_dict(data: Dictionary) -> void:
	doc = data.duplicate(true)
	aliases = doc.get("aliases", {}).duplicate()
	_order = doc.get("order", ORDER_DEFAULT).duplicate()
	_rebuild_index()
	current = str(doc.get("default_phase", "a")).to_lower()


func _boot_fallback() -> void:
	doc = {
		"default_phase": "a",
		"order": ORDER_DEFAULT,
		"phases": {
			"a": {
				"locations": ["player_apartment", "apartment_garden", "first_street"],
				"systems": ["time", "needs4", "collapse"],
			}
		},
		"systems": {},
		"aliases": {},
	}
	aliases = {}
	_order = ORDER_DEFAULT.duplicate()
	_rebuild_index()
	current = "a"


func _rebuild_index() -> void:
	_index.clear()
	for i in _order.size():
		_index[str(_order[i]).to_lower()] = i


func set_phase(phase_id: String) -> bool:
	var p := _canon(phase_id)
	if not _index.has(p):
		return false
	current = p
	return true


func phase_index(phase_id: String = "") -> int:
	var p := current if phase_id == "" else _canon(phase_id)
	return int(_index.get(p, -1))


func meets(min_phase: String) -> bool:
	var need := phase_index(min_phase)
	if need < 0:
		return true
	return phase_index(current) >= need


func system_unlocked(system_id: String) -> bool:
	var systems: Dictionary = doc.get("systems", {})
	if not systems.has(system_id):
		# sistema desconhecido: liberado a partir de A
		return true
	var min_p := str(systems[system_id].get("min_phase", "a"))
	return meets(min_p)


func system_min_phase(system_id: String) -> String:
	var systems: Dictionary = doc.get("systems", {})
	if not systems.has(system_id):
		return "a"
	return str(systems[system_id].get("min_phase", "a"))


func resolve_location_id(location_id: String) -> String:
	var id := location_id
	if aliases.has(id):
		id = str(aliases[id])
	return id


func phase_def(phase_id: String = "") -> Dictionary:
	var p := current if phase_id == "" else _canon(phase_id)
	return doc.get("phases", {}).get(p, {})


func locations_for_phase(phase_id: String, cumulative: bool = true) -> PackedStringArray:
	## Locais liberados ao atingir a fase (cumulativo A…fase).
	var out: PackedStringArray = []
	var seen: Dictionary = {}
	var target := phase_index(phase_id)
	if target < 0:
		return out
	for i in _order.size():
		if i > target:
			break
		var pid := str(_order[i])
		var locs: Array = phase_def(pid).get("locations", [])
		for loc in locs:
			var lid := resolve_location_id(str(loc))
			if seen.has(lid):
				continue
			seen[lid] = true
			out.append(lid)
		if not cumulative and i == target:
			break
	return out


func unlocked_locations() -> PackedStringArray:
	return locations_for_phase(current, true)


func systems_for_phase(phase_id: String = "") -> PackedStringArray:
	## Sistemas ativos na fase pedida (todos com min_phase ≤ fase).
	var out: PackedStringArray = []
	var seen: Dictionary = {}
	var systems: Dictionary = doc.get("systems", {})
	var p := current if phase_id == "" else _canon(phase_id)
	var pidx := phase_index(p)
	for sid in systems.keys():
		var min_p := str(systems[sid].get("min_phase", "a"))
		if pidx >= phase_index(min_p):
			seen[str(sid)] = true
			out.append(str(sid))
	for i in _order.size():
		if i > pidx:
			break
		for s in phase_def(str(_order[i])).get("systems", []):
			var sid2 := str(s)
			if seen.has(sid2):
				continue
			seen[sid2] = true
			out.append(sid2)
	return out


func is_location_in_phase(location_id: String, phase_id: String = "") -> bool:
	var lid := resolve_location_id(location_id)
	var list := locations_for_phase(current if phase_id == "" else phase_id, true)
	return lid in list


func start_location() -> String:
	var def: Dictionary = phase_def(current)
	var start := str(def.get("start_location", ""))
	if start != "":
		return resolve_location_id(start)
	var locs := locations_for_phase(current, true)
	if locs.size() > 0:
		return locs[0]
	return "player_apartment"


func body_folder(phase_id: String = "") -> String:
	return str(phase_def(phase_id).get("body_folder", ""))


func order() -> Array:
	return _order.duplicate()


func summary() -> Dictionary:
	return {
		"current": current,
		"index": phase_index(),
		"locations": unlocked_locations(),
		"systems": systems_for_phase(),
		"phases": _order.duplicate(),
	}


func _canon(phase_id: String) -> String:
	return phase_id.strip_edges().to_lower()
