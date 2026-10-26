class_name MnJobSystem
extends RefCounted
## 4 empregos: turno, pagamento, requisitos, promoções.

var jobs: Dictionary = {} # job_id -> def
var current_job: String = ""
var rank: int = 0 # 0 base, 1 silver, 2 gold
var shifts_done: int = 0


func register_job(def: Dictionary) -> void:
	jobs[str(def.get("id", ""))] = def


func register(def: Dictionary) -> void:
	register_job(def)


func apply(job_id: String) -> bool:
	if not jobs.has(job_id):
		return false
	current_job = job_id
	rank = 0
	return true


func quit() -> void:
	current_job = ""
	rank = 0


func can_work(game) -> bool:
	if current_job == "" or not jobs.has(current_job):
		return false
	var req: Dictionary = jobs[current_job].get("requires", {})
	for stat_id in req.keys():
		if game.stats.level(str(stat_id)) < int(req[stat_id]):
			return false
	return true


func do_shift(game) -> Dictionary:
	if not can_work(game):
		return {"ok": false}
	var j: Dictionary = jobs[current_job]
	var pay := int(j.get("pay", 40))
	if rank == 1:
		pay = int(pay * 1.5)
	elif rank >= 2:
		pay = pay * 2
	var duration := int(j.get("durationMinutes", 120))
	var effects: Array = j.get("effects", [])
	game.economy.add_cash(pay)
	game.stats.apply_effects(effects)
	game.time.advance_minutes(duration)
	shifts_done += 1
	if shifts_done >= 5 and rank < 1:
		rank = 1
	elif shifts_done >= 12 and rank < 2:
		rank = 2
	return {"ok": true, "pay": pay, "duration": duration, "rank": rank}


func to_dict() -> Dictionary:
	return {"current": current_job, "rank": rank, "shifts": shifts_done}


func from_dict(d: Dictionary) -> void:
	current_job = str(d.get("current", ""))
	rank = int(d.get("rank", 0))
	shifts_done = int(d.get("shifts", 0))
