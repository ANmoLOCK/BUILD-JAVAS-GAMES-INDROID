class_name MnInteractable
extends StaticBody3D
## Objeto do mundo: mesh via AssetRegistry / MeshFactory + menu de ações.

signal chosen(actions: Array)

var object_id: String = ""
var template_id: String = ""
var item_def: Dictionary = {}
var action_ids: Array = []

const LABEL_RANGE := 3.0

var _label: Label3D
var _label_timer: float = 0.0


func _ready() -> void:
	input_ray_pickable = true
	collision_layer = 2
	collision_mask = 0


func _process(delta: float) -> void:
	## Mostra o nome só quando o jogador está perto (cena limpa de longe).
	if _label == null:
		return
	_label_timer -= delta
	if _label_timer > 0.0:
		return
	_label_timer = 0.2
	var player := get_tree().get_first_node_in_group("player") as Node3D
	if player == null:
		return
	_label.visible = global_position.distance_to(player.global_position) <= LABEL_RANGE


func setup(oid: String, template: String, item: Dictionary, _obj: Dictionary) -> void:
	object_id = oid
	template_id = template
	item_def = item
	action_ids = item.get("actions", []).duplicate()
	var fp: Array = item.get("footprint", [1, 1])
	var sx := float(fp[0]) if fp.size() > 0 else 1.0
	var sz := float(fp[1]) if fp.size() > 1 else 1.0

	var visual: Node3D = null
	var h := 0.9
	# Apartamento: sprites iso originais Miami (2D/3D híbrido real)
	if MnApartmentKit.has_sprite(template):
		var spr := MnApartmentKit.make_sprite3d(template, fp)
		if spr != null:
			visual = spr
			if spr.texture:
				h = maxf(0.5, float(spr.texture.get_height()) * spr.pixel_size)

	if visual == null:
		var mesh_path := ""
		if Bootstrap.game and Bootstrap.game.get("assets") != null:
			mesh_path = Bootstrap.game.assets.item_mesh_path(template, str(item.get("mesh", "")))
			if Bootstrap.game.assets.has_real_mesh(mesh_path):
				visual = MnMeshFactory.try_instance_scene(mesh_path)

	if visual == null:
		visual = MnMeshFactory.item_visual(template, fp, _color_for(template))
		if visual is MeshInstance3D and (visual as MeshInstance3D).mesh is BoxMesh:
			h = ((visual as MeshInstance3D).mesh as BoxMesh).size.y
	else:
		visual.name = "Visual"
	add_child(visual)

	var col := CollisionShape3D.new()
	var sh := BoxShape3D.new()
	sh.size = Vector3(maxf(0.4, sx * 0.85), h, maxf(0.4, sz * 0.85))
	col.shape = sh
	col.position.y = h * 0.5
	add_child(col)

	var label := Label3D.new()
	label.name = "NameLabel"
	label.text = _display_name(oid)
	label.font_size = 22
	label.modulate = Color(1, 1, 1, 0.8)
	label.outline_size = 6
	label.position = Vector3(0, h + 0.25, 0)
	label.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	# rótulo só aparece com o jogador por perto (não poluir a cena)
	label.visible = false
	add_child(label)
	_label = label


func _display_name(fallback: String) -> String:
	var raw := str(item_def.get("name", fallback))
	if raw.begins_with("@") and Bootstrap.game and Bootstrap.game.get("strings") != null:
		return Bootstrap.game.strings.resolve(raw)
	return raw


func _color_for(t: String) -> Color:
	match t:
		"bed_standard", "sofa_basic": return Color(0.55, 0.35, 0.55)
		"shower", "toilet", "sink": return Color(0.55, 0.75, 0.85)
		"fridge", "kitchen": return Color(0.7, 0.7, 0.75)
		"closet", "phone", "plant", "palm_tree": return Color(0.25, 0.55, 0.3)
		"car_parked": return Color(0.15, 0.35, 0.75)
		"street_lamp": return Color(0.4, 0.4, 0.45)
		"newsstand", "shop_sign": return Color(0.85, 0.55, 0.2)
		"hydrant": return Color(0.85, 0.15, 0.12)
		_: return Color(0.65, 0.55, 0.40)


func request_menu() -> void:
	chosen.emit(action_ids)
