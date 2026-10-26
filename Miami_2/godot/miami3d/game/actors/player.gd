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
		if _doll.has_method("ensure_parts"):
			_doll.ensure_parts()
		_bind_assets()
		return
	var doll := Node3D.new()
	doll.name = "PaperDoll"
	doll.set_script(preload("res://game/actors/paper_doll.gd"))
	add_child(doll)
	_doll = doll
	_doll.ensure_parts()
	_bind_assets()
	if not has_node("Col"):
		var col := CollisionShape3D.new()
		col.name = "Col"
		var sh := CapsuleShape3D.new()
		sh.radius = 0.25
		sh.height = 1.4
		col.shape = sh
		col.position.y = 0.9
		add_child(col)


func _bind_assets() -> void:
	if _doll and Bootstrap.game and Bootstrap.game.get("assets") != null:
		_doll.bind_assets(Bootstrap.game.assets)


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


func _physics_process(_delta: float) -> void:
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
