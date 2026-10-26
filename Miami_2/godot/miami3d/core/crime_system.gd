class_name MnCrimeSystem
extends RefCounted
## Crime ≥ 80 → prisão; fiança; testemunhas.

var events: MnEvents
var game
var arrest_at: int = 80
var in_jail: bool = false
var jail_minutes: int = 0
var jail_location: String = "police_station"


func setup(ev: MnEvents, stats_json: Dictionary, g = null) -> void:
	events = ev
	game = g
	arrest_at = int(stats_json.get("arrestAtCrime", 80))


func note_crime(delta: int, witnessed: bool = false) -> void:
	if game == null:
		return
	game.stats.apply_delta("crime", delta)
	if witnessed or game.stats.get_value("crime") >= arrest_at:
		try_arrest()


func try_arrest() -> void:
	if in_jail:
		return
	if game.stats.get_value("crime") < arrest_at:
		return
	in_jail = true
	jail_minutes = 0
	if events:
		events.notify.emit("@warn.arrest")
		events.teleport.emit(jail_location, "cell")


func tick_minute() -> void:
	if not in_jail:
		return
	jail_minutes += 1
	# Crime cai 1/h enquanto preso
	if jail_minutes % 60 == 0 and game:
		game.stats.apply_delta("crime", -1)


func bail_amount() -> int:
	if game == null:
		return 200
	return game.economy.current_bail(jail_minutes)


func pay_bail() -> bool:
	if not in_jail or game == null:
		return false
	var amount := bail_amount()
	if not game.economy.pay(amount):
		return false
	in_jail = false
	jail_minutes = 0
	if events:
		events.teleport.emit("first_street", "from_apartment")
		events.notify.emit("@msg.free")
	return true


func to_dict() -> Dictionary:
	return {"in_jail": in_jail, "jail_minutes": jail_minutes}


func from_dict(d: Dictionary) -> void:
	in_jail = bool(d.get("in_jail", false))
	jail_minutes = int(d.get("jail_minutes", 0))
