class_name MnPet
extends CharacterBody3D
## Cão/gato: segue o jogador se fome baixa; ações feed/play/train via UI.

signal interacted(pet_id: String)

var pet_id: String = ""
var kind: String = "dog" # dog|cat
var breed: String = ""
var follow: bool = true


func _ready() -> void:
	add_to_group("pet")
	_build()


func setup(id: String, p_kind: String, p_breed: String = "") -> void:
	pet_id = id
	kind = p_kind
	breed = p_breed
	_build()


func _build() -> void:
	if has_node("Mesh"):
		return
	var mi := MeshInstance3D.new()
	mi.name = "Mesh"
	var box := BoxMesh.new()
	box.size = Vector3(0.45, 0.35, 0.7) if kind == "dog" else Vector3(0.35, 0.28, 0.5)
	mi.mesh = box
	mi.position.y = 0.2
	var mat := StandardMaterial3D.new()
	mat.albedo_color = Color(0.55, 0.4, 0.25) if kind == "dog" else Color(0.7, 0.7, 0.65)
	mi.material_override = mat
	add_child(mi)


func _physics_process(delta: float) -> void:
	if not follow:
		return
	var player := get_tree().get_first_node_in_group("player") as Node3D
	if player == null:
		return
	var to := player.global_position - global_position
	to.y = 0
	if to.length() > 2.0:
		global_position += to.normalized() * 2.5 * delta
