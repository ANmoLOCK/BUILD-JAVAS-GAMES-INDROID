extends Control
## Fluxo: Splash estúdio → Loading → Menu → Play (3D).

enum State { SPLASH, LOADING, MENU, PLAY }

var state: State = State.SPLASH
var _splash: Control
var _loading: Control
var _menu: Control
var _play: Node3D


func _ready() -> void:
	_show_splash()


func _clear_stage() -> void:
	for c in $Stage.get_children():
		c.queue_free()
	_splash = null
	_loading = null
	_menu = null
	_play = null


func _show_splash() -> void:
	_clear_stage()
	state = State.SPLASH
	_splash = preload("res://game/flow/splash.tscn").instantiate()
	$Stage.add_child(_splash)
	_splash.finished.connect(_show_loading, CONNECT_ONE_SHOT)


func _show_loading() -> void:
	_clear_stage()
	state = State.LOADING
	_loading = preload("res://game/flow/loading_screen.tscn").instantiate()
	$Stage.add_child(_loading)
	_loading.finished.connect(_show_menu, CONNECT_ONE_SHOT)


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
