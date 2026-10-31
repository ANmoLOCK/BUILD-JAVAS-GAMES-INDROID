class_name MnPhone
extends Control
## Agenda / missões / atalhos — comandos via use_phone.

signal closed
signal open_map_requested

@onready var tabs: HBoxContainer = $Panel/VBox/Tabs
@onready var body: RichTextLabel = $Panel/VBox/Body


func _ready() -> void:
	visible = false
	for name in ["Stats", "Missões", "Aluguel", "Mapa", "Fechar"]:
		var b := Button.new()
		b.text = name
		match name:
			"Stats": b.pressed.connect(_show_stats)
			"Missões": b.pressed.connect(_show_quests)
			"Aluguel": b.pressed.connect(_pay_rent)
			"Mapa": b.pressed.connect(_open_map)
			"Fechar": b.pressed.connect(func(): visible = false; closed.emit())
		tabs.add_child(b)


func open() -> void:
	visible = true
	_show_stats()


func _show_stats() -> void:
	var r: Dictionary = Bootstrap.game.use_phone("stats")
	var stats: Dictionary = r.get("stats", {})
	var lines := ["[b]Estatísticas[/b]", "Dinheiro: $%d  Banco: $%d" % [int(r.get("cash", 0)), int(r.get("bank", 0))]]
	for k in ["hunger", "sleep", "hygiene", "bladder", "mood", "health"]:
		var v = stats.get(k, Bootstrap.game.get_stat(k))
		if typeof(v) == TYPE_DICTIONARY:
			v = v.get("value", v)
		lines.append("%s: %s" % [k, str(v)])
	body.text = "\n".join(lines)


func _show_quests() -> void:
	var r: Dictionary = Bootstrap.game.use_phone("quests")
	var q: Dictionary = r.get("quests", {})
	var lines := ["[b]Missões ativas[/b]"]
	if q.is_empty():
		lines.append("(nenhuma)")
	else:
		for id in q.keys():
			lines.append("%s → %s" % [id, str(q[id].get("stage", "?"))])
	body.text = "\n".join(lines)


func _pay_rent() -> void:
	var r: Dictionary = Bootstrap.game.use_phone("pay_rent")
	if bool(r.get("ok", false)):
		body.text = "Aluguel pago: $%d" % int(r.get("paid", 0))
	else:
		body.text = "Não foi possível pagar (%s)." % str(r.get("reason", "?"))


func _open_map() -> void:
	Bootstrap.game.use_phone("open_map")
	visible = false
	closed.emit()
	open_map_requested.emit()
