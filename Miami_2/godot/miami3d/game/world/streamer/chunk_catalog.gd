class_name MnChunkCatalog
extends RefCounted
## Lê world_map.json: âncoras, chunks, seams. Sem I/O de cena.

var path: String = ""
var doc: Dictionary = {}
var cell_size: float = 1.0
var chunk_size: Vector2i = Vector2i(64, 64)
var load_radius: int = 1
var unload_radius: int = 2
var mode_default: String = "discrete"

var anchors: Dictionary = {} # location_id -> Dictionary
var chunks_by_id: Dictionary = {} # chunk_id -> Dictionary
var chunks_by_coord: Dictionary = {} # "x,y" -> Dictionary
var seams: Dictionary = {} # "from>to" -> Dictionary


func _bootstrap() -> Node:
	var loop := Engine.get_main_loop() as SceneTree
	if loop == null or loop.root == null:
		return null
	return loop.root.get_node_or_null("/root/Bootstrap")


func load_map(map_path: String) -> Error:
	path = map_path
	if not FileAccess.file_exists(map_path):
		push_warning("world_map ausente: " + map_path)
		return ERR_FILE_NOT_FOUND
	var f := FileAccess.open(map_path, FileAccess.READ)
	if f == null:
		return ERR_CANT_OPEN
	var parsed = JSON.parse_string(f.get_as_text())
	f.close()
	if typeof(parsed) != TYPE_DICTIONARY:
		return ERR_PARSE_ERROR
	doc = parsed
	cell_size = float(doc.get("cell_size", 1.0))
	var cs: Array = doc.get("chunk_size", [64, 64])
	chunk_size = Vector2i(int(cs[0]), int(cs[1]) if cs.size() > 1 else int(cs[0]))
	load_radius = int(doc.get("load_radius", 1))
	unload_radius = int(doc.get("unload_radius", 2))
	mode_default = str(doc.get("mode_default", "discrete"))
	anchors = doc.get("anchors", {}).duplicate(true)
	chunks_by_id.clear()
	chunks_by_coord.clear()
	for ch in doc.get("chunks", []):
		var cid := str(ch.get("id", ""))
		chunks_by_id[cid] = ch
		var coord: Array = ch.get("coord", [0, 0])
		var key := "%d,%d" % [int(coord[0]), int(coord[1]) if coord.size() > 1 else 0]
		chunks_by_coord[key] = ch
	seams.clear()
	for s in doc.get("seams", []):
		var a := str(s.get("from", ""))
		var b := str(s.get("to", ""))
		if a == "" or b == "":
			continue
		seams["%s>%s" % [a, b]] = s
		seams["%s>%s" % [b, a]] = s
	return OK


func has_location(location_id: String) -> bool:
	return anchors.has(location_id)


func anchor(location_id: String) -> Dictionary:
	return anchors.get(location_id, {})


func is_outdoor(location_id: String) -> bool:
	var a: Dictionary = anchor(location_id)
	if a.is_empty():
		return false
	return bool(a.get("outdoor", false))


func origin_cell(location_id: String) -> Vector2i:
	var a: Dictionary = anchor(location_id)
	var o: Array = a.get("origin_cell", [0, 0])
	return Vector2i(int(o[0]), int(o[1]) if o.size() > 1 else 0)


func location_size(location_id: String) -> Vector2i:
	var a: Dictionary = anchor(location_id)
	if a.has("size"):
		var s: Array = a["size"]
		return Vector2i(int(s[0]), int(s[1]) if s.size() > 1 else int(s[0]))
	# fallback: content location grid se Bootstrap disponível.
	# Busca por caminho: o autoload não existe como identificador quando este
	# script roda fora do jogo (testes com --script não registram autoloads).
	var boot := _bootstrap()
	if boot != null and boot.get("game") != null:
		var loc: Dictionary = boot.game.get_content_location(location_id)
		var g: Dictionary = loc.get("grid", {})
		return Vector2i(int(g.get("width", 16)), int(g.get("height", 16)))
	return Vector2i(16, 16)


func chunk_of(location_id: String) -> Vector2i:
	var a: Dictionary = anchor(location_id)
	var c: Array = a.get("chunk", [0, 0])
	return Vector2i(int(c[0]), int(c[1]) if c.size() > 1 else 0)


func parent_outdoor(location_id: String) -> String:
	var a: Dictionary = anchor(location_id)
	if a.is_empty():
		return location_id
	if bool(a.get("outdoor", false)):
		return location_id
	var p := str(a.get("parent", ""))
	return p if p != "" else location_id


func chunk_at(coord: Vector2i) -> Dictionary:
	return chunks_by_coord.get("%d,%d" % [coord.x, coord.y], {})


func chunk_id_at(coord: Vector2i) -> String:
	var ch: Dictionary = chunk_at(coord)
	return str(ch.get("id", ""))


func locations_in_chunk(coord: Vector2i) -> Array:
	var ch: Dictionary = chunk_at(coord)
	return ch.get("locations", [])


func is_seam(from_id: String, to_id: String) -> bool:
	return seams.has("%s>%s" % [from_id, to_id])


func outdoor_at(global_cell: Vector2i) -> String:
	## Primeiro outdoor cujo retângulo contém a célula.
	for loc_id in anchors.keys():
		if not is_outdoor(str(loc_id)):
			continue
		var origin := origin_cell(str(loc_id))
		var sz := location_size(str(loc_id))
		if global_cell.x >= origin.x and global_cell.y >= origin.y \
				and global_cell.x < origin.x + sz.x and global_cell.y < origin.y + sz.y:
			return str(loc_id)
	return ""


func outdoor_location_ids() -> Array:
	var out: Array = []
	for loc_id in anchors.keys():
		if is_outdoor(str(loc_id)):
			out.append(str(loc_id))
	out.sort()
	return out


func validate_against_locations(known_locations: Dictionary) -> Array:
	## Retorna lista de erros (strings). Vazio = ok.
	var errs: Array = []
	for loc_id in anchors.keys():
		if not known_locations.has(str(loc_id)):
			errs.append("âncora sem location JSON: " + str(loc_id))
	for ch in doc.get("chunks", []):
		for loc in ch.get("locations", []):
			if not anchors.has(str(loc)):
				errs.append("chunk %s referencia local sem âncora: %s" % [ch.get("id"), loc])
			elif not is_outdoor(str(loc)):
				errs.append("chunk %s lista indoor: %s" % [ch.get("id"), loc])
	return errs
