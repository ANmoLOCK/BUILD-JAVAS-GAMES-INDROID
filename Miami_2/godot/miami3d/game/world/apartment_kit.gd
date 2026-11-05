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


## Altura no mundo (metros) de cada peça — mantém a proporção iso sem gigantismo.
const WORLD_HEIGHT := {
	"bed_standard": 1.3,
	"sofa_basic": 1.3,
	"sofa_curved": 1.3,
	"chair": 1.0,
	"tv": 1.0,
	"fridge": 1.8,
	"stove": 1.0,
	"kitchen_cabinet": 1.1,
	"closet": 1.9,
	"shower": 2.0,
	"toilet": 0.85,
	"sink": 1.0,
	"table": 0.85,
	"glass_table": 0.6,
	"plant": 1.0,
	"shelf": 1.9,
	"window": 1.3,
	"poster": 0.6,
	"door": 2.0,
	"railing": 1.0,
	"mirror": 0.9,
	"computer": 0.7,
	"phone": 0.35,
	"wall_tile_sheet": 1.0,
}
const DEFAULT_HEIGHT := 1.0


static func world_height(template: String) -> float:
	var m := manifest()
	var tmap: Dictionary = m.get("template_map", {})
	var item_id := str(tmap.get(template, template))
	return float(WORLD_HEIGHT.get(item_id, DEFAULT_HEIGHT))


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
	spr.shaded = false
	spr.alpha_cut = SpriteBase3D.ALPHA_CUT_DISCARD
	spr.texture_filter = BaseMaterial3D.TEXTURE_FILTER_NEAREST
	# sempre de frente para a câmera no eixo Y: o iso continua legível nas 4 rotações
	spr.billboard = BaseMaterial3D.BILLBOARD_FIXED_Y

	var h_px := maxf(1.0, float(tex.get_height()))
	var target_h := world_height(template)
	# peças largas ganham um pouco de altura para não ficarem estreitas demais
	if footprint.size() >= 2:
		var span := maxf(float(footprint[0]), float(footprint[1]))
		if span > 1.5:
			target_h *= clampf(span / 2.0, 1.0, 1.35)
	spr.pixel_size = target_h / h_px
	spr.position = Vector3(0.0, target_h * 0.5, 0.0)
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
