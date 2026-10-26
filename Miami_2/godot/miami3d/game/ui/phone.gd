class_name MnPhone
extends Control
## Agenda: stats, missões, mensagens (Fase A: leitura).

signal closed

@onready var tabs: HBoxContainer = $Panel/VBox/Tabs
@onready var body: RichTextLabel = $Panel/VBox/Body


func _ready() -> void:
	visible = false
	for name in ["Stats", "Missões", "Fechar"]:
		var b := Button.new()
		b.text = name
		match name:
			"Stats": b.pressed.connect(_show_stats)
			"Missões": b.pressed.connect(_show_quests)
			"Fechar": b.pressed.connect(func(): visible = false; closed.emit())
		tabs.add_child(b)


func open() -> void:
	visible = true
	_show_stats()


func _show_stats() -> void:
	var g: BrainFacade = Bootstrap.game
	var snap: Dictionary = g.snapshot()
	var stats: Dictionary = snap.get("stats", {})
	var lines := ["[b]Estatísticas[/b]", "Dinheiro: $%d" % g.get_cash()]
	for k in ["hunger", "sleep", "hygiene", "bladder", "mood", "health"]:
		lines.append("%s: %s" % [k, str(stats.get(k, g.get_stat(k)))])
	body.text = "\n".join(lines)


func _show_quests() -> void:
	var snap: Dictionary = Bootstrap.game.snapshot()
	var q: Dictionary = snap.get("quests", {})
	var lines := ["[b]Missões ativas[/b]"]
	if q.is_empty():
		lines.append("(nenhuma)")
	else:
		for id in q.keys():
			lines.append("%s → %s" % [id, str(q[id].get("stage", "?"))])
	body.text = "\n".join(lines)
