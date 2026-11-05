class_name MnFurnitureSlot
extends Node3D
## Slot de móvel no apartamento: troca o item instalado.

signal changed(slot_id: String, item_id: String)

var slot_id: String = ""
var category: String = ""
var item_id: String = ""
var _visual: Node3D


func setup(def: Dictionary) -> void:
	slot_id = str(def.get("id", ""))
	category = str(def.get("category", ""))
	item_id = str(def.get("default", ""))
	_rebuild()


func place(new_item_id: String) -> void:
	## Preferir comando do cérebro; fallback visual se backend não tiver place_furniture.
	if Bootstrap.game and Bootstrap.game.has_method("place_furniture"):
		var r: Dictionary = Bootstrap.game.place_furniture(slot_id, new_item_id)
		if not bool(r.get("ok", false)):
			return
		item_id = str(r.get("item", new_item_id))
	else:
		item_id = new_item_id
		if Bootstrap.game and not Bootstrap.game.is_native and Bootstrap.game.home:
			Bootstrap.game.home.set_furniture(slot_id, item_id)
	_rebuild()
	changed.emit(slot_id, item_id)


func _rebuild() -> void:
	if _visual:
		_visual.queue_free()
		_visual = null
	if item_id == "":
		return
	var item: Dictionary = Bootstrap.game.get_content_item(item_id) if Bootstrap.game else {}
	var fp: Array = item.get("footprint", [1, 1])
	var h := 0.7
	if MnApartmentKit.has_sprite(item_id) or MnApartmentKit.has_sprite(category):
		var tmpl := item_id if MnApartmentKit.has_sprite(item_id) else category
		var spr := MnApartmentKit.make_sprite3d(tmpl, fp)
		if spr != null:
			add_child(spr)
			_visual = spr
			if spr.texture:
				h = maxf(0.5, float(spr.texture.get_height()) * spr.pixel_size)
	if _visual == null:
		var mi := MeshInstance3D.new()
		var box := BoxMesh.new()
		box.size = Vector3(float(fp[0]) * 0.9 if fp.size() > 0 else 0.9, 0.7, float(fp[1]) * 0.9 if fp.size() > 1 else 0.9)
		mi.mesh = box
		var mat := StandardMaterial3D.new()
		mat.albedo_color = Color(0.6, 0.4, 0.55)
		mi.material_override = mat
		mi.position.y = 0.35
		add_child(mi)
		_visual = mi
		h = 0.7
	# ações via interactable virtual
	var body := StaticBody3D.new()
	body.collision_layer = 2
	var col := CollisionShape3D.new()
	var sh := BoxShape3D.new()
	var sx := float(fp[0]) * 0.9 if fp.size() > 0 else 0.9
	var sz := float(fp[1]) * 0.9 if fp.size() > 1 else 0.9
	sh.size = Vector3(sx, h, sz)
	col.shape = sh
	col.position.y = h * 0.5
	body.add_child(col)
	body.set_meta("object_id", slot_id)
	body.set_meta("actions", item.get("actions", []))
	body.set_meta("is_furniture_slot", true)
	add_child(body)
