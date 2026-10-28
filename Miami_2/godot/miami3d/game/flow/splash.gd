extends Control
## Splash do estúdio (substitui Gameloft) → finished.

signal finished

@onready var logo: TextureRect = $Center/Logo
@onready var studio_label: Label = $Center/Studio
@onready var legal: Label = $Legal


func _ready() -> void:
	var tex := MnBrand.load_texture("studio_logo")
	if tex and logo:
		logo.texture = tex
	if studio_label:
		studio_label.text = MnBrand.studio()
	if legal:
		legal.text = MnBrand.studio_legal() + "  ·  placeholder de marca"
	modulate.a = 0.0
	var hold := float(MnBrand.boot().get("studio_hold_s", 1.6))
	var tw := create_tween()
	tw.tween_property(self, "modulate:a", 1.0, 0.55)
	tw.tween_interval(hold)
	tw.tween_property(self, "modulate:a", 0.0, 0.4)
	tw.tween_callback(func(): finished.emit())


func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		finished.emit()
	elif event is InputEventScreenTouch and event.pressed:
		finished.emit()
