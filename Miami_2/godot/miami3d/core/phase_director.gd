class_name MnPhaseDirector
extends RefCounted
## Orquestra o "Pronto quando" de cada fase: bootstrap de New Game + auditoria.
## Dados em content/phases.json (bootstrap / checklist).

var mods := MnModLoader.new()


func bootstrap(game, phase_id: String = "") -> Dictionary:
	## Aplica unlocks + cash/quests/flags/local inicial da fase.
	if game == null or not game.get("phases"):
		return {"ok": false, "reason": "no_phases"}
	var pid := phase_id if phase_id != "" else str(game.phases.current)
	if not game.phases.set_phase(pid):
		return {"ok": false, "reason": "unknown_phase", "phase": pid}
	game.apply_phase_unlocks()
	var def: Dictionary = game.phases.phase_def(pid)
	var boot: Dictionary = def.get("bootstrap", {})
	_apply_economy(game, boot)
	_apply_time(game, boot)
	_apply_flags(game, boot)
	_apply_home(game, boot)
	_ensure_npcs(game, boot)
	_start_quests(game, boot)
	if bool(boot.get("load_mods", false)) and game.phases.system_unlocked("mods"):
		var mr: Dictionary = mods.load_all(game.content, game)
		boot = boot.duplicate()
		boot["mods"] = mr
	var start := str(boot.get("start_location", def.get("start_location", game.phases.start_location())))
	var spawn := str(boot.get("start_spawn", ""))
	if start != "":
		# força unlock do start (já deve estar na lista cumulativa)
		game.world.unlock_location(start)
		game.enter_location(start, spawn)
	var note := str(boot.get("notify", ""))
	if note != "" and game.events:
		game.events.notify.emit(note)
	var cut: Dictionary = boot.get("cutscene", {})
	if not cut.is_empty() and game.events:
		game.events.cutscene.emit(cut)
	return {
		"ok": true,
		"phase": pid,
		"location": game.world.location_id,
		"quests": boot.get("quests", []),
		"title": def.get("title", pid),
		"ready_when": def.get("ready_when", ""),
	}


func audit(game, phase_id: String = "") -> Dictionary:
	## Verifica checklist da fase (arquivos / content / sistemas).
	var pid := phase_id if phase_id != "" else str(game.phases.current)
	var def: Dictionary = game.phases.phase_def(pid)
	var items: Array = def.get("checklist", [])
	var passed: PackedStringArray = []
	var failed: PackedStringArray = []
	for raw in items:
		var key := str(raw)
		if _check_item(game, key):
			passed.append(key)
		else:
			failed.append(key)
	return {
		"phase": pid,
		"ok": failed.is_empty(),
		"passed": passed,
		"failed": failed,
		"ready_when": def.get("ready_when", ""),
		"pass_count": passed.size(),
		"fail_count": failed.size(),
	}


func audit_all(game) -> Dictionary:
	var report: Dictionary = {}
	var all_ok := true
	for p in game.phases.order():
		var a := audit(game, str(p))
		report[str(p)] = a
		if not bool(a.get("ok", false)):
			all_ok = false
	return {"ok": all_ok, "phases": report}


func _apply_economy(game, boot: Dictionary) -> void:
	if boot.has("cash"):
		game.economy.cash = int(boot["cash"])
	if boot.has("bank"):
		game.economy.bank = int(boot["bank"])
	if game.events:
		game.events.money_changed.emit(game.economy.cash, game.economy.bank)


func _apply_time(game, boot: Dictionary) -> void:
	if boot.has("minute_of_day"):
		game.time.minute_of_day = int(boot["minute_of_day"])
	if boot.has("day"):
		game.time.day = int(boot["day"])


func _apply_flags(game, boot: Dictionary) -> void:
	for f in boot.get("flags", []):
		game.world.set_flag(str(f), true)


func _apply_home(game, boot: Dictionary) -> void:
	if boot.has("home_tier") and game.get("home"):
		game.home.tier = int(boot["home_tier"])


func _ensure_npcs(game, boot: Dictionary) -> void:
	if not game.get("relationships"):
		return
	for nid in boot.get("ensure_npcs", []):
		game.relationships.ensure(str(nid), game.content.get_npc(str(nid)))


func _start_quests(game, boot: Dictionary) -> void:
	if not game.get("quests"):
		return
	for qid in boot.get("quests", []):
		var id := str(qid)
		if game.content.quests.has(id) or game.quests.defs.has(id):
			if not game.quests.is_active(id):
				game.quests.start(id)


func _check_item(game, key: String) -> bool:
	var parts := key.split(":", false, 1)
	if parts.size() < 2:
		return false
	var kind := parts[0]
	var id := parts[1]
	match kind:
		"core":
			return _has_script("res://core/%s.gd" % id) or _has_class_hint(id)
		"location":
			return game.content.locations.has(id)
		"npc":
			return game.content.npcs.has(id)
		"quest":
			return game.content.quests.has(id) or game.quests.defs.has(id)
		"job":
			return game.content.jobs.has(id)
		"ui":
			if ResourceLoader.exists("res://game/ui/%s.tscn" % id) \
				or ResourceLoader.exists("res://game/ui/%s.gd" % id):
				return true
			# aliases curtos
			var aliases := {"radial": "radial_menu", "creator": "character_creator", "atm": "bank_atm"}
			if aliases.has(id):
				var a := str(aliases[id])
				return ResourceLoader.exists("res://game/ui/%s.tscn" % a) \
					or ResourceLoader.exists("res://game/ui/%s.gd" % a)
			return false
		"actor":
			return ResourceLoader.exists("res://game/actors/%s.tscn" % id) \
				or ResourceLoader.exists("res://game/actors/%s.gd" % id)
		"minigame":
			return ResourceLoader.exists("res://game/minigames/%s.tscn" % id)
		"test":
			return ResourceLoader.exists("res://tests/%s.gd" % id)
		"action":
			return game.content.interactions.has(id)
		"content":
			return _check_content_metric(game, id)
		"doc":
			if id == "CRIADORES":
				return FileAccess.file_exists("res://game/phases/g_mods/CRIADORES.md") \
					or FileAccess.file_exists("res://CRIADORES.md")
			return FileAccess.file_exists("res://%s.md" % id)
		"mod":
			if id == "example":
				return FileAccess.file_exists("res://mods/example_pack/pack.json")
			return false
		_:
			return false


func _check_content_metric(game, id: String) -> bool:
	match id:
		"surgery":
			return not game.content.surgery.is_empty()
		"gifts":
			return not game.content.gifts.is_empty()
		"achievements":
			return game.content.achievements.get("items", []).size() >= 19 \
				if typeof(game.content.achievements.get("items", null)) == TYPE_ARRAY \
				else game.content.achievements.size() >= 1
		"quests_99":
			return game.content.quests.size() >= 99
		"regions_9":
			return game.content.regions.get("regions", []).size() >= 9
		_:
			return false


func _has_script(path: String) -> bool:
	return FileAccess.file_exists(path) or ResourceLoader.exists(path)


func _has_class_hint(id: String) -> bool:
	## Mapeia checklist core:x_system → arquivo real.
	var map := {
		"time_system": "res://core/time_system.gd",
		"stat_system": "res://core/stat_system.gd",
		"appearance_system": "res://core/appearance_system.gd",
		"relationship_system": "res://core/relationship_system.gd",
		"dialogue_system": "res://core/dialogue_system.gd",
		"quest_machine": "res://core/quest_machine.gd",
		"economy_system": "res://core/economy_system.gd",
		"crime_system": "res://core/crime_system.gd",
		"job_system": "res://core/job_system.gd",
		"dating_system": "res://core/dating_system.gd",
		"home_system": "res://core/home_system.gd",
		"pet_system": "res://core/pet_system.gd",
		"mod_loader": "res://core/mod_loader.gd",
		"phase_director": "res://core/phase_director.gd",
		"phase_catalog": "res://core/phase_catalog.gd",
	}
	if map.has(id):
		return _has_script(str(map[id]))
	return _has_script("res://core/%s.gd" % id)
