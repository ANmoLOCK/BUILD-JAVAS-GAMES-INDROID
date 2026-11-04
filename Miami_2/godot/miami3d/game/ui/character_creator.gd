class_name MnCharacterCreator
extends Control
## Criação Neon Nightlife: presets M/F + slots + confirmação.

signal confirmed(player_name: String, gender: String, vector: Array)

@onready var name_edit: LineEdit = $Panel/VBox/Name
@onready var gender_box: HBoxContainer = $Panel/VBox/Gender
@onready var presets_box: HBoxContainer = $Panel/VBox/Presets
@onready var slots: VBoxContainer = $Panel/VBox/Scroll/Slots
@onready var preview: TextureRect = $Panel/VBox/Preview
@onready var status: Label = $Panel/VBox/Status

var _gender: String = "m"
var _vector: Array = [0, 2, 8, 0, 12, 4, 10, 0, 6, 0]
var _sliders: Array = []

const SLOT_NAMES := ["gênero", "pele", "cabelo", "cor cabelo", "top", "cor top", "bottom", "cor bottom", "calçado", "cor calçado"]
const SLOT_MAX := [1, 5, 29, 5, 30, 5, 29, 5, 12, 5]


func _ready() -> void:
	_build_gender()
	_build_presets()
	_build_sliders()
	$Panel/VBox/Confirm.pressed.connect(_confirm)
	_apply_vector_to_ui()
	_refresh_preview()


func _build_gender() -> void:
	for c in gender_box.get_children():
		c.queue_free()
	var group := ButtonGroup.new()
	for g in ["m", "f"]:
		var b := Button.new()
		b.text = "Masculino" if g == "m" else "Feminino"
		b.toggle_mode = true
		b.button_group = group
		b.button_pressed = (g == _gender)
		b.pressed.connect(_on_gender.bind(g))
		gender_box.add_child(b)


func _build_presets() -> void:
	for c in presets_box.get_children():
		c.queue_free()
	var neon := Button.new()
	neon.text = "Neon Nightlife"
	neon.pressed.connect(_apply_neon)
	presets_box.add_child(neon)
	var tip := Label.new()
	tip.text = "  base Everwind 2D/3D"
	tip.add_theme_font_size_override("font_size", 12)
	presets_box.add_child(tip)


func _build_sliders() -> void:
	for c in slots.get_children():
		c.queue_free()
	_sliders.clear()
	for i in range(1, 10):
		var row := HBoxContainer.new()
		var lab := Label.new()
		lab.text = SLOT_NAMES[i]
		lab.custom_minimum_size = Vector2(110, 0)
		row.add_child(lab)
		var slider := HSlider.new()
		slider.min_value = 0
		slider.max_value = SLOT_MAX[i]
		slider.step = 1
		slider.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		slider.value_changed.connect(_on_slot.bind(i))
		row.add_child(slider)
		slots.add_child(row)
		_sliders.append(slider)


func _on_gender(g: String) -> void:
	_gender = g
	_vector = MnNeonStyle.preset_vector(g)
	_vector[0] = 0 if g == "m" else 1
	_apply_vector_to_ui()
	_refresh_preview()


func _apply_neon() -> void:
	_vector = MnNeonStyle.preset_vector(_gender)
	_vector[0] = 0 if _gender == "m" else 1
	_apply_vector_to_ui()
	_refresh_preview()
	status.text = "Preset Neon Nightlife aplicado."


func _apply_vector_to_ui() -> void:
	for i in _sliders.size():
		var idx := i + 1
		var s: HSlider = _sliders[i]
		s.set_value_no_signal(float(int(_vector[idx]) if _vector.size() > idx else 0))


func _on_slot(value: float, idx: int) -> void:
	while _vector.size() <= idx:
		_vector.append(0)
	_vector[idx] = int(value)
	_vector[0] = 0 if _gender == "m" else 1
	_refresh_preview()


func _refresh_preview() -> void:
	var path := MnNeonStyle.body_tex(_gender)
	if ResourceLoader.exists(path):
		preview.texture = load(path)
		preview.visible = true
	else:
		preview.visible = false
	var neon := MnNeonStyle.matches(_gender, _vector)
	status.text = "Neon Nightlife · Everwind 2D/3D" if neon else "Custom · paper-doll"


func _confirm() -> void:
	var n := name_edit.text.strip_edges()
	if n == "":
		n = "Você"
	_vector[0] = 0 if _gender == "m" else 1
	confirmed.emit(n, _gender, _vector.duplicate())
