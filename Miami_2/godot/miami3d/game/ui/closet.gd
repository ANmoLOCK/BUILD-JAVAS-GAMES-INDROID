class_name MnCloset
extends Control
## Closet: troca de roupa (placeholder — aplica índices no paper-doll).

signal closed

@onready var list: VBoxContainer = $Panel/VBox/List


func _ready() -> void:
	visible = false


func open() -> void:
	visible = true
	for c in list.get_children():
		c.queue_free()
	var info := Label.new()
	info.text = "Closet — troque peças (placeholder Fase A/B)"
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
	var player := get_tree().get_first_node_in_group("player")
	if player and player.has_method("apply_appearance"):
		# só feedback visual aleatório
		var v: Array = [0, 1, randi() % 6, randi() % 6, randi() % 6, randi() % 6, randi() % 6, randi() % 6, randi() % 6, randi() % 6]
		player.apply_appearance("m", v)
