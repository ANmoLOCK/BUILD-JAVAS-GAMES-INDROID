class_name MnPostersMinigame
extends Control
## Trabalho de publicidade: colar N cartazes (toques) antes do tempo.

signal finished(won: bool, posted: int)

@onready var info: Label = $Panel/Info
var needed: int = 5
var posted: int = 0
var time_left: float = 20.0
var active: bool = false


func _ready() -> void:
	visible = false
	$Panel/Post.pressed.connect(_post)


func start(count: int = 5, seconds: float = 20.0) -> void:
	needed = count
	posted = 0
	time_left = seconds
	active = true
	visible = true
	_upd()


func _process(delta: float) -> void:
	if not active:
		return
	time_left -= delta
	_upd()
	if time_left <= 0.0:
		active = false
		visible = false
		finished.emit(posted >= needed, posted)


func _post() -> void:
	posted += 1
	_upd()
	if posted >= needed:
		active = false
		visible = false
		finished.emit(true, posted)


func _upd() -> void:
	info.text = "Cartazes %d/%d — %.0fs" % [posted, needed, time_left]
