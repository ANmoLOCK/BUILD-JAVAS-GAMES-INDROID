class_name MnChunkView
extends Node3D
## Visual de UM local outdoor deslocado para coords globais.
## Não substitui MnLocationController indoor — só costura a cidade.

signal portal_used(to_location: String, spawn_id: String)
signal object_chosen(object_id: String, actions: Array)
signal zone_changed(tag: String)
signal ready_view(location_id: String)

var location_id: String = ""
var location_def: Dictionary = {}
var origin: Vector2i = Vector2i.ZERO
var local_grid := MnGridMap.new()
var cell_size: float = 1.0

@onready var floor_root: Node3D = $Floor
@onready var props_root: Node3D = $Props
@onready var actors_root: Node3D = $Actors
@onready var portals_root: Node3D = $Portals
@onready var zones_root: Node3D = $Zones


func _ensure_roots() -> void:
	for n in ["Floor", "Props", "Actors", "Portals", "Zones"]:
		if not has_node(n):
			var node := Node3D.new()
			node.name = n
			add_child(node)
	floor_root = $Floor
	props_root = $Props
	actors_root = $Actors
	portals_root = $Portals
	zones_root = $Zones


func clear_view() -> void:
	_ensure_roots()
	for r in [floor_root, props_root, actors_root, portals_root, zones_root]:
		for c in r.get_children():
			c.queue_free()


func build(p_location_id: String, p_origin: Vector2i, p_cell_size: float = 1.0) -> void:
	_ensure_roots()
	clear_view()
	location_id = p_location_id
	origin = p_origin
	cell_size = p_cell_size
	location_def = Bootstrap.game.get_content_location(location_id) if Bootstrap.game else {}
	if location_def.is_empty():
		push_warning("ChunkView local vazio: " + location_id)
		return
	var gdef: Dictionary = location_def.get("grid", {})
	local_grid.setup(int(gdef.get("width", 16)), int(gdef.get("height", 16)), cell_size)
	for rect in location_def.get("blocked", []):
		local_grid.add_rect(rect, MnGridMap.FLAG_BLOCKED)
	for rect in location_def.get("npcOnlyBlocked", []):
		local_grid.add_rect(rect, MnGridMap.FLAG_NPC_ONLY)
	position = Vector3(float(origin.x) * cell_size, 0.0, float(origin.y) * cell_size)
	_build_floor()
	_build_objects()
	_build_portals()
	_build_zones()
	_spawn_npcs()
	ready_view.emit(location_id)


func stamp_into(global_grid: MnGridMap) -> void:
	## Copia flags locais para a grade global composta.
	if global_grid == null:
		return
	for y in local_grid.height:
		for x in local_grid.width:
			var local := Vector2i(x, y)
			var gcell := origin + local
			if not global_grid.in_bounds(gcell):
				continue
			var f := local_grid.get_flags(local)
			if f != 0:
				global_grid.add_flags(gcell, f)


func local_to_global_cell(local: Vector2i) -> Vector2i:
	return origin + local


func _build_floor() -> void:
	var indoor := bool(location_def.get("indoor", false))
	var tex := ""
	if Bootstrap.game and Bootstrap.game.get("assets") != null:
		tex = Bootstrap.game.assets.kit_texture(location_id, "albedo")
	var floor := MnMeshFactory.kit_floor(
		local_grid.width * cell_size,
		local_grid.height * cell_size,
		indoor,
		tex
	)
	# kit_floor costuma centrar em 0; desloca para canto local
	floor.position = Vector3(
		local_grid.width * cell_size * 0.5,
		0.0,
		local_grid.height * cell_size * 0.5
	)
	floor_root.add_child(floor)
	for y in local_grid.height:
		for x in local_grid.width:
			var c := Vector2i(x, y)
			if local_grid.get_flags(c) & MnGridMap.FLAG_BLOCKED:
				var wall := MnMeshFactory.kit_wall_cell()
				wall.position = _local_cell_pos(c) + Vector3(0, 1.1, 0)
				wall.add_to_group("cutaway_wall")
				var body := StaticBody3D.new()
				var col := CollisionShape3D.new()
				var sh := BoxShape3D.new()
				sh.size = Vector3(0.95, 2.2, 0.95)
				col.shape = sh
				body.add_child(col)
				wall.add_child(body)
				props_root.add_child(wall)


func _build_objects() -> void:
	for obj in location_def.get("objects", []):
		var oid := str(obj.get("id", ""))
		var template := str(obj.get("template", ""))
		var cell_a: Array = obj.get("cell", [0, 0])
		var cell := Vector2i(int(cell_a[0]), int(cell_a[1]))
		var item: Dictionary = Bootstrap.game.get_content_item(template) if Bootstrap.game else {}
		var fp: Array = item.get("footprint", [1, 1])
		for dy in int(fp[1]) if fp.size() > 1 else 1:
			for dx in int(fp[0]) if fp.size() > 0 else 1:
				local_grid.add_flags(Vector2i(cell.x + dx, cell.y + dy), MnGridMap.FLAG_BLOCKED)
		var node := preload("res://game/objects/interactable.tscn").instantiate()
		props_root.add_child(node)
		node.setup(oid, template, item, obj)
		node.position = _local_cell_pos(cell)
		node.chosen.connect(func(actions): object_chosen.emit(oid, actions))


func _build_portals() -> void:
	for p in location_def.get("portals", []):
		var area := Area3D.new()
		area.set_script(preload("res://game/world/portal.gd"))
		var col := CollisionShape3D.new()
		var sh := BoxShape3D.new()
		sh.size = Vector3(1.2, 2.0, 1.2)
		col.shape = sh
		area.add_child(col)
		var marker := _make_box(Color(0.2, 0.85, 0.55, 0.7), Vector3(0.8, 0.1, 0.8))
		area.add_child(marker)
		portals_root.add_child(area)
		area.setup(p)
		var cell_a: Array = p.get("cell", [0, 0])
		var cell := Vector2i(int(cell_a[0]), int(cell_a[1]))
		if p.has("rect"):
			var r: Array = p["rect"]
			cell = Vector2i(int(r[0]), int(r[1]))
		area.position = _local_cell_pos(cell) + Vector3(0, 1.0, 0)
		local_grid.add_flags(cell, MnGridMap.FLAG_DOOR)
		area.activated.connect(func(to, sp): portal_used.emit(to, sp))


func _build_zones() -> void:
	for z in location_def.get("zones", []):
		var area := Area3D.new()
		area.set_script(preload("res://game/world/zone.gd"))
		var rect: Array = z.get("rect", [0, 0, 1, 1])
		var col := CollisionShape3D.new()
		var sh := BoxShape3D.new()
		var rw := float(rect[2]) if rect.size() > 2 else 1.0
		var rh := float(rect[3]) if rect.size() > 3 else 1.0
		sh.size = Vector3(rw, 2.0, rh)
		col.shape = sh
		area.add_child(col)
		zones_root.add_child(area)
		area.setup(z)
		area.position = Vector3(float(rect[0]) + rw * 0.5, 1.0, float(rect[1]) + rh * 0.5)
		area.player_entered.connect(func(tag, _id): zone_changed.emit(tag))


func _spawn_npcs() -> void:
	for entry in location_def.get("npcs", []):
		if entry.get("generic", false):
			continue
		var nid := str(entry.get("npc", ""))
		if nid == "":
			continue
		var def: Dictionary = Bootstrap.game.get_content_npc(nid) if Bootstrap.game else {}
		var scene: PackedScene = preload("res://game/actors/npc.tscn")
		var npc = scene.instantiate()
		actors_root.add_child(npc)
		npc.setup(nid, def, local_grid)
		var spawn: Dictionary = location_def.get("spawn", {})
		var ca: Array = spawn.get("cell", [2, 2])
		npc.position = _local_cell_pos(Vector2i(int(ca[0]) + 2, int(ca[1])))


func _local_cell_pos(c: Vector2i) -> Vector3:
	return Vector3((c.x + 0.5) * cell_size, 0.0, (c.y + 0.5) * cell_size)


func _make_box(color: Color, size: Vector3) -> MeshInstance3D:
	var mi := MeshInstance3D.new()
	var box := BoxMesh.new()
	box.size = size
	mi.mesh = box
	var mat := StandardMaterial3D.new()
	mat.albedo_color = color
	if color.a < 1.0:
		mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	mi.material_override = mat
	return mi
