class_name MnNpc
extends CharacterBody3D
## NPC: rotina simples, pathfinding na grade, paper-doll / cabeça única.

signal talked(npc_id: String)

const WALK_SPEED := 2.2

var npc_id: String = ""
var def: Dictionary = {}
var grid: MnGridMap
var path: Array[Vector2i] = []
var schedule_id: String = ""
var _doll: MnPaperDoll


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
	var gender := str(def.get("gender", "m"))
	var appearance: Array = def.get("appearance", [0, 0, 0, 0, 0, 0, 0, 0, 0, 0])
	if _doll:
		_doll.apply_appearance(gender, appearance)
		if def.get("essential", false) and not str(npc_id).begins_with("generic_"):
			_doll.apply_unique_head(npc_id)


func _build_visual() -> void:
	if has_node("Doll"):
		_doll = $Doll
		if Bootstrap.game and Bootstrap.game.get("assets") != null:
			_doll.bind_assets(Bootstrap.game.assets)
		return
	# remove mesh placeholder antigo se existir
	if has_node("Mesh"):
		$Mesh.queue_free()
	var doll := Node3D.new()
	doll.name = "Doll"
	doll.set_script(preload("res://game/actors/paper_doll.gd"))
	add_child(doll)
	_doll = doll
	_doll.ensure_parts()
	if Bootstrap.game and Bootstrap.game.get("assets") != null:
		_doll.bind_assets(Bootstrap.game.assets)
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
	if to.length() < 0.08:
		path.pop_front()
		return
	velocity = to.normalized() * WALK_SPEED
	if to.length_squared() > 0.0001:
		look_at(global_position + to, Vector3.UP)
	move_and_slide()
