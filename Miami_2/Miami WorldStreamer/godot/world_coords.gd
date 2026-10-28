class_name MnWorldCoords
extends RefCounted
## Conversão location_id + célula local ↔ coords globais / chunk.
## Usado pelo WorldStreamer; o cérebro continua só com location_id + cell.

var catalog: MnChunkCatalog


func setup(p_catalog: MnChunkCatalog) -> void:
	catalog = p_catalog


func is_outdoor(location_id: String) -> bool:
	if catalog == null:
		return false
	return catalog.is_outdoor(location_id)


func origin_cell(location_id: String) -> Vector2i:
	if catalog == null:
		return Vector2i.ZERO
	return catalog.origin_cell(location_id)


func local_to_global(location_id: String, local: Vector2i) -> Vector2i:
	return origin_cell(location_id) + local


func global_to_local(location_id: String, global_cell: Vector2i) -> Vector2i:
	return global_cell - origin_cell(location_id)


func global_to_world(global_cell: Vector2i) -> Vector3:
	var cs := 1.0
	if catalog:
		cs = catalog.cell_size
	return Vector3((global_cell.x + 0.5) * cs, 0.0, (global_cell.y + 0.5) * cs)


func world_to_global(pos: Vector3) -> Vector2i:
	var cs := 1.0
	if catalog:
		cs = catalog.cell_size
	return Vector2i(int(floor(pos.x / cs)), int(floor(pos.z / cs)))


func chunk_of_global(global_cell: Vector2i) -> Vector2i:
	if catalog == null:
		return Vector2i.ZERO
	var sz: Vector2i = catalog.chunk_size
	return Vector2i(
		int(floor(float(global_cell.x) / float(sz.x))),
		int(floor(float(global_cell.y) / float(sz.y)))
	)


func chunk_of_location(location_id: String) -> Vector2i:
	if catalog == null:
		return Vector2i.ZERO
	return catalog.chunk_of(location_id)


func location_at_global(global_cell: Vector2i) -> String:
	## Outdoor cujo bounding box contém a célula; indoor ignora.
	if catalog == null:
		return ""
	return catalog.outdoor_at(global_cell)


func parent_outdoor(location_id: String) -> String:
	if catalog == null:
		return location_id
	return catalog.parent_outdoor(location_id)
