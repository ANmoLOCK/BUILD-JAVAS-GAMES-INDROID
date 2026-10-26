extends Control
## Menu: Novo jogo / Continuar / Sair.

signal new_game
signal continue_game
signal quit_game

@onready var status: Label = $Panel/VBox/Status
@onready var continue_btn: Button = $Panel/VBox/Continue


func _ready() -> void:
	$Panel/VBox/New.pressed.connect(func(): new_game.emit())
	continue_btn.pressed.connect(func(): continue_game.emit())
	$Panel/VBox/Quit.pressed.connect(func(): quit_game.emit())
	refresh()


func refresh() -> void:
	var g: BrainFacade = Bootstrap.game
	var mode := "C++" if g and g.is_native else "GDScript"
	var has_save := false
	if g and g.ready:
		# tenta carregar metadados do slot 0 sem aplicar
		var path := "user://saves/slot_0.json"
		has_save = FileAccess.file_exists(path)
	continue_btn.disabled = not has_save
	status.text = "Cérebro: %s  ·  save: %s" % [mode, "ok" if has_save else "nenhum"]
