class_name MnRuleInterpreter
extends RefCounted
## Avalia condições `when` e executa ações `do` (linguagem do doc 06 §4).

var game
var events: MnEvents


func setup(g, ev: MnEvents) -> void:
	game = g
	events = ev


func eval(cond, ctx: Dictionary = {}) -> bool:
	if cond == null or (typeof(cond) == TYPE_DICTIONARY and cond.is_empty()):
		return true
	if typeof(cond) != TYPE_DICTIONARY:
		return false
	if cond.has("not"):
		return not eval(cond["not"], ctx)
	if cond.has("anyOf"):
		for c in cond["anyOf"]:
			if eval(c, ctx):
				return true
		return false
	# AND implícito de todas as chaves
	for k in cond.keys():
		if k in ["not", "anyOf"]:
			continue
		if not _eval_key(str(k), cond[k], ctx):
			return false
	return true


func run(actions, ctx: Dictionary = {}) -> void:
	if actions == null:
		return
	if typeof(actions) != TYPE_ARRAY:
		return
	for a in actions:
		if typeof(a) != TYPE_DICTIONARY:
			continue
		_run_one(a, ctx)


func _eval_key(key: String, val, ctx: Dictionary) -> bool:
	match key:
		"event":
			return str(ctx.get("event", "")) == str(val)
		"npc":
			return str(ctx.get("npc", "")) == str(val)
		"object":
			return str(ctx.get("object", "")) == str(val)
		"action":
			return str(ctx.get("action", "")) == str(val)
		"location":
			return game.world.location_id == str(val) or str(ctx.get("location", "")) == str(val)
		"quest":
			return _eval_quest(val)
		"stat":
			return _eval_stat_map(val)
		"friendshipLevel":
			return _cmp(game.relationships.friendship_level(str(ctx.get("npc", ""))), val)
		"friendship":
			var s = game.relationships.get_npc(str(ctx.get("npc", "")))
			return s != null and _cmp(s.friendship, val)
		"romance":
			var s2 = game.relationships.get_npc(str(ctx.get("npc", "")))
			return s2 != null and _cmp(s2.romance, val)
		"npcMood":
			var s3 = game.relationships.get_npc(str(ctx.get("npc", "")))
			return s3 != null and _cmp(s3.mood, val)
		"money":
			return _cmp(game.economy.cash, val)
		"hasItem":
			return game.inventory.has(str(val))
		"hasNotItem":
			return not game.inventory.has(str(val))
		"time":
			return _eval_time(val)
		"flag":
			return game.world.has_flag(str(val))
		"notFlag":
			return not game.world.has_flag(str(val))
		"random":
			return game.rng.chance(float(val))
		"appearance":
			if typeof(val) == TYPE_DICTIONARY and val.has("gender"):
				return game.appearance.gender == str(val["gender"])
			return true
		_:
			return true
	return true


func _eval_quest(val) -> bool:
	if typeof(val) != TYPE_DICTIONARY:
		return false
	var qid := str(val.get("id", ""))
	if val.has("completed"):
		# completed = não está ativa e já passou por final — simplificado: flag
		return game.world.has_flag("quest_done_" + qid) == bool(val["completed"])
	if not game.quests.is_active(qid):
		return false
	if val.has("stage"):
		return game.quests.stage_of(qid) == str(val["stage"])
	return true


func _eval_stat_map(m) -> bool:
	if typeof(m) != TYPE_DICTIONARY:
		return false
	for sid in m.keys():
		if not _cmp(game.stats.get_value(str(sid)), m[sid]):
			return false
	return true


func _eval_time(t) -> bool:
	if typeof(t) != TYPE_DICTIONARY:
		return false
	if t.has("hour") and not _cmp(game.time.hour(), t["hour"]):
		return false
	if t.has("minute") and not _cmp(game.time.minute_of_day, t["minute"]):
		return false
	if t.has("day") and not _cmp(game.time.day, t["day"]):
		return false
	if t.has("dayOfWeek") and game.time.day_of_week() != int(t["dayOfWeek"]):
		return false
	return true


func _cmp(value: int, cond) -> bool:
	if typeof(cond) == TYPE_INT or typeof(cond) == TYPE_FLOAT:
		return value == int(cond)
	if typeof(cond) != TYPE_DICTIONARY:
		return false
	if cond.has(">=") and not (value >= int(cond[">="])): return false
	if cond.has("<=") and not (value <= int(cond["<="])): return false
	if cond.has(">") and not (value > int(cond[">"])): return false
	if cond.has("<") and not (value < int(cond["<"])): return false
	if cond.has("==") and not (value == int(cond["=="])): return false
	if cond.has("!=") and not (value != int(cond["!="])): return false
	return true


func _run_one(a: Dictionary, ctx: Dictionary) -> void:
	if a.has("dialogue"):
		var d = a["dialogue"]
		if typeof(d) == TYPE_STRING:
			events.dialogue_requested.emit({"key": str(d)})
		elif typeof(d) == TYPE_DICTIONARY:
			events.dialogue_requested.emit(d)
	elif a.has("money"):
		game.economy.add_cash(int(a["money"]))
	elif a.has("bank"):
		game.economy.add_bank(int(a["bank"]))
	elif a.has("stat"):
		game.stats.apply_stat_map(a["stat"])
	elif a.has("relationship"):
		var r: Dictionary = a["relationship"]
		game.relationships.apply_delta(str(r.get("npc", "")), int(r.get("friendship", 0)), int(r.get("romance", 0)), int(r.get("mood", 0)))
	elif a.has("giveItem"):
		game.inventory.give(str(a["giveItem"]))
		game.quests.notify_event({"event": "item_gained", "item": str(a["giveItem"])})
	elif a.has("takeItem"):
		game.inventory.take(str(a["takeItem"]))
	elif a.has("startQuest"):
		game.quests.start(str(a["startQuest"]))
	elif a.has("setStage"):
		var ss: Dictionary = a["setStage"]
		game.quests.set_stage(str(ss.get("quest", "")), str(ss.get("stage", "")))
	elif a.has("completeQuest"):
		game.world.set_flag("quest_done_" + str(a["completeQuest"]), true)
		game.quests.active.erase(str(a["completeQuest"]))
		events.quest_completed.emit(str(a["completeQuest"]))
	elif a.has("failQuest"):
		events.quest_failed.emit(str(a["failQuest"]))
	elif a.has("spawnNpc"):
		var sp: Dictionary = a["spawnNpc"]
		var cell: Array = sp.get("cell", [0, 0])
		events.spawn_npc.emit(str(sp.get("npc", "")), Vector2i(int(cell[0]), int(cell[1])), str(sp.get("facing", "S")))
	elif a.has("despawnNpc"):
		events.despawn_npc.emit(str(a["despawnNpc"]))
	elif a.has("moveNpc"):
		var mv: Dictionary = a["moveNpc"]
		var c2: Array = mv.get("cell", [0, 0])
		events.move_npc.emit(str(mv.get("npc", "")), Vector2i(int(c2[0]), int(c2[1])), bool(mv.get("run", false)))
	elif a.has("teleport"):
		var tp: Dictionary = a["teleport"]
		events.teleport.emit(str(tp.get("location", "")), str(tp.get("spawn", "")))
	elif a.has("advanceTime"):
		game.time.advance_minutes(int(a["advanceTime"]))
	elif a.has("schedule"):
		var sc: Dictionary = a["schedule"]
		var when_min := game.time.minute_of_day + int(sc.get("inMinutes", 60))
		var day := game.time.day
		if when_min >= 1440:
			day += when_min / 1440
			when_min = when_min % 1440
		game.dating.invite(str(sc.get("npc", "")), str(sc.get("location", "")), day, when_min)
	elif a.has("unlockLocation"):
		game.world.unlock_location(str(a["unlockLocation"]))
	elif a.has("lockLocation"):
		game.world.lock_location(str(a["lockLocation"]))
	elif a.has("markMap"):
		game.world.unlock_location(str(a["markMap"]))
	elif a.has("setFlag"):
		game.world.set_flag(str(a["setFlag"]), true)
	elif a.has("clearFlag"):
		game.world.clear_flag(str(a["clearFlag"]))
	elif a.has("cutscene"):
		events.cutscene.emit(a["cutscene"])
	elif a.has("playSound"):
		events.play_sound.emit(str(a["playSound"]))
	elif a.has("playMusic"):
		events.play_music.emit(str(a["playMusic"]))
	elif a.has("achievement"):
		game.world.unlock_achievement(str(a["achievement"]))
	elif a.has("minigame"):
		events.minigame_requested.emit(a["minigame"])
	elif a.has("notify"):
		events.notify.emit(str(a["notify"]))
	elif a.has("if"):
		var iff: Dictionary = a["if"]
		if eval(iff.get("when", {}), ctx):
			run(iff.get("then", []), ctx)
		else:
			run(iff.get("else", []), ctx)
