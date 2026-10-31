class_name MnSafePanel
extends PanelContainer
## Painel modal centrado com margens seguras — não vaza da tela.

@export var margin_ratio: float = 0.08
@export var max_width: float = 720.0
@export var max_height: float = 560.0


func _ready() -> void:
	set_anchors_preset(Control.PRESET_FULL_RECT)
	# reconecta no resize
	get_viewport().size_changed.connect(_fit)
	_fit()


func _fit() -> void:
	var vp := get_viewport_rect().size
	if vp.x < 1.0 or vp.y < 1.0:
		return
	var m := margin_ratio
	var w := mini(max_width, vp.x * (1.0 - 2.0 * m))
	var h := mini(max_height, vp.y * (1.0 - 2.0 * m))
	anchor_left = 0.5
	anchor_top = 0.5
	anchor_right = 0.5
	anchor_bottom = 0.5
	offset_left = -w * 0.5
	offset_top = -h * 0.5
	offset_right = w * 0.5
	offset_bottom = h * 0.5
	size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	size_flags_vertical = Control.SIZE_SHRINK_CENTER
