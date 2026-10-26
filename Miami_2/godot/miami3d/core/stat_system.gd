class_name MnStatSystem
extends RefCounted
## 16 stats com taxas por hora, limiares, avisos e colapso.

var events: MnEvents
var game # MnGame — preenchido depois (evita ciclo de class)
var defs: Array = [] # defs do stats.json
var values: Dictionary = {} # id -> int 0..100
var _warned: Dictionary = {} # "stat@at" -> true
var _collapsed: Dictionary = {}


func setup(ev: MnEvents, stats_json: Dictionary, g = null) -> void:
	events = ev
	game = g
	defs = stats_json.get("stats", [])
	values.clear()
	for d in defs:
		values[str(d["id"])] = int(d.get("initial", 0))
	_recompute_derived()


func get_value(stat_id: String) -> int:
	return int(values.get(stat_id, 0))


func set_value(stat_id: String, v: int) -> void:
	v = clampi(v, 0, 100)
	var old: int = get_value(stat_id)
	if old == v:
		return
	values[stat_id] = v
	if events:
		events.stat_changed.emit(stat_id, v, level(stat_id))
	_check_warnings(stat_id)
	_check_collapse(stat_id)


func apply_delta(stat_id: String, delta: float) -> void:
	set_value(stat_id, get_value(stat_id) + int(round(delta)))


func apply_effects(effects: Array) -> void:
	for e in effects:
		if typeof(e) != TYPE_DICTIONARY:
			continue
		apply_delta(str(e.get("stat", "")), float(e.get("delta", 0)))
	_recompute_derived()


func apply_stat_map(m: Dictionary) -> void:
	for k in m.keys():
		apply_delta(str(k), float(m[k]))
	_recompute_derived()


func level(stat_id: String) -> int:
	var d := _def(stat_id)
	if d.is_empty():
		return 0
	var th: Array = d.get("thresholds", [20, 40, 60, 80, 100])
	var v := get_value(stat_id)
	var worse: bool = bool(d.get("higherIsWorse", false))
	# 0..4
	for i in th.size():
		if worse:
			if v <= int(th[i]):
				return i
		else:
			if v < int(th[i]):
				return i
	return mini(4, th.size() - 1)


func on_hour_tick() -> void:
	for d in defs:
		if str(d.get("kind", "")) == "derived":
			continue
		var per := float(d.get("perHour", 0))
		if per == 0.0:
			continue
		var id := str(d["id"])
		var nv := get_value(id) + per
		if d.has("floor"):
			nv = maxf(nv, float(d["floor"]))
		set_value(id, int(round(nv)))
	_recompute_derived()


func _recompute_derived() -> void:
	# mood = avg(inv(hunger), inv(sleep), hygiene, inv(bladder))
	var inv_h := 100 - get_value("hunger")
	var inv_s := 100 - get_value("sleep")
	var hy := get_value("hygiene")
	var inv_b := 100 - get_value("bladder")
	var mood := int(round((inv_h + inv_s + hy + inv_b) / 4.0))
	values["mood"] = clampi(mood, 0, 100)
	# social: preenchido pelo RelationshipSystem via game
	if game and game.relationships:
		var n: int = game.relationships.count_friends_at_least_level(2)
		values["social"] = clampi(n * 10, 0, 100)


func _def(stat_id: String) -> Dictionary:
	for d in defs:
		if str(d.get("id", "")) == stat_id:
			return d
	return {}


func _check_warnings(stat_id: String) -> void:
	var d := _def(stat_id)
	var v := get_value(stat_id)
	var worse: bool = bool(d.get("higherIsWorse", false))
	for w in d.get("warnings", []):
		var at := int(w.get("at", -1))
		var key := "%s@%d" % [stat_id, at]
		var hit := (v >= at) if worse else (v <= at)
		if hit and not _warned.get(key, false):
			_warned[key] = true
			if events:
				events.warning.emit(stat_id, str(w.get("text", "")))


func _check_collapse(stat_id: String) -> void:
	var d := _def(stat_id)
	if not d.has("collapse"):
		return
	var c: Dictionary = d["collapse"]
	var at := int(c.get("at", 100))
	var v := get_value(stat_id)
	var worse: bool = bool(d.get("higherIsWorse", false))
	var hit := (v >= at) if worse else (v <= at)
	var key := "collapse_%s" % stat_id
	if hit and not _collapsed.get(key, false):
		_collapsed[key] = true
		if events:
			events.collapse.emit(stat_id, str(c.get("text", "")))
		if game and game.rules:
			game.rules.run(c.get("do", []), {"source": "collapse", "stat": stat_id})
		# libera novo colapso quando sai da zona
	elif not hit:
		_collapsed[key] = false


func to_dict() -> Dictionary:
	return values.duplicate()


func from_dict(d: Dictionary) -> void:
	for k in d.keys():
		values[str(k)] = int(d[k])
	_recompute_derived()
