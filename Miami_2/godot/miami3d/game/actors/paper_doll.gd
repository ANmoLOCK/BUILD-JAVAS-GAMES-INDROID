class_name MnPaperDoll
extends Node3D
## 5 slots modulares (head/hair/top/bottom/shoes) + tint de cor.
## Placeholders CSG até os GLB chegarem; API estável.

@onready var head: MeshInstance3D = $Head
@onready var hair: MeshInstance3D = $Hair
@onready var top: MeshInstance3D = $Top
@onready var bottom: MeshInstance3D = $Bottom
@onready var shoes: MeshInstance3D = $Shoes

var vector: Array = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
var gender: String = "m"

const PALETTE := [
	Color(0.92, 0.78, 0.66), Color(0.72, 0.52, 0.38), Color(0.45, 0.30, 0.20),
	Color(0.20, 0.15, 0.12), Color(0.95, 0.90, 0.85), Color(0.55, 0.40, 0.55),
]


func apply_appearance(p_gender: String, v: Array) -> void:
	gender = p_gender
	vector = v.duplicate()
	_tint(_slot("Head"), int(v[1]) if v.size() > 1 else 0)
	_tint(_slot("Hair"), int(v[3]) if v.size() > 3 else 0)
	_tint(_slot("Top"), int(v[5]) if v.size() > 5 else 0)
	_tint(_slot("Bottom"), int(v[7]) if v.size() > 7 else 0)
	_tint(_slot("Shoes"), int(v[9]) if v.size() > 9 else 0)
	# escala leve por gênero (placeholder)
	scale = Vector3(1.0, 1.02 if gender == "m" else 0.98, 1.0)


func swap_slot(slot: String, _mesh_path: String, color_index: int) -> void:
	var node: MeshInstance3D = get_node_or_null(slot.capitalize())
	if node:
		_tint(node, color_index)
	# quando houver GLB: node.mesh = load(mesh_path)


func _slot(n: String) -> MeshInstance3D:
	return get_node_or_null(n) as MeshInstance3D


func _tint(mi: MeshInstance3D, idx: int) -> void:
	if mi == null:
		return
	if mi == null:
		return
	var mat := StandardMaterial3D.new()
	mat.albedo_color = PALETTE[clampi(idx, 0, PALETTE.size() - 1)]
	mi.material_override = mat
