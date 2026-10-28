extends Control
## Fluxo: cutscene (preto → HueHueGames → Miami Life + loading) → Menu → Play.

enum State { BOOT, MENU, PLAY }

var state: State = State.BOOT
var _boot: Control
var _menu: Control
var _play: Node3D


func _ready() -> void:
	_show_boot()


func _clear_stage() -> void:
	for c in $Stage.get_children():
		c.queue_free()
	_boot = null
	_menu = null
	_play = null


func _show_boot() -> void:
	_clear_stage()
	state = State.BOOT
	_boot = preload("res://game/flow/boot_cutscene.tscn").instantiate()
	$Stage.add_child(_boot)
	_boot.finished.connect(_show_menu, CONNECT_ONE_SHOT)


func _show_menu() -> void:
	_clear_stage()
	state = State.MENU
	_menu = preload("res://game/flow/main_menu.tscn").instantiate()
	$Stage.add_child(_menu)
	_menu.new_game.connect(_start_new)
	_menu.continue_game.connect(_start_continue)
	_menu.quit_game.connect(func(): get_tree().quit())


func _start_new() -> void:
	_enter_play(true)


func _start_continue() -> void:
	_enter_play(false)


func _enter_play(is_new: bool) -> void:
	_clear_stage()
	state = State.PLAY
	_play = preload("res://game/flow/play_root.tscn").instantiate()
	$Stage.add_child(_play)
	_play.request_menu.connect(_show_menu)
	_play.setup(is_new)
