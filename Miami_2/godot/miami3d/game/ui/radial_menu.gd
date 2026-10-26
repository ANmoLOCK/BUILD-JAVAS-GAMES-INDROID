class_name MnRadialMenu
extends Control
## Menu radial de ações de objeto.

signal action_picked(action_id: String)
signal closed

var object_id: String = ""
@onready var box: VBoxContainer = $Panel/VBox


func _ready() -> void:
	visible = false


func open_for(oid: String, action_ids: Array) -> void:
	object_id = oid
	visible = true
	for c in box.get_children():
		c.queue_free()
	var title := Label.new()
	title.text = oid
	box.add_child(title)
	for aid in action_ids:
		var idef: Dictionary = Bootstrap.game.get_content_interaction(str(aid))
		var btn := Button.new()
		btn.text = Bootstrap.game.resolve_text(str(idef.get("name", aid)))
		btn.pressed.connect(_pick.bind(str(aid)))
		box.add_child(btn)
	var cancel := Button.new()
	cancel.text = "Fechar"
	cancel.pressed.connect(close)
	box.add_child(cancel)


func _pick(aid: String) -> void:
	action_picked.emit(aid)
	close()


func close() -> void:
	visible = false
	closed.emit()
