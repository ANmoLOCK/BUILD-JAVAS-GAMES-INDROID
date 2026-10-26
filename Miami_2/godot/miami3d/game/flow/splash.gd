extends Control
## Splash Miami 3D → emite finished após fade curto.

signal finished

@onready var title: Label = $Title
@onready var sub: Label = $Sub


func _ready() -> void:
	modulate.a = 0.0
	var tw := create_tween()
	tw.tween_property(self, "modulate:a", 1.0, 0.6)
	tw.tween_interval(0.9)
	tw.tween_property(self, "modulate:a", 0.0, 0.45)
	tw.tween_callback(func(): finished.emit())


func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		finished.emit()
	elif event is InputEventScreenTouch and event.pressed:
		finished.emit()
