class_name MnCutawayWalls
extends Node
## Esconde meshes de parede cuja normal aponta para a câmera (cutaway estilo Sims).

@export var camera_path: NodePath
@export var wall_group: String = "cutaway_wall"
@export var dot_threshold: float = 0.15

var _cam: Camera3D


func _ready() -> void:
	if camera_path != NodePath():
		_cam = get_node_or_null(camera_path)


func bind_camera(cam: Camera3D) -> void:
	_cam = cam


func _process(_dt: float) -> void:
	if _cam == null:
		return
	var view := -_cam.global_transform.basis.z.normalized()
	for n in get_tree().get_nodes_in_group(wall_group):
		if n is Node3D:
			var forward: Vector3 = -n.global_transform.basis.z
			# se a parede "olha" para a câmera, esconde
			var vis := forward.dot(view) < dot_threshold
			n.visible = vis
