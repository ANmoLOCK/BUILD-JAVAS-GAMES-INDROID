class_name BrainFacade
extends RefCounted
## Fachada única: prefere MnBrain (C++ GDExtension) e cai no MnGame (GDScript).

var backend
var is_native: bool = false
var ready: bool = false

# Compat: alguns scripts esperam .events / .time / .stats…
var events # só no GDScript MnGame
var time
var stats
var world
var economy
var content
var strings
var quests
var inventory
var relationships
var rules
var appearance
var dating
var crime
var home
var pets
var jobs
var saves
var rng
var assets: MnAssetRegistry


func boot(content_dir: String = "res://content", save_dir: String = "user://saves", assets_dir: String = "res://assets") -> Error:
	assets = MnAssetRegistry.new()
	assets.boot(assets_dir)
	if ClassDB.class_exists("MnBrain"):
		backend = ClassDB.instantiate("MnBrain")
		is_native = true
		var err: Error = backend.boot(content_dir, save_dir)
		ready = backend.is_ready()
		print("[BrainFacade] usando C++ MnBrain")
		_log_assets()
		return err
	backend = MnGame.new()
	is_native = false
	var err2: Error = backend.boot(content_dir, save_dir)
	ready = backend.ready
	events = backend.events
	time = backend.time
	stats = backend.stats
	world = backend.world
	economy = backend.economy
	content = backend.content
	strings = backend.strings
	quests = backend.quests
	inventory = backend.inventory
	relationships = backend.relationships
	rules = backend.rules
	appearance = backend.appearance
	dating = backend.dating
	crime = backend.crime
	home = backend.home
	pets = backend.pets
	jobs = backend.jobs
	saves = backend.saves
	rng = backend.rng
	print("[BrainFacade] usando GDScript MnGame (compile native/ para C++)")
	_log_assets()
	return err2


func _log_assets() -> void:
	if assets == null:
		return
	var c: Dictionary = assets.summary()
	if c.is_empty():
		return
	print("[BrainFacade] assets v%s — furniture=%s props=%s kits=%s clips=%s" % [
		assets.root_manifest.get("version", "?"),
		c.get("furniture", 0), c.get("props", 0), c.get("kits", 0), c.get("anim_clips", 0),
	])


func new_game(player_name: String = "Você", gender: String = "m") -> void:
	backend.new_game(player_name, gender)


func tick_real(delta_s: float) -> void:
	backend.tick_real(delta_s)


func enter_location(location_id: String, spawn_id: String = "") -> void:
	backend.enter_location(location_id, spawn_id)


func interact(object_id: String, action_id: String) -> Dictionary:
	return backend.interact(object_id, action_id)


func talk(npc_id: String, action_id: String, payload: Dictionary = {}) -> Dictionary:
	return backend.talk(npc_id, action_id, payload)


func leave_location() -> Dictionary:
	return _cmd("leave_location", [])


func use_phone(action: String, payload: Dictionary = {}) -> Dictionary:
	return _cmd("use_phone", [action, payload])


func buy(item_id: String) -> Dictionary:
	return _cmd("buy", [item_id])


func equip(item_id: String = "", payload: Dictionary = {}) -> Dictionary:
	return _cmd("equip", [item_id, payload])


func place_furniture(slot_id: String, item_id: String) -> Dictionary:
	return _cmd("place_furniture", [slot_id, item_id])


func start_minigame_result(minigame_id: String, won: bool, score: int = 0) -> Dictionary:
	return _cmd("start_minigame_result", [minigame_id, won, score])


func advance_time_request(minutes: int) -> Dictionary:
	return _cmd("advance_time_request", [minutes])


func _cmd(method: String, args: Array) -> Dictionary:
	## Encaminha comando corpo→cérebro (C++ ou GDScript).
	if backend == null:
		return {"ok": false, "reason": "no_backend"}
	if not backend.has_method(method):
		return {"ok": false, "reason": "unsupported", "method": method}
	return backend.callv(method, args)


func resolve_text(key: String, ctx: Dictionary = {}) -> String:
	return backend.resolve_text(key, ctx)


func save_game(slot: int = 0) -> Error:
	return backend.save_game(slot) if is_native else backend.saves.save_game(backend, slot)


func load_game(slot: int = 0) -> Error:
	return backend.load_game(slot) if is_native else backend.saves.load_game(backend, slot)


func connect_signal(sig: String, callable: Callable) -> void:
	if is_native:
		backend.connect(sig, callable)
	else:
		backend.events.connect(sig, callable)


# --- getters unificados (HUD / UI) ---

func get_stat(stat_id: String) -> int:
	return backend.get_stat(stat_id) if is_native else backend.stats.get_value(stat_id)


func get_cash() -> int:
	return backend.get_cash() if is_native else backend.economy.cash


func get_day() -> int:
	return backend.get_day() if is_native else backend.time.day


func get_hour() -> int:
	return backend.get_hour() if is_native else backend.time.hour()


func get_minute_of_day() -> int:
	return backend.get_minute_of_day() if is_native else backend.time.minute_of_day


func get_location() -> String:
	return backend.get_location() if is_native else backend.world.location_id


func get_cell() -> Vector2i:
	return backend.get_cell() if is_native else backend.world.cell


func snapshot() -> Dictionary:
	if is_native:
		return backend.snapshot()
	return {
		"day": backend.time.day,
		"minute": backend.time.minute_of_day,
		"location": backend.world.location_id,
		"cash": backend.economy.cash,
		"bank": backend.economy.bank,
		"stats": backend.stats.to_dict(),
		"quests": backend.quests.to_dict() if backend.quests.has_method("to_dict") else {},
		"appearance": backend.appearance.vector.duplicate(),
	}


func get_content_location(id: String) -> Dictionary:
	if is_native:
		# MnBrain não expõe content registry; lê via snapshot/path — use GDScript content se preciso
		# Fallback: carregar do ContentRegistry auxiliar
		if content == null:
			content = MnContentRegistry.new()
			content.load_pack("res://content")
		return content.get_location(id)
	return backend.content.get_location(id)


func get_content_item(id: String) -> Dictionary:
	if content == null and is_native:
		content = MnContentRegistry.new()
		content.load_pack("res://content")
	if is_native:
		return content.get_item(id)
	return backend.content.get_item(id)


func get_content_interaction(id: String) -> Dictionary:
	_ensure_content()
	if is_native:
		return content.get_interaction(id)
	return backend.content.get_interaction(id)


func get_content_npc(id: String) -> Dictionary:
	_ensure_content()
	if is_native:
		return content.get_npc(id)
	return backend.content.get_npc(id)


func get_all_locations() -> Dictionary:
	_ensure_content()
	return content.locations if is_native else backend.content.locations


func get_regions() -> Dictionary:
	_ensure_content()
	return content.regions


func get_content_summary() -> Dictionary:
	_ensure_content()
	if content.has_method("summary"):
		return content.summary()
	return {}


func _ensure_content() -> void:
	if content != null:
		return
	if is_native:
		content = MnContentRegistry.new()
		content.load_pack("res://content")
	else:
		content = backend.content
