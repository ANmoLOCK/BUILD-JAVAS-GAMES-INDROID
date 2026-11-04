class_name MnPlayer
extends CharacterBody3D
## Jogador: tap-to-move, paper-doll Neon Nightlife, animações MnAnimationMap.

signal arrived
signal tapped_interactable(node)

const WALK_SPEED := 3.0
const RUN_SPEED := 6.0

var grid: MnGridMap
var path: Array[Vector2i] = []
var running: bool = false
var anim_state: String = "idle"
var _doll: MnPaperDoll
var _anim: MnAnimController
var _cond_tick: float = 0.0


func _ready() -> void:
	add_to_group("player")
	collision_layer = 1
	collision_mask = 1
	_ensure_visual()
	_ensure_anim()


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


func _ensure_anim() -> void:
	if _anim != null:
		return
	_anim = MnAnimController.new()
	_anim.name = "AnimController"
	add_child(_anim)
	if _doll:
		_anim.bind(_doll, _doll.gender if _doll else "m")
		_anim.set_face_callback(func(expr: int):
			if _doll:
				_doll.set_face_expression(expr)
		)
	_anim.play("idle")


func _bind_assets() -> void:
	if _doll and Bootstrap.game and Bootstrap.game.get("assets") != null:
		_doll.bind_assets(Bootstrap.game.assets)


func set_grid(g: MnGridMap) -> void:
	grid = g


func apply_appearance(gender: String, vector: Array) -> void:
	_ensure_visual()
	_ensure_anim()
	if vector.is_empty():
		vector = MnNeonStyle.preset_vector(gender)
	if _doll and _doll.has_method("apply_appearance"):
		_doll.apply_appearance(gender, vector)
	if _anim:
		_anim.bind(_doll, gender)
		_anim.play(anim_state)
	if _doll:
		_doll.refresh_conditions_from_game()


func go_to_cell(target: Vector2i, run: bool = false) -> void:
	if grid == null:
		return
	running = run
	var from := grid.world_to_cell(global_position)
	path = grid.find_path(from, target, false)
	if path.size() > 0 and path[0] == from:
		path.pop_front()
	_set_anim("run" if run else "walk")


func go_to_world(pos: Vector3, run: bool = false) -> void:
	if grid == null:
		return
	go_to_cell(grid.world_to_cell(pos), run)


func _physics_process(delta: float) -> void:
	_cond_tick += delta
	if _cond_tick > 2.5:
		_cond_tick = 0.0
		if _doll:
			_doll.refresh_conditions_from_game()
	if path.is_empty():
		velocity = Vector3.ZERO
		if anim_state in ["walk", "run"]:
			_set_anim("idle")
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
			_set_anim("idle")
		return
	velocity = to.normalized() * speed
	if to.length_squared() > 0.0001:
		look_at(global_position + to, Vector3.UP)
	move_and_slide()


func play_action_anim(logic_state: String) -> void:
	_set_anim(MnAnimationMap.clip_for(logic_state))


func refresh_visual_conditions() -> void:
	if _doll and _doll.has_method("refresh_conditions_from_game"):
		_doll.refresh_conditions_from_game()


func _set_anim(clip: String) -> void:
	anim_state = clip
	_ensure_anim()
	if _anim:
		_anim.play(clip)
