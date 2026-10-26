class_name MnCloset
extends Control
## Closet: troca de roupa via BrainFacade.equip (contrato corpo→cérebro).

signal closed
signal appearance_changed(vector: Array)

@onready var list: VBoxContainer = $Panel/VBox/List


func _ready() -> void:
	visible = false


func open() -> void:
	visible = true
	for c in list.get_children():
		c.queue_free()
	var info := Label.new()
	info.text = "Closet — escolha uma peça"
	list.add_child(info)
	for slot in ["hair", "top", "bottom", "shoes"]:
		var btn := Button.new()
		btn.text = "Alternar " + slot
		btn.pressed.connect(_cycle.bind(slot))
		list.add_child(btn)
	var close_btn := Button.new()
	close_btn.text = "Fechar"
	close_btn.pressed.connect(func(): visible = false; closed.emit())
	list.add_child(close_btn)


func _cycle(slot: String) -> void:
	var r: Dictionary = Bootstrap.game.equip("", {"cycle": true, "slot": slot, "max": 6})
	if not bool(r.get("ok", false)):
		return
	var vector: Array = r.get("appearance", [])
	appearance_changed.emit(vector)
	var player := get_tree().get_first_node_in_group("player")
	if player and player.has_method("apply_appearance") and vector.size() >= 10:
		var gender := "f" if int(vector[0]) == 1 else "m"
		player.apply_appearance(gender, vector)
