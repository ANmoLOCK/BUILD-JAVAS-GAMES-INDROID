class_name MnPaperDoll
extends Node3D
## 5 slots modulares + modo Neon Nightlife (Everwind 2D/3D) + avarias.

var vector: Array = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
var gender: String = "m"
var style_id: String = ""
var condition: String = ""
var _assets: MnAssetRegistry
var _neon: bool = false

const PALETTE := [
	Color(0.92, 0.78, 0.66), Color(0.72, 0.52, 0.38), Color(0.45, 0.30, 0.20),
	Color(0.20, 0.15, 0.12), Color(0.95, 0.90, 0.85), Color(0.55, 0.40, 0.55),
	Color(0.95, 0.22, 0.55), Color(0.25, 0.9, 0.95), Color(0.92, 0.18, 0.55),
]

const SLOT_NAMES := ["Head", "Hair", "Top", "Bottom", "Shoes"]
const SLOT_KEYS := ["head", "hair", "top", "bottom", "shoe"]


func ensure_parts() -> void:
	if _neon:
		return
	for i in SLOT_NAMES.size():
		if has_node(SLOT_NAMES[i]):
			continue
		var part := MnMeshFactory.paper_doll_part(SLOT_NAMES[i], PALETTE[0])
		add_child(part)


func bind_assets(reg: MnAssetRegistry) -> void:
	_assets = reg


func apply_appearance(p_gender: String, v: Array) -> void:
	gender = p_gender
	vector = v.duplicate()
	while vector.size() < 10:
		vector.append(0)
	_neon = MnNeonStyle.matches(gender, vector) or style_id == MnNeonStyle.STYLE_ID
	if _neon:
		style_id = MnNeonStyle.STYLE_ID
		MnNeonPartFactory.build_character(self, gender, vector)
		MnNeonPartFactory.set_condition(self, condition)
		scale = Vector3(1.0, 1.0, 1.0)
		return
	# limpa nós neon se trocou de estilo
	for n in ["NeonVolume", "BodyBillboard", "FaceOverlay", "ConditionOverlay", "AccessoryGlasses"]:
		var c := get_node_or_null(n)
		if c:
			c.queue_free()
	ensure_parts()
	var variants := [
		int(vector[1]),
		int(vector[2]),
		int(vector[4]),
		int(vector[6]),
		int(vector[8]),
	]
	var colors := [
		int(vector[1]),
		int(vector[3]),
		int(vector[5]),
		int(vector[7]),
		int(vector[9]),
	]
	for i in SLOT_NAMES.size():
		_apply_slot(SLOT_NAMES[i], SLOT_KEYS[i], variants[i], colors[i])
	scale = Vector3(1.0, 1.02 if gender == "m" else 0.98, 1.0)


func apply_neon_preset(p_gender: String) -> void:
	style_id = MnNeonStyle.STYLE_ID
	apply_appearance(p_gender, MnNeonStyle.preset_vector(p_gender))


func set_face_expression(expr: int) -> void:
	if _neon:
		MnNeonPartFactory.set_face(self, gender, expr)


func set_condition(cond: String) -> void:
	condition = cond
	if _neon:
		MnNeonPartFactory.set_condition(self, cond)
	else:
		# tint leve no corpo clássico
		var top := _slot("Top")
		if top and cond == MnNeonStyle.CONDITION_DIRTY:
			_tint(top, 2)
		elif top and cond == MnNeonStyle.CONDITION_BRUISED:
			_tint(top, 5)


func refresh_conditions_from_game() -> void:
	var tree := Engine.get_main_loop() as SceneTree
	if tree == null:
		return
	var boot = tree.root.get_node_or_null("Bootstrap")
	if boot == null or boot.get("game") == null:
		return
	var g = boot.game
	if g == null or not bool(g.get("ready")):
		return
	var hygiene := 70
	var energy := 70
	if g.has_method("get_stat"):
		hygiene = int(g.get_stat("hygiene"))
		energy = int(g.get_stat("energy"))
	var wet := false
	var fight := false
	if not bool(g.get("is_native")) and g.get("backend") != null:
		var world = g.backend.get("world")
		if world != null and world.get("flags") != null:
			wet = bool(world.flags.get("wet", false))
			fight = bool(world.flags.get("in_fight", false))
	set_condition(MnNeonStyle.condition_from_stats(hygiene, energy, fight, wet))


func swap_slot(slot: String, mesh_path: String, color_index: int) -> void:
	if _neon:
		return
	var node := _slot(slot.capitalize())
	if node == null:
		return
	if mesh_path != "" and ResourceLoader.exists(mesh_path):
		var inst := MnMeshFactory.try_instance_scene(mesh_path)
		if inst:
			node.queue_free()
			inst.name = slot.capitalize()
			add_child(inst)
			node = inst if inst is MeshInstance3D else _slot(slot.capitalize())
	_tint(node as MeshInstance3D, color_index)


func apply_unique_head(npc_id: String) -> void:
	if _assets == null or _neon:
		return
	var path := _assets.npc_head_path(npc_id)
	swap_slot("Head", path, int(vector[1]) if vector.size() > 1 else 0)


func _apply_slot(node_name: String, key: String, variant: int, color_idx: int) -> void:
	var node := _slot(node_name)
	if node == null:
		return
	if _assets:
		var path := _assets.part_path(key, gender, clampi(variant, 0, 30))
		if _assets.has_real_mesh(path):
			var inst := MnMeshFactory.try_instance_scene(path)
			if inst:
				var pos := node.position
				node.queue_free()
				inst.name = node_name
				if inst is Node3D:
					(inst as Node3D).position = pos
				add_child(inst)
				node = _slot(node_name)
	_tint(node, color_idx)


func _slot(n: String) -> MeshInstance3D:
	return get_node_or_null(n) as MeshInstance3D


func _tint(mi: MeshInstance3D, idx: int) -> void:
	if mi == null:
		return
	var mat := StandardMaterial3D.new()
	mat.albedo_color = PALETTE[clampi(idx, 0, PALETTE.size() - 1)]
	mi.material_override = mat
