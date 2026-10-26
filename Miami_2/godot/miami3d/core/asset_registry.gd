class_name MnAssetRegistry
extends RefCounted
## Resolve paths de assets. GLB/OGG reais quando existirem; senão placeholder / procedural.

const ROOT := "res://assets"
const PLACEHOLDER_GLB := "res://assets/models/_shared/placeholder.glb"

var root_manifest: Dictionary = {}
var characters: Dictionary = {}
var furniture: Dictionary = {}
var props: Dictionary = {}
var pets: Dictionary = {}
var kits: Dictionary = {}
var animations: Dictionary = {}
var ui: Dictionary = {}
var ready: bool = false


func boot(assets_dir: String = ROOT) -> Error:
	root_manifest = _read_dict(assets_dir.path_join("manifest.json"))
	characters = _read_dict(assets_dir.path_join("models/characters/manifest.json"))
	furniture = _index_entries(_read_dict(assets_dir.path_join("models/furniture/manifest.json")))
	props = _index_entries(_read_dict(assets_dir.path_join("models/props/manifest.json")))
	pets = _index_entries(_read_dict(assets_dir.path_join("models/pets/manifest.json")))
	kits = _read_dict(assets_dir.path_join("models/kits/manifest.json"))
	animations = _read_dict(assets_dir.path_join("animations/anims_human.manifest.json"))
	ui = _read_dict(assets_dir.path_join("ui/manifest.json"))
	ready = true
	return OK


func summary() -> Dictionary:
	return root_manifest.get("counts", {})


func rig_path() -> String:
	return str(characters.get("rig", "res://assets/models/characters/rig_human.glb"))


func part_path(slot: String, gender: String, variant: int) -> String:
	## slot: head|hair|top|bottom|shoe  (aceita plurais do manifest)
	var folder := _slot_folder(slot)
	var prefix := _slot_prefix(slot)
	var path := "res://assets/models/characters/%s/%s_%s_%02d.glb" % [folder, prefix, gender, variant]
	return resolve_mesh(path)


func npc_head_path(npc_id: String) -> String:
	return resolve_mesh("res://assets/models/npc_unique/%s.glb" % npc_id)


func item_mesh_path(item_id: String, content_mesh: String = "") -> String:
	if furniture.has(item_id):
		return resolve_mesh(str(furniture[item_id].get("path", "")))
	if props.has(item_id):
		return resolve_mesh(str(props[item_id].get("path", "")))
	if content_mesh != "" and ResourceLoader.exists(content_mesh):
		return content_mesh
	if content_mesh != "":
		return resolve_mesh(content_mesh)
	return resolve_mesh("res://assets/models/props/%s.glb" % item_id)


func pet_mesh_path(pet_id: String) -> String:
	if pets.has(pet_id):
		return resolve_mesh(str(pets[pet_id].get("path", "")))
	return resolve_mesh("res://assets/models/pets/%s.glb" % pet_id)


func kit_piece_path(location_id: String, piece: String) -> String:
	return resolve_mesh("res://assets/models/kits/%s/%s.glb" % [location_id, piece])


func kit_texture(location_id: String, kind: String = "albedo") -> String:
	var path := "res://assets/textures/kits/%s/%s.png" % [location_id, kind]
	if ResourceLoader.exists(path):
		return path
	return "res://assets/textures/shared/grid.png"


func anim_library_path() -> String:
	return str(animations.get("library", "res://assets/animations/anims_human.glb"))


func anim_clips() -> Array:
	return animations.get("clips", [])


func hud_icon(stat_id: String) -> String:
	var path := "res://assets/ui/hud/%s.png" % stat_id
	if ResourceLoader.exists(path):
		return path
	return ""


func resolve_mesh(path: String) -> String:
	if path != "" and ResourceLoader.exists(path):
		return path
	# stub.json ao lado?
	var stub := path.replace(".glb", ".stub.json")
	if stub.begins_with("res://") and FileAccess.file_exists(stub):
		var data = _read_dict(stub)
		var fb := str(data.get("fallback", PLACEHOLDER_GLB))
		if ResourceLoader.exists(fb):
			return fb
	if ResourceLoader.exists(PLACEHOLDER_GLB):
		return PLACEHOLDER_GLB
	return ""


func has_real_mesh(path: String) -> bool:
	return path != "" and path != PLACEHOLDER_GLB and ResourceLoader.exists(path) and not path.ends_with("placeholder.glb")


func _slot_folder(slot: String) -> String:
	match slot:
		"head", "heads": return "heads"
		"hair": return "hair"
		"top", "tops": return "tops"
		"bottom", "bottoms": return "bottoms"
		"shoe", "shoes": return "shoes"
		_: return slot


func _slot_prefix(slot: String) -> String:
	match slot:
		"head", "heads": return "head"
		"hair": return "hair"
		"top", "tops": return "top"
		"bottom", "bottoms": return "bottom"
		"shoe", "shoes": return "shoe"
		_: return slot


func _index_entries(doc: Dictionary) -> Dictionary:
	var out := {}
	for e in doc.get("entries", []):
		out[str(e.get("id", ""))] = e
	return out


func _read_dict(path: String) -> Dictionary:
	if not FileAccess.file_exists(path):
		return {}
	var f := FileAccess.open(path, FileAccess.READ)
	if f == null:
		return {}
	var data = JSON.parse_string(f.get_as_text())
	return data if typeof(data) == TYPE_DICTIONARY else {}
