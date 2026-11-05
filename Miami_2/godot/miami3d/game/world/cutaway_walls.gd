class_name MnCutawayWalls
extends Node
## Cutaway estilo Sims: esconde as paredes que ficam entre a câmera e o foco.
##
## A versão antiga comparava a normal da parede com a direção da câmera, mas
## todos os cubos de parede são gerados sem rotação — a normal era idêntica em
## todos eles, então ou sumiam todos ou nenhum (na prática, nenhum, e a parede
## da frente tapava o jogador).

@export var camera_path: NodePath
@export var wall_group: String = "cutaway_wall"
## Margem (em metros) atrás do foco que ainda conta como "parede da frente".
@export var margin: float = 2.0
## Paredes a menos desta distância da câmera somem sempre (zoom bem fechado).
@export var near_clear: float = 3.0

var _cam: Camera3D
var _target: Node3D
var _focus: Vector3 = Vector3.ZERO
var _has_focus: bool = false


func _ready() -> void:
	if camera_path != NodePath():
		_cam = get_node_or_null(camera_path)


func bind_camera(cam: Camera3D) -> void:
	_cam = cam


func bind_target(node: Node3D) -> void:
	## Normalmente o jogador: paredes mais próximas da câmera que ele somem.
	_target = node


func set_focus(point: Vector3) -> void:
	## Fallback quando não há alvo (centro do ambiente atual).
	_focus = point
	_has_focus = true


func _process(_dt: float) -> void:
	if _cam == null:
		_cam = get_viewport().get_camera_3d()
	if not is_instance_valid(_target):
		_target = get_tree().get_first_node_in_group("player") as Node3D
	if _cam == null:
		return
	var view := -_cam.global_transform.basis.z
	view.y = 0.0
	if view.length_squared() < 0.0001:
		return
	view = view.normalized()
	var cam_pos := _cam.global_position
	var focus := cam_pos + view * 10.0
	if is_instance_valid(_target):
		focus = _target.global_position
	elif _has_focus:
		focus = _focus
	# quão longe o foco está ao longo da direção de visão
	var focus_depth := (focus - cam_pos).dot(view)
	for n in get_tree().get_nodes_in_group(wall_group):
		if not (n is Node3D):
			continue
		var depth: float = (n.global_position - cam_pos).dot(view)
		# parede mais perto da câmera que o alvo → esconde
		n.visible = depth >= focus_depth - margin and depth >= near_clear
