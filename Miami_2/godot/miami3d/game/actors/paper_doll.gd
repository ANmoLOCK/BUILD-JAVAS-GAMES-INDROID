class_name MnPaperDoll
extends Node3D
## 5 slots modulares (head/hair/top/bottom/shoes) + tint.
## Usa MnAssetRegistry quando houver GLB; senão MnMeshFactory.

var vector: Array = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
var gender: String = "m"
var _assets: MnAssetRegistry

const PALETTE := [
	Color(0.92, 0.78, 0.66), Color(0.72, 0.52, 0.38), Color(0.45, 0.30, 0.20),
	Color(0.20, 0.15, 0.12), Color(0.95, 0.90, 0.85), Color(0.55, 0.40, 0.55),
]

const SLOT_NAMES := ["Head", "Hair", "Top", "Bottom", "Shoes"]
const SLOT_KEYS := ["head", "hair", "top", "bottom", "shoe"]


func ensure_parts() -> void:
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
	ensure_parts()
	# índices: [gênero, pele, cabelo, corCabelo, top, corTop, bottom, corBottom, calçado, corCalçado]
	var variants := [
		int(v[1]) if v.size() > 1 else 0, # head uses skin idx as variant stand-in
		int(v[2]) if v.size() > 2 else 0,
		int(v[4]) if v.size() > 4 else 0,
		int(v[6]) if v.size() > 6 else 0,
		int(v[8]) if v.size() > 8 else 0,
	]
	var colors := [
		int(v[1]) if v.size() > 1 else 0,
		int(v[3]) if v.size() > 3 else 0,
		int(v[5]) if v.size() > 5 else 0,
		int(v[7]) if v.size() > 7 else 0,
		int(v[9]) if v.size() > 9 else 0,
	]
	for i in SLOT_NAMES.size():
		_apply_slot(SLOT_NAMES[i], SLOT_KEYS[i], variants[i], colors[i])
	scale = Vector3(1.0, 1.02 if gender == "m" else 0.98, 1.0)


func swap_slot(slot: String, mesh_path: String, color_index: int) -> void:
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
	if _assets == null:
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
