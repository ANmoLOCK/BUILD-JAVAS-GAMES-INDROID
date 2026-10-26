extends Control
## Cena principal Fase A: HUD + painel do apartamento.

@onready var hud: Control = $HUD
@onready var phase_root: Control = $PhaseRoot
@onready var log_box: RichTextLabel = $Log
@onready var title: Label = $Title

var _apartment


func _ready() -> void:
	var mode := "C++" if Bootstrap.game.is_native else "GDScript"
	title.text = "Miami 3D — Fase A (%s)" % mode
	var g: BrainFacade = Bootstrap.game
	if g == null or not g.ready:
		log_line("[erro] cérebro não inicializado")
		return
	g.connect_signal("notify", _on_notify)
	g.connect_signal("dialogue_requested", _on_dialogue)
	g.connect_signal("warning", _on_warning)
	g.connect_signal("collapse", _on_collapse)
	g.connect_signal("quest_stage_entered", _on_quest)
	g.connect_signal("stat_changed", _on_stat)
	g.connect_signal("teleport", _on_teleport)
	g.new_game("Alex", "m")
	hud.setup(g)
	var scene: PackedScene = load("res://game/phases/a_apartment/apartment_panel.tscn")
	if scene:
		_apartment = scene.instantiate()
		phase_root.add_child(_apartment)
		if _apartment.has_method("setup"):
			_apartment.setup(g, self)
	log_line("Novo jogo [%s]. Local: %s — %s" % [mode, g.get_location(), _clock(g)])


func log_line(t: String) -> void:
	log_box.append_text(t + "\n")


func _clock(g: BrainFacade) -> String:
	return "Dia %d  %02d:%02d" % [g.get_day(), g.get_hour(), g.get_minute_of_day() % 60]


func _on_notify(key: String) -> void:
	log_line("• " + Bootstrap.game.resolve_text(key))


func _on_dialogue(payload: Dictionary) -> void:
	var key := str(payload.get("key", payload.get("line", "")))
	if key != "":
		log_line("💬 " + Bootstrap.game.resolve_text(key, payload))


func _on_warning(stat_id: String, text_key: String) -> void:
	log_line("⚠ [%s] %s" % [stat_id, Bootstrap.game.resolve_text(text_key)])


func _on_collapse(stat_id: String, text_key: String) -> void:
	log_line("💥 COLAPSO [%s] %s" % [stat_id, Bootstrap.game.resolve_text(text_key)])


func _on_quest(qid: String, stage: String) -> void:
	log_line("🎯 Missão %s → estágio %s" % [qid, stage])


func _on_stat(_stat_id: String, _value: int, _level: int) -> void:
	hud.refresh()


func _on_teleport(location_id: String, spawn_id: String) -> void:
	Bootstrap.game.enter_location(location_id, spawn_id)
	log_line("→ Teleporte: %s (%s)" % [location_id, spawn_id])
	if _apartment and _apartment.has_method("refresh"):
		_apartment.refresh()
