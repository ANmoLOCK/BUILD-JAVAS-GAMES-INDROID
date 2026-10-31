class_name MnModLoader
extends RefCounted
## Fase G: carrega packs de user://mods/<pack>/ (e opcional res://mods/).
## Cada pack precisa de pack.json { id, version, dependencies?, priority? }.

const USER_MODS := "user://mods"
const RES_MODS := "res://mods"

var loaded: Array[Dictionary] = [] # {id, path, version, error?}
var last_errors: PackedStringArray = []


func ensure_user_dir() -> void:
	DirAccess.make_dir_recursive_absolute(USER_MODS)


func discover() -> PackedStringArray:
	## Lista pastas de mod (user primeiro, depois res exemplo).
	var out: PackedStringArray = []
	_scan_root(USER_MODS, out)
	_scan_root(RES_MODS, out)
	return out


func _scan_root(root: String, out: PackedStringArray) -> void:
	var d := DirAccess.open(root)
	if d == null:
		return
	d.list_dir_begin()
	var name := d.get_next()
	while name != "":
		if d.current_is_dir() and not name.begins_with("."):
			var pack_path := root.path_join(name)
			if FileAccess.file_exists(pack_path.path_join("pack.json")):
				out.append(pack_path)
		name = d.get_next()
	d.list_dir_end()


func load_all(content: MnContentRegistry, game = null) -> Dictionary:
	## Merge de todos os packs descobertos (ordenados por priority).
	ensure_user_dir()
	loaded.clear()
	last_errors.clear()
	var paths := discover()
	var packs: Array[Dictionary] = []
	for p in paths:
		var meta := _read_pack_meta(p)
		meta["path"] = p
		packs.append(meta)
	packs.sort_custom(func(a, b): return int(a.get("priority", 0)) < int(b.get("priority", 0)))
	var ok_n := 0
	for meta in packs:
		var err := apply_pack(content, str(meta["path"]), game)
		var entry := meta.duplicate()
		if err != OK:
			entry["error"] = error_string(err)
			last_errors.append("%s: %s" % [meta.get("id", meta["path"]), entry["error"]])
		else:
			ok_n += 1
		loaded.append(entry)
	return {"ok": last_errors.is_empty(), "loaded": ok_n, "total": packs.size(), "errors": last_errors}


func apply_pack(content: MnContentRegistry, pack_dir: String, game = null) -> Error:
	var meta := _read_pack_meta(pack_dir)
	if meta.is_empty() or str(meta.get("id", "")) == "":
		return ERR_INVALID_DATA
	# dependencies
	for dep in meta.get("dependencies", []):
		var found := false
		for L in loaded:
			if str(L.get("id", "")) == str(dep) and not L.has("error"):
				found = true
				break
		if str(dep) == str(content.pack.get("id", "base")):
			found = true
		if not found and str(dep) != "base":
			# base sempre implícito
			push_warning("mod %s: dependency missing %s" % [meta.get("id"), dep])
	if content.has_method("merge_pack"):
		var err: Error = content.merge_pack(pack_dir)
		if err != OK:
			return err
	else:
		return ERR_METHOD_NOT_FOUND
	# re-registrar quests/jobs se game disponível
	if game != null:
		_reregister(game, content)
	print("[MnModLoader] pack %s v%s de %s" % [meta.get("id"), meta.get("version", "?"), pack_dir])
	return OK


func _reregister(game, content: MnContentRegistry) -> void:
	if game.get("quests"):
		for qid in content.quests.keys():
			game.quests.register(content.quests[qid])
	if game.get("jobs"):
		for jid in content.jobs.keys():
			game.jobs.register(content.jobs[jid])
	if game.get("schedules"):
		for sid in content.schedules.keys():
			game.schedules.load_schedule(sid, content.schedules[sid])


func _read_pack_meta(pack_dir: String) -> Dictionary:
	var path := pack_dir.path_join("pack.json")
	if not FileAccess.file_exists(path):
		return {}
	var f := FileAccess.open(path, FileAccess.READ)
	if f == null:
		return {}
	var data = JSON.parse_string(f.get_as_text())
	return data if typeof(data) == TYPE_DICTIONARY else {}
