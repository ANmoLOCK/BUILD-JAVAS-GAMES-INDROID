class_name MnApartmentKit
extends RefCounted
## Kit fiel ao Miami LOW apartment: tiles + sprites iso originais (x4).

const MANIFEST_PATH := "res://assets/locations/player_apartment/manifest.json"

static var _cache: Dictionary = {}


static func manifest() -> Dictionary:
	if not _cache.is_empty():
		return _cache
	if not FileAccess.file_exists(MANIFEST_PATH):
		return {}
	var f := FileAccess.open(MANIFEST_PATH, FileAccess.READ)
	if f == null:
		return {}
	var data = JSON.parse_string(f.get_as_text())
	_cache = data if typeof(data) == TYPE_DICTIONARY else {}
	return _cache


static func tile_path(kind: String) -> String:
	var tiles: Dictionary = manifest().get("tiles", {})
	return str(tiles.get(kind, ""))


static func sprite_path_for_template(template: String) -> String:
	var m := manifest()
	var tmap: Dictionary = m.get("template_map", {})
	var item_id := str(tmap.get(template, template))
	var items: Dictionary = m.get("items", {})
	if not items.has(item_id):
		return ""
	var entry: Dictionary = items[item_id]
	var path := str(entry.get("x4", ""))
	if path != "" and (ResourceLoader.exists(path) or FileAccess.file_exists(path)):
		return path
	return str(entry.get("original", ""))


static func has_sprite(template: String) -> bool:
	var p := sprite_path_for_template(template)
	return p != "" and (ResourceLoader.exists(p) or FileAccess.file_exists(p))


static func make_sprite3d(template: String, footprint: Array = []) -> Sprite3D:
	var path := sprite_path_for_template(template)
	if path == "":
		return null
	var tex: Texture2D = load(path) as Texture2D
	if tex == null:
		return null
	var spr := Sprite3D.new()
	spr.name = "MiamiSprite"
	spr.texture = tex
	spr.centered = true
	spr.pixel_size = 0.012
	spr.billboard = BaseMaterial3D.BILLBOARD_DISABLED
	spr.shaded = false
	spr.alpha_cut = SpriteBase3D.ALPHA_CUT_DISCARD
	spr.texture_filter = BaseMaterial3D.TEXTURE_FILTER_NEAREST
	# apoia o sprite no chão (pé na célula)
	var h_px := float(tex.get_height())
	spr.position = Vector3(0.0, h_px * spr.pixel_size * 0.5, 0.0)
	# leve giro para alinhar iso 3/4 com câmera padrão (yaw 45°)
	spr.rotation_degrees = Vector3(0.0, 45.0, 0.0)
	if footprint.size() >= 2:
		var sx := float(footprint[0])
		var sz := float(footprint[1])
		# escala suave se o footprint for largo
		var span := maxf(sx, sz)
		if span > 1.5:
			spr.pixel_size = 0.012 * clampf(span / 2.0, 1.0, 1.6)
			spr.position.y = h_px * spr.pixel_size * 0.5
	return spr


static func apply_floor_material(mi: MeshInstance3D, bath: bool = false) -> void:
	var path := tile_path("bath" if bath else "floor")
	if path == "" or not ResourceLoader.exists(path):
		return
	var mat := StandardMaterial3D.new()
	mat.albedo_texture = load(path)
	mat.texture_filter = BaseMaterial3D.TEXTURE_FILTER_LINEAR_WITH_MIPMAPS
	mat.uv1_scale = Vector3(6.0, 6.0, 1.0)
	mi.material_override = mat


static func apply_wall_material(mi: MeshInstance3D) -> void:
	var path := tile_path("wall")
	if path == "" or not ResourceLoader.exists(path):
		return
	var mat := StandardMaterial3D.new()
	mat.albedo_texture = load(path)
	mat.texture_filter = BaseMaterial3D.TEXTURE_FILTER_LINEAR_WITH_MIPMAPS
	mat.uv1_scale = Vector3(2.0, 2.0, 1.0)
	mi.material_override = mat
