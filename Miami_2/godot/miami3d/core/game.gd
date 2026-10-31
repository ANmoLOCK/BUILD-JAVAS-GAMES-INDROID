class_name MnGame
extends RefCounted
## Orquestra o cérebro. Sem Node — o Bootstrap / corpo Godot chama tick e ações.

var events := MnEvents.new()
var rng := MnRng.new()
var content := MnContentRegistry.new()
var phases := MnPhaseCatalog.new()
var director := MnPhaseDirector.new()
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
	phases.load_from(content_dir.path_join("phases.json"))
	if not content.phases.is_empty():
		phases.load_dict(content.phases)
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

	# fase ativa: ProjectSettings miami/phase ou default do pack
	var pref := str(phases.doc.get("default_phase", "a"))
	if ProjectSettings.has_setting("miami/phase"):
		pref = str(ProjectSettings.get_setting("miami/phase", pref))
	set_phase(pref, false)

	ready = true
	return OK


func set_phase(phase_id: String, reenter: bool = true) -> Dictionary:
	## Avança/define fase A–G e reaplica locais desbloqueados.
	if not phases.set_phase(phase_id):
		return {"ok": false, "reason": "unknown_phase", "phase": phase_id}
	apply_phase_unlocks()
	world.set_flag("phase_%s" % phases.current, true)
	if reenter and ready:
		# re-bootstrap leve (sem resetar save inteiro): só unlocks + local se bloqueado
		if world.location_id == "" or not world.is_unlocked(world.location_id):
			var start := phases.start_location()
			enter_location(start, "")
	return {"ok": true, "phase": phases.current, "locations": Array(phases.unlocked_locations())}


func start_phase(phase_id: String) -> Dictionary:
	## New-game style dentro da fase (quests/cash/local do bootstrap).
	if not phases.set_phase(phase_id):
		return {"ok": false, "reason": "unknown_phase"}
	return director.bootstrap(self, phase_id)


func audit_phase(phase_id: String = "") -> Dictionary:
	return director.audit(self, phase_id)


func audit_all_phases() -> Dictionary:
	return director.audit_all(self)


func load_mods() -> Dictionary:
	if not phases.system_unlocked("mods"):
		return require_system("mods")
	return director.mods.load_all(content, self)


func apply_phase_unlocks() -> void:
	## Locais cumulativos da fase atual → world.unlocked_locations.
	world.unlocked_locations.clear()
	for lid in phases.unlocked_locations():
		world.unlocked_locations[lid] = true
		if events:
			events.unlock_location.emit(lid)


func require_system(system_id: String) -> Dictionary:
	if phases.system_unlocked(system_id):
		return {"ok": true}
	var need := phases.system_min_phase(system_id)
	events.notify.emit("@msg.phase_locked")
	return {"ok": false, "reason": "phase", "system": system_id, "need": need, "current": phases.current}


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
	# bootstrap operacional da fase ativa (locais, quests, cash, cutscene)
	var boot: Dictionary = director.bootstrap(self, phases.current)
	if not bool(boot.get("ok", false)):
		apply_phase_unlocks()
		var start := phases.start_location()
		if content.locations.has(start):
			enter_location(start, "from_street" if start == "player_apartment" else "")
		elif content.locations.has("player_apartment"):
			enter_location("player_apartment", "from_street")


func tick_real(delta_s: float) -> void:
	if not ready:
		return
	time.tick_real(delta_s)


func enter_location(location_id: String, spawn_id: String = "") -> void:
	location_id = phases.resolve_location_id(location_id)
	var loc: Dictionary = content.get_location(location_id)
	if loc.is_empty():
		push_warning("local desconhecido: " + location_id)
		return
	if not world.is_unlocked(location_id):
		events.notify.emit("@msg.locked")
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
	var gate := require_system("social_menus")
	if not bool(gate.get("ok", false)):
		return gate
	var aid := action_id.to_lower()
	if aid in ["date", "sair_junto", "invite_date"]:
		var dg := require_system("dating")
		if not bool(dg.get("ok", false)):
			return dg
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


func leave_location() -> Dictionary:
	## Corpo → cérebro: sai do local atual (portais / cutscene).
	if not ready:
		return {"ok": false, "reason": "not_ready"}
	if world.location_id == "":
		return {"ok": false, "reason": "no_location"}
	var prev := world.location_id
	_fire_location_triggers("leave")
	world.set_location("", "")
	quests.notify_event({"event": "left", "location": prev})
	return {"ok": true, "from": prev}


func use_phone(action: String, payload: Dictionary = {}) -> Dictionary:
	## Agenda, ligar, ATM (depósito/saque/aluguel), atalhos de UI.
	if not ready:
		return {"ok": false, "reason": "not_ready"}
	match action:
		"stats", "agenda":
			return {
				"ok": true,
				"action": action,
				"cash": economy.cash,
				"bank": economy.bank,
				"stats": stats.to_dict(),
				"day": time.day,
				"minute": time.minute_of_day,
			}
		"quests":
			var qg := require_system("quests")
			if not bool(qg.get("ok", false)):
				return qg
			return {"ok": true, "action": action, "quests": quests.to_dict() if quests.has_method("to_dict") else {}}
		"call":
			var cg := require_system("social_menus")
			if not bool(cg.get("ok", false)):
				return cg
			var npc_id := str(payload.get("npc", payload.get("npc_id", "")))
			if npc_id == "":
				events.notify.emit("@msg.phone_no_contact")
				return {"ok": false, "reason": "npc"}
			var topic := str(payload.get("topic", "greet"))
			return talk(npc_id, topic, payload)
		"deposit":
			var eg := require_system("economy")
			if not bool(eg.get("ok", false)):
				return eg
			var n := int(payload.get("amount", 0))
			if not economy.deposit(n):
				events.notify.emit("@msg.no_money")
				return {"ok": false, "reason": "money"}
			return {"ok": true, "action": action, "amount": n, "cash": economy.cash, "bank": economy.bank}
		"withdraw":
			var eg2 := require_system("economy")
			if not bool(eg2.get("ok", false)):
				return eg2
			var w := int(payload.get("amount", 0))
			if not economy.withdraw(w):
				events.notify.emit("@msg.no_money")
				return {"ok": false, "reason": "bank"}
			return {"ok": true, "action": action, "amount": w, "cash": economy.cash, "bank": economy.bank}
		"pay_rent":
			var eg3 := require_system("economy")
			if not bool(eg3.get("ok", false)):
				return eg3
			var rent := int(payload.get("amount", economy.rent_per_week))
			if economy.rent_paid_this_week:
				events.notify.emit("@msg.rent_already")
				return {"ok": false, "reason": "already"}
			if not economy.pay(rent):
				events.notify.emit("@msg.no_money")
				return {"ok": false, "reason": "money"}
			economy.rent_paid_this_week = true
			world.set_flag("rent_paid_this_week", true)
			events.notify.emit("@msg.rent_paid")
			events.save_hint.emit()
			return {"ok": true, "action": action, "paid": rent}
		"open_map":
			var mg := require_system("city_map")
			if not bool(mg.get("ok", false)):
				# Fase A/B: mapa ainda parcial — permite só locais já desbloqueados via travel direto
				return {"ok": true, "action": action, "ui": "map", "partial": true}
			return {"ok": true, "action": action, "ui": "map"}
		"surgery":
			var sg := require_system("surgery")
			if not bool(sg.get("ok", false)):
				return sg
			var kind := str(payload.get("kind", ""))
			var sdef: Dictionary = content.surgery.get(kind, content.surgery.get("items", {}))
			if typeof(content.surgery.get("items", null)) == TYPE_ARRAY:
				sdef = {}
				for it in content.surgery.get("items", []):
					if str(it.get("id", "")) == kind:
						sdef = it
						break
			var price := int(sdef.get("price", payload.get("price", 200)))
			var mins := int(sdef.get("durationMinutes", payload.get("minutes", 60)))
			if not economy.pay(price):
				events.notify.emit("@msg.no_money")
				return {"ok": false, "reason": "money"}
			appearance.sex_appeal_bonus += int(sdef.get("sexAppeal", 5))
			time.advance_minutes(mins)
			events.notify.emit("@msg.surgery_done")
			events.save_hint.emit()
			return {"ok": true, "action": action, "kind": kind, "price": price}
		"save":
			events.save_hint.emit()
			return {"ok": true, "action": action}
		_:
			events.notify.emit("@msg.phone_unknown")
			return {"ok": false, "reason": "unknown_action", "action": action}


func buy(item_id: String) -> Dictionary:
	## Loja: paga e coloca no inventário.
	if not ready:
		return {"ok": false, "reason": "not_ready"}
	var item: Dictionary = content.get_item(item_id)
	if item.is_empty():
		return {"ok": false, "reason": "unknown_item"}
	var kind := str(item.get("kind", ""))
	if kind == "furniture" or str(item.get("shop", "")) == "furniture_store":
		var fg := require_system("furniture_shop")
		if not bool(fg.get("ok", false)):
			return fg
	elif kind == "clothing":
		var ag := require_system("appearance")
		if not bool(ag.get("ok", false)):
			return ag
	elif kind == "pet":
		var pg := require_system("pets")
		if not bool(pg.get("ok", false)):
			return pg
	else:
		var eg := require_system("economy")
		if not bool(eg.get("ok", false)):
			return eg
	var price := int(item.get("price", 0))
	if price > 0 and not economy.pay(price):
		events.notify.emit("@msg.no_money")
		return {"ok": false, "reason": "money"}
	inventory.give(item_id)
	quests.notify_event({"event": "bought", "item": item_id})
	events.notify.emit("@msg.bought")
	return {"ok": true, "item": item_id, "price": price}


func equip(item_id: String = "", payload: Dictionary = {}) -> Dictionary:
	## Closet / boutique: aplica peça no paper-doll.
	if not ready:
		return {"ok": false, "reason": "not_ready"}
	var ag := require_system("appearance")
	if not bool(ag.get("ok", false)):
		return ag
	# Modo slot direto: equip("", {slot, variant, color?})
	if item_id == "" and payload.has("slot"):
		var slot := str(payload["slot"])
		var variant := int(payload.get("variant", 0))
		var color := int(payload.get("color", -1))
		if not appearance.equip_slot(slot, variant, color):
			return {"ok": false, "reason": "bad_slot"}
		events.notify.emit("@msg.equipped")
		return {"ok": true, "slot": slot, "variant": variant, "appearance": appearance.vector.duplicate()}
	# Ciclar slot (closet rápido)
	if item_id == "" and payload.get("cycle", false):
		var cslot := str(payload.get("slot", "top"))
		var nv := appearance.cycle_slot(cslot, int(payload.get("max", 6)))
		if nv < 0:
			return {"ok": false, "reason": "bad_slot"}
		return {"ok": true, "slot": cslot, "variant": nv, "appearance": appearance.vector.duplicate()}
	var item: Dictionary = content.get_item(item_id)
	if item.is_empty():
		return {"ok": false, "reason": "unknown_item"}
	if str(item.get("kind", "")) != "clothing":
		return {"ok": false, "reason": "not_clothing"}
	var owned := bool(payload.get("owned", false)) or inventory.has(item_id)
	if not owned:
		return {"ok": false, "reason": "not_owned"}
	var islot := str(item.get("slot", ""))
	var ivar := int(item.get("variant", 0))
	var icolor := int(payload.get("color", 0))
	if not appearance.equip_slot(islot, ivar, icolor):
		return {"ok": false, "reason": "bad_slot"}
	events.notify.emit("@msg.equipped")
	return {"ok": true, "item": item_id, "slot": islot, "variant": ivar, "appearance": appearance.vector.duplicate()}


func place_furniture(slot_id: String, item_id: String) -> Dictionary:
	## Apartamento: instala móvel no slot (consome inventário).
	if not ready:
		return {"ok": false, "reason": "not_ready"}
	# Trocar móvel da loja exige home_tiers (E+); manter default do apto é ok em A.
	if item_id != "" and str(home.slots.get(slot_id, "")) != item_id:
		var hg := require_system("home_tiers")
		if not bool(hg.get("ok", false)):
			return hg
	if slot_id == "":
		return {"ok": false, "reason": "bad_slot"}
	if item_id != "":
		var item: Dictionary = content.get_item(item_id)
		if item.is_empty():
			return {"ok": false, "reason": "unknown_item"}
		if not inventory.has(item_id):
			events.notify.emit("@msg.no_item")
			return {"ok": false, "reason": "item"}
	var prev := str(home.slots.get(slot_id, ""))
	if prev != "" and prev != item_id:
		inventory.give(prev)
	if item_id != "":
		inventory.take(item_id)
	home.set_furniture(slot_id, item_id)
	if events:
		events.inventory_changed.emit()
	quests.notify_event({"event": "placed_furniture", "slot": slot_id, "item": item_id})
	return {"ok": true, "slot": slot_id, "item": item_id, "previous": prev}


func start_minigame_result(minigame_id: String, won: bool, score: int = 0) -> Dictionary:
	## Corpo reporta fim de dança / cartazes / foto.
	if not ready:
		return {"ok": false, "reason": "not_ready"}
	if minigame_id in ["dance", "posters"] or minigame_id.begins_with("dance"):
		var dg := require_system("minigame_dance")
		if not bool(dg.get("ok", false)):
			return dg
	quests.notify_event({
		"event": "minigame",
		"id": minigame_id,
		"won": won,
		"score": score,
	})
	var reward := 0
	if won:
		reward = clampi(int(score / 2), 5, 50)
		economy.add_cash(reward)
		stats.apply_effects([{ "stat": "mood", "delta": 5 }])
		events.notify.emit("@msg.minigame_win")
	else:
		events.notify.emit("@msg.minigame_lose")
	return {"ok": true, "id": minigame_id, "won": won, "score": score, "reward": reward}


func advance_time_request(minutes: int) -> Dictionary:
	## Dormir / trabalho / cirurgia — UI já confirmou.
	if not ready:
		return {"ok": false, "reason": "not_ready"}
	if minutes <= 0:
		return {"ok": false, "reason": "bad_minutes"}
	time.advance_minutes(minutes)
	events.save_hint.emit()
	return {"ok": true, "minutes": minutes, "day": time.day, "minute": time.minute_of_day}


func work_shift(job_id: String = "") -> Dictionary:
	## Emprego (fase D+).
	var jg := require_system("jobs")
	if not bool(jg.get("ok", false)):
		return jg
	if job_id != "" and jobs.current_job == "":
		if not jobs.apply(job_id):
			return {"ok": false, "reason": "unknown_job"}
	return jobs.do_shift(self)


func adopt_pet(pet_id: String, kind: String = "dog", breed: String = "") -> Dictionary:
	var pg := require_system("pets")
	if not bool(pg.get("ok", false)):
		return pg
	pets.add_pet(pet_id, kind, breed)
	quests.notify_event({"event": "pet_adopted", "pet": pet_id})
	return {"ok": true, "pet": pet_id, "kind": kind}


func find_gnome(gnome_id: String) -> Dictionary:
	var gg := require_system("gnomes")
	if not bool(gg.get("ok", false)):
		return gg
	home.find_gnome(gnome_id)
	quests.notify_event({"event": "gnome_found", "gnome": gnome_id})
	events.notify.emit("@msg.gnome_found")
	return {"ok": true, "gnome": gnome_id, "count": home.gnomes_count()}


func set_home_tier(tier: int) -> Dictionary:
	## Mid/Hi apartment — liberado plenamente na fase F (home_hi); tiers base em E.
	if tier >= 2:
		var hg := require_system("home_hi")
		if not bool(hg.get("ok", false)):
			return hg
	else:
		var ht := require_system("home_tiers")
		if not bool(ht.get("ok", false)):
			return ht
	home.tier = clampi(tier, 0, 3)
	return {"ok": true, "tier": home.tier}


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
