class_name MnCharacterCreator
extends Control
## Criação: nome, gênero, 10 slots de aparência (índices).

signal confirmed(player_name: String, gender: String, vector: Array)

@onready var name_edit: LineEdit = $Panel/VBox/Name
@onready var gender_box: HBoxContainer = $Panel/VBox/Gender
@onready var slots: VBoxContainer = $Panel/VBox/Scroll/Slots

var _gender: String = "m"
var _vector: Array = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
const SLOT_NAMES := ["gênero", "pele", "cabelo", "cor cabelo", "top", "cor top", "bottom", "cor bottom", "calçado", "cor calçado"]


func _ready() -> void:
	for g in ["m", "f"]:
		var b := Button.new()
		b.text = "Masculino" if g == "m" else "Feminino"
		b.pressed.connect(func(): _gender = g; _vector[0] = 0 if g == "m" else 1)
		gender_box.add_child(b)
	for i in range(1, 10):
		var row := HBoxContainer.new()
		var lab := Label.new()
		lab.text = SLOT_NAMES[i]
		lab.custom_minimum_size = Vector2(120, 0)
		row.add_child(lab)
		var slider := HSlider.new()
		slider.min_value = 0
		slider.max_value = 5
		slider.step = 1
		slider.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		slider.value_changed.connect(_on_slot.bind(i))
		row.add_child(slider)
		slots.add_child(row)
	$Panel/VBox/Confirm.pressed.connect(_confirm)


func _on_slot(value: float, idx: int) -> void:
	_vector[idx] = int(value)


func _confirm() -> void:
	var n := name_edit.text.strip_edges()
	if n == "":
		n = "Você"
	confirmed.emit(n, _gender, _vector.duplicate())
