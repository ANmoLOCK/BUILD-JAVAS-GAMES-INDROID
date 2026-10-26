class_name MnDialoguePanel
extends Control
## Painel de falas com tags resolvidas.

signal finished

@onready var text: RichTextLabel = $Panel/VBox/Text
@onready var next_btn: Button = $Panel/VBox/Next

var _pages: PackedStringArray = []
var _i: int = 0


func _ready() -> void:
	visible = false
	next_btn.pressed.connect(_next)


func show_key(key: String, ctx: Dictionary = {}) -> void:
	var raw := Bootstrap.game.resolve_text(key, ctx)
	_pages = PackedStringArray(raw.split("|"))
	_i = 0
	visible = true
	_show_page()


func show_text(t: String) -> void:
	_pages = PackedStringArray([t])
	_i = 0
	visible = true
	_show_page()


func _show_page() -> void:
	if _i >= _pages.size():
		visible = false
		finished.emit()
		return
	text.text = _pages[_i]


func _next() -> void:
	_i += 1
	_show_page()
