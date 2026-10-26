class_name MnNpc
extends CharacterBody3D
## NPC: rotina simples, pathfinding na grade, abre menu social.

signal talked(npc_id: String)

const WALK_SPEED := 2.2

var npc_id: String = ""
var def: Dictionary = {}
var grid: MnGridMap
var path: Array[Vector2i] = []
var schedule_id: String = ""


func _ready() -> void:
	add_to_group("npc")
	collision_layer = 4
	collision_mask = 1
	_build_visual()


func setup(id: String, p_def: Dictionary, g: MnGridMap) -> void:
	npc_id = id
	def = p_def
	grid = g
	schedule_id = str(def.get("schedule", ""))
	_build_visual()
	if def.has("appearance") and has_node("Doll"):
		var gender := str(def.get("gender", "m"))
		$Doll.apply_appearance(gender, def["appearance"])


func _build_visual() -> void:
	if has_node("Mesh"):
		return
	var mi := MeshInstance3D.new()
	mi.name = "Mesh"
	var box := BoxMesh.new()
	box.size = Vector3(0.45, 1.6, 0.3)
	mi.mesh = box
	mi.position.y = 0.8
	var mat := StandardMaterial3D.new()
	mat.albedo_color = Color(0.85, 0.65, 0.45)
	mi.material_override = mat
	add_child(mi)
	var label := Label3D.new()
	label.text = npc_id
	label.position = Vector3(0, 1.9, 0)
	label.font_size = 32
	label.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	add_child(label)
	if not has_node("Col"):
		var col := CollisionShape3D.new()
		col.name = "Col"
		var sh := CapsuleShape3D.new()
		sh.radius = 0.22
		sh.height = 1.3
		col.shape = sh
		col.position.y = 0.85
		add_child(col)


func go_to_cell(target: Vector2i) -> void:
	if grid == null:
		return
	var from := grid.world_to_cell(global_position)
	path = grid.find_path(from, target, true)
	if path.size() > 0 and path[0] == from:
		path.pop_front()


func _physics_process(_d: float) -> void:
	if path.is_empty() or grid == null:
		velocity = Vector3.ZERO
		move_and_slide()
		return
	var dest := grid.cell_to_world(path[0])
	var to := dest - global_position
	to.y = 0
	if to.length() < 0.1:
		path.pop_front()
		return
	velocity = to.normalized() * WALK_SPEED
	look_at(global_position + to, Vector3.UP)
	move_and_slide()


func request_talk() -> void:
	talked.emit(npc_id)
