class_name MnPauseMenu
extends Control

signal resume
signal to_menu

@onready var status: Label = $Panel/VBox/Status


func _ready() -> void:
	visible = false
	$Panel/VBox/Continue.pressed.connect(func(): visible = false; resume.emit())
	$Panel/VBox/Save.pressed.connect(_save)
	$Panel/VBox/Menu.pressed.connect(func(): visible = false; to_menu.emit())


func open() -> void:
	visible = true
	var g: BrainFacade = Bootstrap.game
	status.text = "Dia %d  %02d:%02d  $%d  [%s]" % [
		g.get_day(), g.get_hour(), g.get_minute_of_day() % 60, g.get_cash(),
		"C++" if g.is_native else "GDScript",
	]
	if Bootstrap.game:
		Bootstrap.game.backend.set_paused(true) if g.is_native else _pause_gdscript(true)


func close_unpause() -> void:
	visible = false
	var g: BrainFacade = Bootstrap.game
	if g.is_native:
		g.backend.set_paused(false)
	else:
		_pause_gdscript(false)


func _pause_gdscript(p: bool) -> void:
	if Bootstrap.game and Bootstrap.game.time:
		Bootstrap.game.time.paused = p


func _save() -> void:
	var err := Bootstrap.game.save_game(0)
	status.text = "Salvo!" if err == OK else "Erro ao salvar"
