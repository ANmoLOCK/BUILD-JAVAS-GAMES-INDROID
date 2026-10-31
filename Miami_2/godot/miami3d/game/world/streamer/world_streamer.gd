class_name MnWorldStreamer
extends Node3D
## Streaming por chunks: carrega quarteirões perto do player na cidade contínua.
## Opt-in — o modo discrete (MnLocationController) continua o default.

signal chunk_loaded(chunk_id: String)
signal chunk_unloaded(chunk_id: String)
signal focus_changed(location_id: String)
signal portal_used(to_location: String, spawn_id: String)
signal object_chosen(object_id: String, actions: Array)
signal zone_changed(tag: String)
signal composite_ready(location_id: String)

const MAP_PATH := "res://content/world_streamer/world_map.json"

var catalog := MnChunkCatalog.new()
var coords := MnWorldCoords.new()
var composite := MnGridMap.new()
var active: bool = false
var focus_location_id: String = ""
var loaded_chunks: Dictionary = {} # chunk_id -> Node3D (holder)
var location_views: Dictionary = {} # location_id -> MnChunkView
var _location_refs: Dictionary = {} # location_id -> int (refcount entre chunks)

var _bounds_min: Vector2i = Vector2i.ZERO
var _bounds_max: Vector2i = Vector2i.ZERO


func setup(map_path: String = MAP_PATH) -> Error:
	var err := catalog.load_map(map_path)
	coords.setup(catalog)
	_recompute_bounds()
	_rebuild_composite_empty()
	return err


func is_ready_map() -> bool:
	return not catalog.doc.is_empty()


func activate() -> void:
	active = true
	visible = true


func deactivate() -> void:
	active = false
	clear_all()
	visible = false


func clear_all() -> void:
	for cid in loaded_chunks.keys():
		_unload_chunk(str(cid))
	loaded_chunks.clear()
	location_views.clear()
	_location_refs.clear()
	focus_location_id = ""
	_rebuild_composite_empty()


func focus_location(location_id: String, spawn_id: String = "") -> void:
	if not active:
		return
	var outdoor := coords.parent_outdoor(location_id) if not coords.is_outdoor(location_id) else location_id
	if not catalog.has_location(outdoor):
		push_warning("streamer: local sem âncora " + outdoor)
		return
	focus_location_id = outdoor
	var chunk := coords.chunk_of_location(outdoor)
	stream_around(chunk)
	_place_player(outdoor, spawn_id if location_id == outdoor else "", location_id)
	focus_changed.emit(outdoor)
	composite_ready.emit(outdoor)


func ensure_location(location_id: String) -> void:
	var outdoor := coords.parent_outdoor(location_id) if not coords.is_outdoor(location_id) else location_id
	var chunk := coords.chunk_of_location(outdoor)
	stream_around(chunk)


func stream_around(center_chunk: Vector2i) -> void:
	var want: Dictionary = {}
	var r := catalog.load_radius
	for dy in range(-r, r + 1):
		for dx in range(-r, r + 1):
			var c := Vector2i(center_chunk.x + dx, center_chunk.y + dy)
			var ch: Dictionary = catalog.chunk_at(c)
			if ch.is_empty():
				continue
			var cid := str(ch.get("id", ""))
			want[cid] = c
			if not loaded_chunks.has(cid):
				_load_chunk(cid, c)
	# unload longe
	var ur := catalog.unload_radius
	var to_drop: Array = []
	for cid in loaded_chunks.keys():
		var holder: Node = loaded_chunks[cid]
		var coord: Vector2i = holder.get_meta("chunk_coord") as Vector2i
		var dist := maxi(absi(coord.x - center_chunk.x), absi(coord.y - center_chunk.y))
		if dist > ur and not want.has(cid):
			to_drop.append(cid)
	for cid2 in to_drop:
		_unload_chunk(str(cid2))
	_rebuild_composite_from_views()


func update_from_player_world(pos: Vector3) -> void:
	if not active:
		return
	var gcell := coords.world_to_global(pos)
	var chunk := coords.chunk_of_global(gcell)
	stream_around(chunk)
	var at := coords.location_at_global(gcell)
	if at != "" and at != focus_location_id:
		focus_location_id = at
		focus_changed.emit(at)


func place_player_at(location_id: String, spawn_id: String = "") -> void:
	_place_player(location_id, spawn_id, location_id)


func get_composite_grid() -> MnGridMap:
	return composite


func is_outdoor_seam(from_id: String, to_id: String) -> bool:
	## Em stream, qualquer outdoor→outdoor é costura (sem unload total).
	if not coords.is_outdoor(from_id) or not coords.is_outdoor(to_id):
		return false
	return true


func _place_player(outdoor_id: String, spawn_id: String, _requested: String) -> void:
	var player := get_tree().get_first_node_in_group("player") as Node3D
	if player == null:
		return
	var local := Vector2i.ZERO
	var def: Dictionary = Bootstrap.game.get_content_location(outdoor_id) if Bootstrap.game else {}
	if spawn_id != "" and def.has("spawns"):
		var sps: Dictionary = def["spawns"]
		if sps.has(spawn_id):
			var sp: Dictionary = sps[spawn_id]
			var ca: Array = sp.get("cell", [0, 0])
			local = Vector2i(int(ca[0]), int(ca[1]))
	elif def.has("spawn"):
		var sp2: Dictionary = def["spawn"]
		var ca2: Array = sp2.get("cell", [0, 0])
		local = Vector2i(int(ca2[0]), int(ca2[1]))
	elif Bootstrap.game:
		local = Bootstrap.game.get_cell()
	var gcell := coords.local_to_global(outdoor_id, local)
	player.global_position = coords.global_to_world(gcell)
	if player.has_method("set_grid"):
		player.set_grid(composite)


func _load_chunk(chunk_id: String, coord: Vector2i) -> void:
	if loaded_chunks.has(chunk_id):
		return
	var holder := Node3D.new()
	holder.name = chunk_id
	holder.set_meta("chunk_coord", coord)
	add_child(holder)
	loaded_chunks[chunk_id] = holder
	for loc in catalog.locations_in_chunk(coord):
		var lid := str(loc)
		_location_refs[lid] = int(_location_refs.get(lid, 0)) + 1
		if location_views.has(lid):
			continue
		var view := _make_chunk_view()
		view.name = "Loc_" + lid
		holder.add_child(view)
		var origin := catalog.origin_cell(lid)
		view.build(lid, origin, catalog.cell_size)
		view.portal_used.connect(func(to, sp): portal_used.emit(to, sp))
		view.object_chosen.connect(func(oid, acts): object_chosen.emit(oid, acts))
		view.zone_changed.connect(func(tag): zone_changed.emit(tag))
		location_views[lid] = view
	chunk_loaded.emit(chunk_id)


func _unload_chunk(chunk_id: String) -> void:
	if not loaded_chunks.has(chunk_id):
		return
	var holder: Node = loaded_chunks[chunk_id]
	var coord: Vector2i = holder.get_meta("chunk_coord") as Vector2i
	for loc in catalog.locations_in_chunk(coord):
		var lid := str(loc)
		var refs := int(_location_refs.get(lid, 1)) - 1
		if refs <= 0:
			_location_refs.erase(lid)
			var view: MnChunkView = location_views.get(lid)
			if view and is_instance_valid(view):
				view.queue_free()
			location_views.erase(lid)
		else:
			_location_refs[lid] = refs
	# remove holder (views órfãs já liberadas; views ainda referenciadas foram reparentadas?)
	# Se a view ainda é filha deste holder e outro chunk também a referencia, reparenta para o outro.
	for child in holder.get_children():
		var lid2 := str(child.name).trim_prefix("Loc_")
		if location_views.has(lid2) and _location_refs.get(lid2, 0) > 0:
			var other_holder: Node = _holder_for_location(lid2, chunk_id)
			if other_holder:
				child.reparent(other_holder)
	holder.queue_free()
	loaded_chunks.erase(chunk_id)
	chunk_unloaded.emit(chunk_id)


func _holder_for_location(location_id: String, skip_chunk_id: String) -> Node:
	for cid in loaded_chunks.keys():
		if str(cid) == skip_chunk_id:
			continue
		var holder: Node = loaded_chunks[cid]
		var coord: Vector2i = holder.get_meta("chunk_coord") as Vector2i
		for loc in catalog.locations_in_chunk(coord):
			if str(loc) == location_id:
				return holder
	return null


func _make_chunk_view() -> MnChunkView:
	var view := MnChunkView.new()
	# roots criados em _ensure_roots no build
	return view


func _recompute_bounds() -> void:
	_bounds_min = Vector2i(0, 0)
	_bounds_max = Vector2i(64, 64)
	for loc_id in catalog.outdoor_location_ids():
		var o := catalog.origin_cell(str(loc_id))
		var s := catalog.location_size(str(loc_id))
		_bounds_min = Vector2i(mini(_bounds_min.x, o.x), mini(_bounds_min.y, o.y))
		_bounds_max = Vector2i(maxi(_bounds_max.x, o.x + s.x), maxi(_bounds_max.y, o.y + s.y))


func _rebuild_composite_empty() -> void:
	var w := maxi(1, _bounds_max.x - _bounds_min.x)
	var h := maxi(1, _bounds_max.y - _bounds_min.y)
	# Grade composta ancorada em (0,0) do mundo global — origins já absolutos.
	# Se bounds_min < 0, deslocaríamos; no mapa atual origins ≥ 0.
	composite.setup(maxi(_bounds_max.x, 1), maxi(_bounds_max.y, 1), catalog.cell_size)


func _rebuild_composite_from_views() -> void:
	_rebuild_composite_empty()
	for lid in location_views.keys():
		var view: MnChunkView = location_views[lid]
		if view:
			view.stamp_into(composite)
	var player := get_tree().get_first_node_in_group("player") if is_inside_tree() else null
	if player and player.has_method("set_grid"):
		player.set_grid(composite)
