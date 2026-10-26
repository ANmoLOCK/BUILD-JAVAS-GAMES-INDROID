class_name MnPet
extends CharacterBody3D
## Cão/gato/ave/crocodilo: visual via AssetRegistry; segue o jogador.

signal interacted(pet_id: String)

var pet_id: String = ""
var kind: String = "dog" # dog|cat|bird|crocodile
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
		get_node("Mesh").queue_free()
	var visual: Node3D = null
	var mesh_id := breed if breed != "" else ("dog_scottish" if kind == "dog" else ("cat_house" if kind == "cat" else kind))
	if Bootstrap.game and Bootstrap.game.get("assets") != null:
		var path: String = Bootstrap.game.assets.pet_mesh_path(mesh_id)
		if Bootstrap.game.assets.has_real_mesh(path):
			visual = MnMeshFactory.try_instance_scene(path)
	if visual == null:
		visual = MnMeshFactory.pet_visual(kind)
	visual.name = "Mesh"
	visual.position.y = 0.2
	add_child(visual)
	if not has_node("Col"):
		var col := CollisionShape3D.new()
		col.name = "Col"
		var sh := BoxShape3D.new()
		sh.size = Vector3(0.4, 0.4, 0.6)
		col.shape = sh
		col.position.y = 0.2
		add_child(col)


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
