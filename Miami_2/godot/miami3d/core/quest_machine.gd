class_name MnQuestMachine
extends RefCounted
## Máquinas de estado de missão (JSON stages + transitions).

var events: MnEvents
var game
var defs: Dictionary = {} # quest_id -> def
var active: Dictionary = {} # quest_id -> {stage, vars}


func setup(ev: MnEvents, g = null) -> void:
	events = ev
	game = g


func register(def: Dictionary) -> void:
	var id := str(def.get("id", ""))
	if id != "":
		defs[id] = def


func start(quest_id: String) -> void:
	if not defs.has(quest_id):
		push_warning("quest desconhecida: " + quest_id)
		return
	if active.has(quest_id):
		return
	var start_stage := str(defs[quest_id].get("start", ""))
	active[quest_id] = {"stage": start_stage, "vars": {}}
	_enter(quest_id, start_stage)


func set_stage(quest_id: String, stage_id: String) -> void:
	if not active.has(quest_id):
		start(quest_id)
	if not active.has(quest_id):
		return
	var prev := str(active[quest_id]["stage"])
	_exit(quest_id, prev)
	active[quest_id]["stage"] = stage_id
	_enter(quest_id, stage_id)


func notify_event(ev: Dictionary) -> void:
	# avalia transitions de todas as quests ativas
	for qid in active.keys():
		var st := str(active[qid]["stage"])
		var qdef: Dictionary = defs.get(qid, {})
		var stages: Dictionary = qdef.get("stages", {})
		var stage: Dictionary = stages.get(st, {})
		for tr in stage.get("transitions", []):
			var when: Dictionary = tr.get("when", {})
			var ctx := ev.duplicate()
			ctx["quest_id"] = qid
			if game.rules.eval(when, ctx):
				if tr.has("do"):
					game.rules.run(tr["do"], ctx)
				var to := str(tr.get("to", st))
				set_stage(qid, to)
				break


func _enter(quest_id: String, stage_id: String) -> void:
	var stage: Dictionary = defs[quest_id].get("stages", {}).get(stage_id, {})
	if events:
		events.quest_stage_entered.emit(quest_id, stage_id)
	if stage.get("final", false):
		if events:
			events.quest_completed.emit(quest_id)
		# recompensas
		var rewards: Dictionary = defs[quest_id].get("rewards", {})
		if rewards.has("money"):
			game.economy.add_cash(int(rewards["money"]))
		if rewards.has("achievement"):
			game.world.unlock_achievement(str(rewards["achievement"]))
		for it in rewards.get("items", []):
			game.inventory.give(str(it))
	if stage.get("failed", false) and events:
		events.quest_failed.emit(quest_id)
	if stage.has("onEnter"):
		game.rules.run(stage["onEnter"], {"quest": quest_id, "stage": stage_id})


func _exit(quest_id: String, stage_id: String) -> void:
	var stage: Dictionary = defs[quest_id].get("stages", {}).get(stage_id, {})
	if stage.has("onExit"):
		game.rules.run(stage["onExit"], {"quest": quest_id, "stage": stage_id})


func is_active(quest_id: String) -> bool:
	return active.has(quest_id)


func stage_of(quest_id: String) -> String:
	return str(active.get(quest_id, {}).get("stage", ""))


func to_dict() -> Dictionary:
	return active.duplicate(true)


func from_dict(d: Dictionary) -> void:
	active = d.duplicate(true)
