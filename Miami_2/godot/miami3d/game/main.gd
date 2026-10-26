extends Control
## Cena principal Fase A: HUD + painel do apartamento (texto/3D placeholder).

@onready var hud: Control = $HUD
@onready var phase_root: Control = $PhaseRoot
@onready var log_box: RichTextLabel = $Log
@onready var title: Label = $Title

var _apartment


func _ready() -> void:
	title.text = "Miami 3D — Fase A (cérebro + apartamento)"
	var g: MnGame = Bootstrap.game
	if g == null or not g.ready:
		log_line("[erro] cérebro não inicializado")
		return
	g.events.notify.connect(_on_notify)
	g.events.dialogue_requested.connect(_on_dialogue)
	g.events.warning.connect(_on_warning)
	g.events.collapse.connect(_on_collapse)
	g.events.quest_stage_entered.connect(_on_quest)
	g.events.stat_changed.connect(_on_stat)
	g.events.teleport.connect(_on_teleport)
	g.new_game("Alex", "m")
	hud.setup(g)
	# carrega UI da Fase A
	var scene: PackedScene = load("res://game/phases/a_apartment/apartment_panel.tscn")
	if scene:
		_apartment = scene.instantiate()
		phase_root.add_child(_apartment)
		if _apartment.has_method("setup"):
			_apartment.setup(g, self)
	log_line("Novo jogo. Local: %s — %s" % [g.world.location_id, _clock(g)])
	# inicia missão do senhorio se o trigger não disparou ainda
	if g.content.quests.has("q_landlord") and not g.quests.is_active("q_landlord"):
		pass # trigger on enter do apartamento cuida


func log_line(t: String) -> void:
	log_box.append_text(t + "\n")


func _clock(g: MnGame) -> String:
	return "Dia %d  %02d:%02d" % [g.time.day, g.time.hour(), g.time.minute_of_day % 60]


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


func _on_stat(stat_id: String, value: int, level: int) -> void:
	if stat_id in ["hunger", "sleep", "hygiene", "bladder"]:
		hud.refresh()


func _on_teleport(location_id: String, spawn_id: String) -> void:
	Bootstrap.game.enter_location(location_id, spawn_id)
	log_line("→ Teleporte: %s (%s)" % [location_id, spawn_id])
	if _apartment and _apartment.has_method("refresh"):
		_apartment.refresh()
