class_name MnSocialMenu
extends Control
## CONVERSAR / OFERECER / FLERTAR / OFENDER → ações sociais.

signal closed
signal action_picked(npc_id: String, action_id: String)

var npc_id: String = ""
@onready var tabs: HBoxContainer = $Panel/VBox/Tabs
@onready var list: VBoxContainer = $Panel/VBox/Scroll/List
@onready var title: Label = $Panel/VBox/Title

const MENUS := {
	"talk": ["talk_compliment"],
	"offer": [],
	"flirt": [],
	"offend": [],
}


func _ready() -> void:
	visible = false


func open_for(nid: String) -> void:
	npc_id = nid
	visible = true
	title.text = "Com: " + nid
	_show_menu("talk")


func _show_menu(menu: String) -> void:
	for c in tabs.get_children():
		c.queue_free()
	for c in list.get_children():
		c.queue_free()
	var labels := {"talk": "CONVERSAR", "offer": "OFERECER", "flirt": "FLERTAR", "offend": "OFENDER"}
	for m in ["talk", "offer", "flirt", "offend"]:
		var b := Button.new()
		b.text = str(labels.get(m, m))
		b.pressed.connect(_show_menu.bind(m))
		tabs.add_child(b)
	for aid in MENUS.get(menu, []):
		var idef: Dictionary = Bootstrap.game.get_content_interaction(str(aid))
		var btn := Button.new()
		btn.text = Bootstrap.game.resolve_text(str(idef.get("name", aid)))
		btn.pressed.connect(_do.bind(str(aid)))
		list.add_child(btn)
	var close_btn := Button.new()
	close_btn.text = "Fechar"
	close_btn.pressed.connect(func(): visible = false; closed.emit())
	list.add_child(close_btn)


func _do(aid: String) -> void:
	action_picked.emit(npc_id, aid)
	visible = false
	closed.emit()
