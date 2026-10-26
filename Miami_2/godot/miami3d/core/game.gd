class_name MnGame
extends RefCounted
## Orquestra o cérebro. Sem Node — o Bootstrap / corpo Godot chama tick e ações.

var events := MnEvents.new()
var rng := MnRng.new()
var content := MnContentRegistry.new()
var strings := MnStringTable.new()
var time := MnTimeSystem.new()
var stats := MnStatSystem.new()
var world := MnWorldState.new()
var inventory := MnInventorySystem.new()
var economy := MnEconomySystem.new()
var relationships := MnRelationshipSystem.new()
var schedules := MnScheduleSystem.new()
var appearance := MnAppearanceSystem.new()
var crime := MnCrimeSystem.new()
var home := MnHomeSystem.new()
var pets := MnPetSystem.new()
var jobs := MnJobSystem.new()
var dating := MnDatingSystem.new()
var dialogue := MnDialogueSystem.new()
var quests := MnQuestMachine.new()
var rules := MnRuleInterpreter.new()
var saves := MnSaveSystem.new()

var ready: bool = false
var _last_hour: int = -1


func boot(content_dir: String = "res://content", save_dir: String = "user://saves") -> Error:
	var err := content.load_pack(content_dir)
	if err != OK:
		return err
	strings.load_map(content.strings)
	time.setup(events, content.stats)
	world.setup(events)
	inventory.setup(events)
	economy.setup(events, content.stats, content.rent)
	relationships.setup(events)
	dating.setup(events)
	dialogue.setup(events, self)
	dialogue.load_topics(content.dialogue_topics)
	dialogue.load_reactions(content.dialogue_reactions)
	quests.setup(events, self)
	rules.setup(self, events)
	stats.setup(events, content.stats, self)
	crime.setup(events, content.stats, self)
	saves.setup(save_dir)

	for qid in content.quests.keys():
		quests.register(content.quests[qid])
	for jid in content.jobs.keys():
		jobs.register(content.jobs[jid])
	for sid in content.schedules.keys():
		schedules.load_schedule(sid, content.schedules[sid])
	for nid in content.npcs.keys():
		var ndef: Dictionary = content.npcs[nid]
		relationships.ensure(nid, ndef)
		if ndef.has("schedule"):
			schedules.bind_npc(nid, str(ndef["schedule"]))

	# sinais internos
	events.hour_tick.connect(_on_hour)
	events.day_tick.connect(_on_day)
	events.minute_tick.connect(_on_minute)

	ready = true
	return OK


func new_game(player_name: String = "Você", gender: String = "m") -> void:
	appearance.set_from_creator(player_name, gender, [0, 0, 0, 0, 0, 0, 0, 0, 0, 0])
	strings.player_name = player_name
	strings.player_gender = gender
	stats.setup(events, content.stats, self)
	economy.cash = 0
	economy.bank = 0
	time.day = 0
	time.minute_of_day = 8 * 60
	world.flags.clear()
	# começa no apartamento se existir
	if content.locations.has("player_apartment"):
		enter_location("player_apartment", "from_street")
	elif content.locations.has("first_street"):
		enter_location("first_street", "")


func tick_real(delta_s: float) -> void:
	if not ready:
		return
	time.tick_real(delta_s)


func enter_location(location_id: String, spawn_id: String = "") -> void:
	var loc: Dictionary = content.get_location(location_id)
	if loc.is_empty():
		push_warning("local desconhecido: " + location_id)
		return
	if loc.has("openHours") and not time.is_open(loc["openHours"]):
		events.notify.emit("@msg.closed")
		return
	if loc.has("lockedUntil") and not world.has_flag(str(loc["lockedUntil"])):
		var msg := str(loc.get("closedMessage", "@msg.locked"))
		events.notify.emit(msg)
		return
	world.set_location(location_id, spawn_id)
	if loc.has("spawn") and spawn_id == "":
		var sp: Dictionary = loc["spawn"]
		var c: Array = sp.get("cell", [0, 0])
		world.cell = Vector2i(int(c[0]), int(c[1]))
		world.facing = str(sp.get("facing", "S"))
	elif loc.has("spawns") and spawn_id != "":
		var sps: Dictionary = loc["spawns"]
		if sps.has(spawn_id):
			var sp2: Dictionary = sps[spawn_id]
			var c2: Array = sp2.get("cell", [0, 0])
			world.cell = Vector2i(int(c2[0]), int(c2[1]))
			world.facing = str(sp2.get("facing", "S"))
	_fire_location_triggers("enter")
	quests.notify_event({"event": "entered", "location": location_id})


func interact(object_id: String, action_id: String) -> Dictionary:
	var action: Dictionary = content.get_interaction(action_id)
	if action.is_empty():
		return {"ok": false, "reason": "unknown_action"}
	var req = action.get("requires", {})
	if not rules.eval(req, {"object": object_id, "action": action_id}):
		var fail := str(action.get("reactions", {}).get("fail", ""))
		if fail != "":
			events.notify.emit(fail)
		return {"ok": false, "reason": "requires"}
	if action.get("price", 0) > 0 and not economy.pay(int(action["price"])):
		events.notify.emit("@msg.no_money")
		return {"ok": false, "reason": "money"}
	if action.has("requiresItem"):
		var iid := str(action["requiresItem"])
		if not inventory.has(iid):
			return {"ok": false, "reason": "item"}
		if action.get("consumesItem", false):
			inventory.take(iid)
	if action.has("effects"):
		stats.apply_effects(action["effects"])
	if action.get("advancesTime", false) and int(action.get("durationMinutes", 0)) > 0:
		time.advance_minutes(int(action["durationMinutes"]))
	if action.has("crime"):
		crime.note_crime(int(action["crime"]), true)
	if action.has("then"):
		rules.run(action["then"], {"object": object_id, "action": action_id})
	var ev_name := str(action.get("event", "used_object"))
	quests.notify_event({"event": ev_name, "object": object_id, "action": action_id})
	_fire_location_triggers("use", object_id)
	return {"ok": true, "action": action_id}


func talk(npc_id: String, action_id: String, payload: Dictionary = {}) -> Dictionary:
	relationships.ensure(npc_id, content.get_npc(npc_id))
	if action_id == "topic" and payload.has("interest"):
		var r := dialogue.talk_topic(npc_id, str(payload["interest"]))
		quests.notify_event({"event": "talked_to", "npc": npc_id})
		_fire_location_triggers("talk", "", npc_id)
		return r
	var action: Dictionary = content.get_interaction(action_id)
	var r2 := dialogue.social_action(npc_id, action)
	quests.notify_event({"event": "talked_to", "npc": npc_id})
	_fire_location_triggers("talk", "", npc_id)
	return r2


func _fire_location_triggers(on: String, object_id: String = "", npc_id: String = "") -> void:
	var loc: Dictionary = content.get_location(world.location_id)
	for t in loc.get("triggers", []):
		if str(t.get("on", "")) != on:
			continue
		if t.has("object") and str(t["object"]) != object_id:
			continue
		if t.has("npc") and str(t["npc"]) != npc_id:
			continue
		if t.get("once", false):
			var fk := "trig_%s_%s_%s" % [world.location_id, on, str(t.get("object", t.get("npc", "")))]
			if world.has_flag(fk):
				continue
			world.set_flag(fk, true)
		var when = t.get("when", {})
		if rules.eval(when, {"object": object_id, "npc": npc_id, "location": world.location_id}):
			rules.run(t.get("do", []), {"object": object_id, "npc": npc_id})


func _on_hour(hour: int, _day: int) -> void:
	stats.on_hour_tick()
	relationships.on_hour_tick()
	pets.on_hour_tick()
	_last_hour = hour


func _on_day(day: int) -> void:
	economy.on_day_tick()
	relationships.on_day_tick(day)
	if day > 0 and day % 7 == 0:
		economy.rent_paid_this_week = false


func _on_minute(minute: int, day: int) -> void:
	crime.tick_minute()
	dating.on_minute(day, minute, self)
	# triggers periódicos
	var loc: Dictionary = content.get_location(world.location_id)
	for t in loc.get("triggers", []):
		if str(t.get("on", "")) != "periodic":
			continue
		var every := int(t.get("everyMinutes", 5))
		if every > 0 and minute % every == 0:
			if rules.eval(t.get("when", {}), {"location": world.location_id}):
				rules.run(t.get("do", []), {})


func resolve_text(key: String, ctx: Dictionary = {}) -> String:
	return strings.resolve(key, ctx)
