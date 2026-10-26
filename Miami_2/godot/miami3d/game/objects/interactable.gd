class_name MnInteractable
extends StaticBody3D
## Objeto do mundo: footprint visual + sinal de ações disponíveis.

signal chosen(actions: Array)

var object_id: String = ""
var template_id: String = ""
var item_def: Dictionary = {}
var action_ids: Array = []


func _ready() -> void:
	input_ray_pickable = true
	collision_layer = 2
	collision_mask = 0


func setup(oid: String, template: String, item: Dictionary, _obj: Dictionary) -> void:
	object_id = oid
	template_id = template
	item_def = item
	action_ids = item.get("actions", []).duplicate()
	# visual placeholder
	var fp: Array = item.get("footprint", [1, 1])
	var sx := float(fp[0]) if fp.size() > 0 else 1.0
	var sz := float(fp[1]) if fp.size() > 1 else 1.0
	var mi := MeshInstance3D.new()
	var box := BoxMesh.new()
	box.size = Vector3(maxf(0.4, sx * 0.85), 0.9, maxf(0.4, sz * 0.85))
	mi.mesh = box
	var mat := StandardMaterial3D.new()
	mat.albedo_color = _color_for(template)
	mi.material_override = mat
	mi.position.y = 0.45
	add_child(mi)
	var col := CollisionShape3D.new()
	var sh := BoxShape3D.new()
	sh.size = box.size
	col.shape = sh
	col.position.y = 0.45
	add_child(col)
	# rótulo
	var label := Label3D.new()
	label.text = oid
	label.font_size = 28
	label.position = Vector3(0, 1.2, 0)
	label.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	add_child(label)


func _color_for(t: String) -> Color:
	match t:
		"bed_standard", "sofa_basic": return Color(0.55, 0.35, 0.55)
		"shower", "toilet", "sink": return Color(0.55, 0.75, 0.85)
		"fridge", "kitchen": return Color(0.7, 0.7, 0.75)
		"closet", "phone", "plant": return Color(0.45, 0.55, 0.35)
		_: return Color(0.65, 0.55, 0.40)


func request_menu() -> void:
	chosen.emit(action_ids)
