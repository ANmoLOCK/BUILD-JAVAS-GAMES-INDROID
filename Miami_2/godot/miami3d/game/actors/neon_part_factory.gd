class_name MnNeonPartFactory
extends RefCounted
## Neon Nightlife em 3D real (GLB paper-doll). Sem billboard PNG como corpo.


static func build_character(root: Node3D, gender: String, vector: Array) -> void:
	_clear_generated(root)
	var is_f := gender == "f"
	var variants := {
		"Head": int(vector[1]) if vector.size() > 1 else 2,
		"Hair": int(vector[2]) if vector.size() > 2 else (10 if is_f else 8),
		"Top": int(vector[4]) if vector.size() > 4 else (18 if is_f else 12),
		"Bottom": int(vector[6]) if vector.size() > 6 else (8 if is_f else 10),
		"Shoes": int(vector[8]) if vector.size() > 8 else (9 if is_f else 6),
	}
	var keys := {
		"Head": "head",
		"Hair": "hair",
		"Top": "top",
		"Bottom": "bottom",
		"Shoes": "shoe",
	}
	var loaded := 0
	for slot_name in ["Head", "Hair", "Top", "Bottom", "Shoes"]:
		var key: String = keys[slot_name]
		var variant: int = int(variants[slot_name])
		var path := _resolve_part(key, gender, variant)
		var node: Node3D = MnMeshFactory.try_instance_scene(path)
		if node == null:
			# fallback procedural colored part
			node = MnMeshFactory.paper_doll_part(slot_name, _fallback_color(slot_name, is_f))
		else:
			loaded += 1
			# GLB root may be Node3D with MeshInstance child — normalize
			if not (node is MeshInstance3D):
				var mi := _first_mesh(node)
				if mi:
					var holder := Node3D.new()
					holder.name = slot_name
					# reparent mesh visual
					var dup := mi.duplicate() as MeshInstance3D
					dup.name = "Mesh"
					holder.add_child(dup)
					node.queue_free()
					node = holder
				node.name = slot_name
			else:
				node.name = slot_name
		node.set_meta("neon_slot", slot_name)
		root.add_child(node)

	# braços/pernas auxiliares para animação de caminhada (rig leve)
	_add_limb_helpers(root, is_f)

	# face flat no head (expressão) — pequeno quad, não corpo inteiro
	var face := Sprite3D.new()
	face.name = "FaceOverlay"
	face.billboard = BaseMaterial3D.BILLBOARD_DISABLED
	face.pixel_size = 0.0016
	face.position = Vector3(0, 1.62 if is_f else 1.66, 0.16)
	face.texture = _load_tex(MnNeonStyle.faces_tex())
	face.hframes = 6
	face.vframes = 2
	face.frame = 0 if not is_f else 6
	face.visible = face.texture != null
	root.add_child(face)

	# avarias
	var cond := Sprite3D.new()
	cond.name = "ConditionOverlay"
	cond.billboard = BaseMaterial3D.BILLBOARD_FIXED_Y
	cond.pixel_size = 0.0024
	cond.position = Vector3(0, 1.2, 0.2)
	cond.modulate = Color(1, 1, 1, 0.7)
	cond.texture = _load_tex(MnNeonStyle.avarias_tex())
	cond.hframes = 6
	cond.vframes = 1
	cond.visible = false
	root.add_child(cond)

	if gender != "f":
		var glasses := MnMeshFactory.box(Vector3(0.22, 0.035, 0.08), Color(0.05, 0.05, 0.05))
		glasses.name = "AccessoryGlasses"
		glasses.position = Vector3(0, 1.64, 0.15)
		root.add_child(glasses)

	print("[NeonPartFactory] gender=", gender, " glb_slots=", loaded, "/5")


static func _add_limb_helpers(root: Node3D, is_f: bool) -> void:
	var skin := MnNeonStyle.COL_SKIN_F if is_f else MnNeonStyle.COL_SKIN_M
	var arm_l := MnMeshFactory.box(Vector3(0.1, 0.42, 0.1), skin)
	arm_l.name = "ArmL"
	arm_l.position = Vector3(-0.32, 1.22, 0)
	root.add_child(arm_l)
	var arm_r := MnMeshFactory.box(Vector3(0.1, 0.42, 0.1), skin)
	arm_r.name = "ArmR"
	arm_r.position = Vector3(0.32, 1.22, 0)
	root.add_child(arm_r)


static func set_face(root: Node3D, gender: String, expr: int) -> void:
	var face := root.get_node_or_null("FaceOverlay") as Sprite3D
	if face == null:
		return
	var row := 1 if gender == "f" else 0
	face.frame = clampi(row * 6 + expr, 0, 11)


static func set_condition(root: Node3D, condition: String) -> void:
	var ov := root.get_node_or_null("ConditionOverlay") as Sprite3D
	if ov == null:
		return
	if condition == "" or not MnNeonStyle.CONDITION_ATLAS.has(condition):
		ov.visible = false
		return
	ov.frame = int(MnNeonStyle.CONDITION_ATLAS[condition])
	ov.visible = true


static func _clear_generated(root: Node3D) -> void:
	var names := [
		"NeonVolume", "BodyBillboard", "FaceOverlay", "ConditionOverlay",
		"AccessoryGlasses", "Head", "Hair", "Top", "Bottom", "Shoes", "ArmL", "ArmR",
	]
	for n in names:
		var c := root.get_node_or_null(n)
		if c:
			root.remove_child(c)
			c.free()


static func _resolve_part(key: String, gender: String, variant: int) -> String:
	## Variante pedida; se o GLB não existir, cai na variante disponível do mesmo gênero
	## (evita o personagem virar caixa colorida quando a aparência não é o preset Neon).
	var folder := _folder(key)
	var path := "res://assets/models/characters/%s/%s_%s_%02d.glb" % [folder, key, gender, variant]
	if ResourceLoader.exists(path) or FileAccess.file_exists(path):
		return path
	var dir := DirAccess.open("res://assets/models/characters/%s" % folder)
	if dir == null:
		return path
	var prefix := "%s_%s_" % [key, gender]
	dir.list_dir_begin()
	var fn := dir.get_next()
	var found := ""
	while fn != "":
		if not dir.current_is_dir() and fn.begins_with(prefix) and fn.ends_with(".glb"):
			found = "res://assets/models/characters/%s/%s" % [folder, fn]
			break
		fn = dir.get_next()
	dir.list_dir_end()
	return found if found != "" else path


static func _folder(key: String) -> String:
	match key:
		"head": return "heads"
		"hair": return "hair"
		"top": return "tops"
		"bottom": return "bottoms"
		"shoe": return "shoes"
		_: return key


static func _fallback_color(slot: String, is_f: bool) -> Color:
	match slot:
		"Head": return MnNeonStyle.COL_SKIN_F if is_f else MnNeonStyle.COL_SKIN_M
		"Hair": return MnNeonStyle.COL_HAIR
		"Top": return MnNeonStyle.COL_DRESS if is_f else MnNeonStyle.COL_BLAZER
		"Bottom": return MnNeonStyle.COL_DRESS if is_f else MnNeonStyle.COL_PANTS
		"Shoes": return MnNeonStyle.COL_HEEL if is_f else Color(0.05, 0.05, 0.05)
		_: return Color.WHITE


static func _first_mesh(n: Node) -> MeshInstance3D:
	if n is MeshInstance3D:
		return n as MeshInstance3D
	for c in n.get_children():
		var m := _first_mesh(c)
		if m:
			return m
	return null


static func _load_tex(path: String) -> Texture2D:
	if path == "" or not ResourceLoader.exists(path):
		return null
	return load(path) as Texture2D
