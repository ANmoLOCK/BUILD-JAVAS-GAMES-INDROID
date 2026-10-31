class_name MnDatingSystem
extends RefCounted
## SAIR JUNTO: convite → compromisso → sequência no local.

var events: MnEvents
var pending: Dictionary = {} # {npc, location, day, minute, step}
var active: Dictionary = {}
var refusals: int = 0


func setup(ev: MnEvents) -> void:
	events = ev


func invite(npc_id: String, location_id: String, day: int, minute: int) -> void:
	pending = {
		"npc": npc_id,
		"location": location_id,
		"day": day,
		"minute": minute,
	}
	if events:
		events.notify.emit("@date.scheduled")


func on_minute(day: int, minute: int, game) -> void:
	if pending.is_empty():
		return
	if day == int(pending["day"]) and minute >= int(pending["minute"]):
		active = pending.duplicate()
		pending.clear()
		refusals = 0
		active["step"] = 0
		if events:
			events.notify.emit("@date.started")
			events.dialogue_requested.emit({"key": "@date.hello", "npc": active["npc"]})


func respond(accepted: bool, game) -> void:
	if active.is_empty():
		return
	var npc: String = str(active.get("npc", ""))
	if accepted:
		game.relationships.apply_delta(npc, 2, 5, 5)
		active["step"] = int(active.get("step", 0)) + 1
		refusals = 0
	else:
		refusals += 1
		game.relationships.apply_delta(npc, -2, -5, -10)
		if refusals >= 2:
			end(false, game)
			return
	if int(active.get("step", 0)) >= 5:
		end(true, game)


func end(success: bool, game) -> void:
	if active.is_empty():
		return
	var npc: String = str(active.get("npc", ""))
	if success:
		game.relationships.apply_delta(npc, 5, 10, 10)
		if events:
			events.notify.emit("@date.success")
	else:
		if events:
			events.notify.emit("@date.fail")
	active.clear()
	refusals = 0


func to_dict() -> Dictionary:
	return {"pending": pending.duplicate(), "active": active.duplicate(), "refusals": refusals}


func from_dict(d: Dictionary) -> void:
	pending = d.get("pending", {}).duplicate()
	active = d.get("active", {}).duplicate()
	refusals = int(d.get("refusals", 0))
