class_name MnPlayer
extends CharacterBody3D
## Jogador: tap-to-move na grade, paper-doll, animações lógicas.

signal arrived
signal tapped_interactable(node)

const WALK_SPEED := 3.0
const RUN_SPEED := 6.0

var grid: MnGridMap
var path: Array[Vector2i] = []
var running: bool = false
var anim_state: String = "idle"
var _doll: MnPaperDoll


func _ready() -> void:
	add_to_group("player")
	collision_layer = 1
	collision_mask = 1
	_ensure_visual()


func _ensure_visual() -> void:
	if has_node("PaperDoll"):
		_doll = $PaperDoll
		return
	# monta paper-doll placeholder
	var doll := Node3D.new()
	doll.name = "PaperDoll"
	doll.set_script(preload("res://game/actors/paper_doll.gd"))
	for part in [
		["Head", Vector3(0, 1.55, 0), Vector3(0.28, 0.28, 0.28)],
		["Hair", Vector3(0, 1.72, 0), Vector3(0.32, 0.16, 0.32)],
		["Top", Vector3(0, 1.15, 0), Vector3(0.45, 0.5, 0.25)],
		["Bottom", Vector3(0, 0.65, 0), Vector3(0.4, 0.45, 0.25)],
		["Shoes", Vector3(0, 0.12, 0), Vector3(0.35, 0.12, 0.4)],
	]:
		var mi := MeshInstance3D.new()
		mi.name = part[0]
		var box := BoxMesh.new()
		box.size = part[2]
		mi.mesh = box
		mi.position = part[1]
		doll.add_child(mi)
	add_child(doll)
	_doll = doll
	# colisão cápsula
	if not has_node("Col"):
		var col := CollisionShape3D.new()
		col.name = "Col"
		var sh := CapsuleShape3D.new()
		sh.radius = 0.25
		sh.height = 1.4
		col.shape = sh
		col.position.y = 0.9
		add_child(col)


func set_grid(g: MnGridMap) -> void:
	grid = g


func apply_appearance(gender: String, vector: Array) -> void:
	_ensure_visual()
	if _doll and _doll.has_method("apply_appearance"):
		_doll.apply_appearance(gender, vector)


func go_to_cell(target: Vector2i, run: bool = false) -> void:
	if grid == null:
		return
	running = run
	var from := grid.world_to_cell(global_position)
	path = grid.find_path(from, target, false)
	if path.size() > 0 and path[0] == from:
		path.pop_front()
	anim_state = "run" if run else "walk"


func go_to_world(pos: Vector3, run: bool = false) -> void:
	if grid == null:
		return
	go_to_cell(grid.world_to_cell(pos), run)


func _physics_process(delta: float) -> void:
	if path.is_empty():
		velocity = Vector3.ZERO
		anim_state = "idle"
		move_and_slide()
		return
	var next: Vector2i = path[0]
	var dest := grid.cell_to_world(next)
	var to := dest - global_position
	to.y = 0
	var dist := to.length()
	var speed := RUN_SPEED if running else WALK_SPEED
	if dist < 0.08:
		path.pop_front()
		if path.is_empty():
			arrived.emit()
		return
	velocity = to.normalized() * speed
	if to.length_squared() > 0.0001:
		look_at(global_position + to, Vector3.UP)
	move_and_slide()


func play_action_anim(logic_state: String) -> void:
	anim_state = MnAnimationMap.clip_for(logic_state)
