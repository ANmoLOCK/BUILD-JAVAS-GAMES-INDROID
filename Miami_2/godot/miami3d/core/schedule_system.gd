class_name MnScheduleSystem
extends RefCounted
## Rotinas de NPC: {dias?, horaInício, horaFim, location, cell?}.

var schedules: Dictionary = {} # schedule_id -> Array[Dictionary]
var npc_schedule: Dictionary = {} # npc_id -> schedule_id


func load_schedule(id: String, data) -> void:
	if typeof(data) == TYPE_ARRAY:
		schedules[id] = data
	elif typeof(data) == TYPE_DICTIONARY:
		schedules[id] = data.get("entries", data.get("blocks", []))


func bind_npc(npc_id: String, schedule_id: String) -> void:
	npc_schedule[npc_id] = schedule_id


func where_is(npc_id: String, day: int, minute_of_day: int) -> Dictionary:
	var sid: String = str(npc_schedule.get(npc_id, ""))
	if sid == "" or not schedules.has(sid):
		return {}
	var hour := minute_of_day / 60
	var dow := day % 7
	for block in schedules[sid]:
		if typeof(block) != TYPE_DICTIONARY:
			continue
		var days: Array = block.get("days", [0, 1, 2, 3, 4, 5, 6])
		if not days.has(dow) and not days.is_empty():
			continue
		var a := int(block.get("hourStart", block.get("start", 0)))
		var b := int(block.get("hourEnd", block.get("end", 24)))
		var ok := (hour >= a and hour < b) if a <= b else (hour >= a or hour < b)
		if ok:
			return {
				"location": str(block.get("location", "")),
				"cell": block.get("cell", [0, 0]),
				"facing": str(block.get("facing", "S")),
			}
	return {}
