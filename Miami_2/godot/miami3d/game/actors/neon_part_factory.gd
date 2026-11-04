class_name MnNeonPartFactory
extends RefCounted
## Monta malhas 3D estilizadas + billboard 2D Everwind para Neon Nightlife.


static func build_character(root: Node3D, gender: String, _vector: Array) -> void:
	_clear_generated(root)
	var is_f := gender == "f"
	var skin := MnNeonStyle.COL_SKIN_F if is_f else MnNeonStyle.COL_SKIN_M

	# silhueta 3D (sombra / volume)
	var body := _capsule(1.05 if is_f else 1.15, 0.18 if is_f else 0.2, skin.darkened(0.15))
	body.name = "NeonVolume"
	body.position = Vector3(0, 0.95 if is_f else 1.0, 0)
	body.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_ON
	root.add_child(body)

	# billboard 2D principal (Everwind)
	var bill := Sprite3D.new()
	bill.name = "BodyBillboard"
	bill.billboard = BaseMaterial3D.BILLBOARD_FIXED_Y
	bill.pixel_size = 0.00335
	bill.shaded = true
	bill.alpha_cut = SpriteBase3D.ALPHA_CUT_OPAQUE_PREPASS
	bill.position = Vector3(0, 1.05, 0.02)
	bill.texture = _load_tex(MnNeonStyle.body_tex(gender))
	bill.modulate = Color(1, 1, 1, 1)
	root.add_child(bill)

	# face atlas overlay (expressões)
	var face := Sprite3D.new()
	face.name = "FaceOverlay"
	face.billboard = BaseMaterial3D.BILLBOARD_FIXED_Y
	face.pixel_size = 0.0022
	face.position = Vector3(0, 1.58 if is_f else 1.62, 0.06)
	face.shaded = false
	face.texture = _load_tex(MnNeonStyle.faces_tex())
	face.hframes = 6
	face.vframes = 2
	face.frame = 0 if not is_f else 6
	face.visible = face.texture != null
	root.add_child(face)

	# avarias overlay
	var cond := Sprite3D.new()
	cond.name = "ConditionOverlay"
	cond.billboard = BaseMaterial3D.BILLBOARD_FIXED_Y
	cond.pixel_size = 0.0028
	cond.position = Vector3(0, 1.15, 0.08)
	cond.modulate = Color(1, 1, 1, 0.75)
	cond.texture = _load_tex(MnNeonStyle.avarias_tex())
	cond.hframes = 6
	cond.vframes = 1
	cond.visible = false
	root.add_child(cond)

	# peças 3D coloridas (paper-doll legível mesmo sem textura)
	_add_slot_meshes(root, is_f, skin)

	# acessório neon M: óculos
	if not is_f:
		var glasses := MnMeshFactory.box(Vector3(0.22, 0.04, 0.08), Color(0.05, 0.05, 0.05))
		glasses.name = "AccessoryGlasses"
		glasses.position = Vector3(0, 1.58, 0.14)
		root.add_child(glasses)


static func _add_slot_meshes(root: Node3D, is_f: bool, skin: Color) -> void:
	var head := MnMeshFactory.sphere(0.15, skin)
	head.name = "Head"
	head.position = Vector3(0, 1.58 if is_f else 1.62, -0.02)
	head.visible = false # face billboard cobre
	root.add_child(head)

	var hair_c := MnNeonStyle.COL_HAIR
	var hair := MnMeshFactory.box(Vector3(0.3, 0.14 if is_f else 0.12, 0.28), hair_c)
	hair.name = "Hair"
	hair.position = Vector3(0, 1.72 if is_f else 1.74, -0.02)
	hair.visible = false
	root.add_child(hair)

	var top: MeshInstance3D
	if is_f:
		top = MnMeshFactory.box(Vector3(0.42, 0.55, 0.22), MnNeonStyle.COL_DRESS)
		top.position = Vector3(0, 1.12, -0.02)
	else:
		top = MnMeshFactory.box(Vector3(0.48, 0.52, 0.26), MnNeonStyle.COL_BLAZER)
		top.position = Vector3(0, 1.18, -0.02)
	top.name = "Top"
	top.visible = false
	root.add_child(top)

	var bottom: MeshInstance3D
	if is_f:
		bottom = MnMeshFactory.box(Vector3(0.38, 0.35, 0.2), MnNeonStyle.COL_DRESS.darkened(0.05))
		bottom.position = Vector3(0, 0.62, -0.02)
	else:
		bottom = MnMeshFactory.box(Vector3(0.4, 0.5, 0.24), MnNeonStyle.COL_PANTS)
		bottom.position = Vector3(0, 0.62, -0.02)
	bottom.name = "Bottom"
	bottom.visible = false
	root.add_child(bottom)

	var shoes_c := MnNeonStyle.COL_HEEL if is_f else Color(0.05, 0.05, 0.05)
	var shoes := MnMeshFactory.box(Vector3(0.32, 0.1 if is_f else 0.12, 0.38), shoes_c)
	shoes.name = "Shoes"
	shoes.position = Vector3(0, 0.1, 0.02)
	shoes.visible = false
	root.add_child(shoes)


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
	for n in [
		"NeonVolume", "BodyBillboard", "FaceOverlay", "ConditionOverlay",
		"AccessoryGlasses", "Head", "Hair", "Top", "Bottom", "Shoes",
	]:
		var c := root.get_node_or_null(n)
		if c:
			root.remove_child(c)
			c.free()


static func _capsule(height: float, radius: float, color: Color) -> MeshInstance3D:
	return MnMeshFactory.capsule(height, radius, color)


static func _load_tex(path: String) -> Texture2D:
	if path == "" or not ResourceLoader.exists(path):
		return null
	return load(path) as Texture2D
