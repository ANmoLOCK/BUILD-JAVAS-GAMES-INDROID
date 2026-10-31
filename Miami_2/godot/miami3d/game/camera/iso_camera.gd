class_name MnIsoCamera
extends Camera3D
## Câmera 3/4 estilo Sims: 4 rotações de 90°, zoom, segue alvo.

@export var target_path: NodePath
@export var distance: float = 14.0
@export var height: float = 12.0
@export var angle_deg: float = 35.0
@export var zoom_min: float = 8.0
@export var zoom_max: float = 22.0

var _yaw_index: int = 0 # 0..3 → 45 + 90*i
var _target: Node3D
var _drag_prev: Vector2
var _dragging: bool = false


func _ready() -> void:
	projection = PROJECTION_PERSPECTIVE
	fov = 30.0
	current = true
	if target_path != NodePath():
		_target = get_node_or_null(target_path)
	_apply()


func bind_target(t: Node3D) -> void:
	_target = t


func rotate_cw() -> void:
	_yaw_index = (_yaw_index + 1) % 4
	_apply()


func rotate_ccw() -> void:
	_yaw_index = (_yaw_index + 3) % 4
	_apply()


func zoom(delta: float) -> void:
	distance = clampf(distance + delta, zoom_min, zoom_max)
	height = distance * 0.85
	_apply()


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMagnifyGesture:
		zoom((1.0 - event.factor) * 10.0)
	elif event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			zoom(-1.0)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			zoom(1.0)
		elif event.button_index == MOUSE_BUTTON_MIDDLE:
			_dragging = true
			_drag_prev = event.position
	elif event is InputEventMouseButton and not event.pressed and event.button_index == MOUSE_BUTTON_MIDDLE:
		_dragging = false
	elif event is InputEventMouseMotion and _dragging:
		if event.relative.x > 8:
			rotate_cw()
			_dragging = false
		elif event.relative.x < -8:
			rotate_ccw()
			_dragging = false


func _process(_dt: float) -> void:
	if _target:
		_apply()


func _apply() -> void:
	var yaw := deg_to_rad(45.0 + 90.0 * _yaw_index)
	var pitch := deg_to_rad(-angle_deg)
	var focus := _target.global_position if _target else Vector3.ZERO
	var offset := Vector3(sin(yaw) * distance, height, cos(yaw) * distance)
	global_position = focus + offset
	look_at(focus + Vector3(0, 0.8, 0), Vector3.UP)
