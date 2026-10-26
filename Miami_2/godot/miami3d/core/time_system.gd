class_name MnTimeSystem
extends RefCounted
## 1 segundo real = 1 minuto de jogo (configurável). Dia = 1440 min.

signal _internal_minute # usado só se necessário

var events: MnEvents
var seconds_per_minute: float = 1.0
var day: int = 0
var minute_of_day: int = 8 * 60 # começa ~8h
var paused: bool = false

var _accum: float = 0.0


func setup(ev: MnEvents, cfg: Dictionary = {}) -> void:
	events = ev
	seconds_per_minute = float(cfg.get("timeScaleSecondsPerMinute", 1.0))


func hour() -> int:
	return minute_of_day / 60


func day_of_week() -> int:
	return day % 7


func tick_real(delta_s: float) -> void:
	if paused or seconds_per_minute <= 0.0:
		return
	_accum += delta_s
	while _accum >= seconds_per_minute:
		_accum -= seconds_per_minute
		advance_minutes(1)


func advance_minutes(n: int) -> void:
	if n <= 0:
		return
	for _i in n:
		minute_of_day += 1
		if minute_of_day >= 1440:
			minute_of_day = 0
			day += 1
			if events:
				events.day_tick.emit(day)
		if events:
			events.minute_tick.emit(minute_of_day, day)
		if minute_of_day % 60 == 0 and events:
			events.hour_tick.emit(hour(), day)


func is_open(open_hours: Array) -> bool:
	if open_hours == null or open_hours.size() < 2:
		return true
	var a := float(open_hours[0])
	var b := float(open_hours[1])
	var h := float(hour()) + float(minute_of_day % 60) / 60.0
	if a == 0.0 and b == 24.0:
		return true
	if a <= b:
		return h >= a and h < b
	return h >= a or h < b


func to_dict() -> Dictionary:
	return {"day": day, "minute": minute_of_day}


func from_dict(d: Dictionary) -> void:
	day = int(d.get("day", 0))
	minute_of_day = int(d.get("minute", 8 * 60))
