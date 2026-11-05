class_name MnLocationController
extends Node3D
## Carrega um local a partir do content JSON: grade, chão, props, portais, zonas, NPCs.

signal location_ready(location_id: String)
signal portal_used(to_location: String, spawn_id: String)
signal object_chosen(object_id: String, actions: Array)
signal zone_changed(tag: String)

var grid := MnGridMap.new()
var location_id: String = ""
var location_def: Dictionary = {}

@onready var floor_root: Node3D = $Floor
@onready var props_root: Node3D = $Props
@onready var actors_root: Node3D = $Actors
@onready var portals_root: Node3D = $Portals
@onready var zones_root: Node3D = $Zones


func clear_world() -> void:
	for r in [floor_root, props_root, actors_root, portals_root, zones_root]:
		if r == null:
			continue
		for c in r.get_children():
			c.queue_free()


func load_location(id: String, spawn_id: String = "") -> void:
	clear_world()
	location_id = id
	location_def = Bootstrap.game.get_content_location(id)
	if location_def.is_empty():
		push_warning("local vazio: " + id)
		return
	var gdef: Dictionary = location_def.get("grid", {})
	grid.setup(int(gdef.get("width", 16)), int(gdef.get("height", 16)), 1.0)
	for rect in location_def.get("blocked", []):
		grid.add_rect(rect, MnGridMap.FLAG_BLOCKED)
	for rect in location_def.get("npcOnlyBlocked", []):
		grid.add_rect(rect, MnGridMap.FLAG_NPC_ONLY)
	_build_floor()
	_build_objects()
	_build_furniture_slots()
	_build_portals()
	_build_zones()
	_spawn_npcs()
	# posiciona player
	var player := get_tree().get_first_node_in_group("player") as Node3D
	if player:
		var cell := Bootstrap.game.get_cell()
		if spawn_id != "" and location_def.has("spawns"):
			var sps: Dictionary = location_def["spawns"]
			if sps.has(spawn_id):
				var sp: Dictionary = sps[spawn_id]
				var ca: Array = sp.get("cell", [cell.x, cell.y])
				cell = Vector2i(int(ca[0]), int(ca[1]))
		elif location_def.has("spawn"):
			var sp2: Dictionary = location_def["spawn"]
			var ca2: Array = sp2.get("cell", [0, 0])
			cell = Vector2i(int(ca2[0]), int(ca2[1]))
		player.global_position = grid.cell_to_world(cell)
		if player.has_method("set_grid"):
			player.set_grid(grid)
	location_ready.emit(id)


func _build_floor() -> void:
	var indoor := bool(location_def.get("indoor", false))
	var visual: Dictionary = location_def.get("visual", {})
	var miami_apt := location_id == "player_apartment" or str(visual.get("style", "")).begins_with("miami_low_apt")
	var tex := str(visual.get("floor_tex", ""))
	if miami_apt:
		var apt_floor := MnApartmentKit.tile_path("floor")
		if apt_floor != "":
			tex = apt_floor
	if tex == "" and Bootstrap.game and Bootstrap.game.get("assets") != null:
		tex = Bootstrap.game.assets.kit_texture(location_id, "albedo")
	var floor := MnMeshFactory.kit_floor(grid.width * grid.cell_size, grid.height * grid.cell_size, indoor, tex)
	floor_root.add_child(floor)
	# banheiro: overlay de piso azulejado Miami
	if miami_apt:
		_build_apartment_bath_floor()
		_build_apartment_windows()
	# céu / fill leve outdoor
	if not indoor:
		var sky := OmniLight3D.new()
		sky.name = "StreetFill"
		sky.light_color = Color(1.0, 0.85, 0.7)
		sky.light_energy = 0.55
		sky.omni_range = 80.0
		sky.position = Vector3(grid.width * 0.5, 12.0, grid.height * 0.5)
		floor_root.add_child(sky)
	var wall_c := Color(0.91, 0.86, 0.78) if miami_apt else Color(0.45, 0.40, 0.35)
	if visual.has("wall_color"):
		var wc: Array = visual["wall_color"]
		if wc.size() >= 3:
			wall_c = Color(float(wc[0]), float(wc[1]), float(wc[2]))
	# paredes / prédios por célula bloqueada
	for y in grid.height:
		for x in grid.width:
			var c := Vector2i(x, y)
			if grid.get_flags(c) & MnGridMap.FLAG_BLOCKED:
				var tall := 2.2 if indoor else (3.6 + float((x + y) % 3) * 0.8)
				var wall := MnMeshFactory.box(Vector3(0.95, tall, 0.95), wall_c)
				wall.position = grid.cell_to_world(c) + Vector3(0, tall * 0.5, 0)
				wall.add_to_group("cutaway_wall")
				if miami_apt:
					MnApartmentKit.apply_wall_material(wall)
				# janelas neon em prédios outdoor
				if not indoor and tall > 3.0 and ((x + y) % 4 == 0):
					var win := MnMeshFactory.box(Vector3(0.35, 0.45, 0.08), Color(1.0, 0.55, 0.35, 0.9))
					win.position = Vector3(0, 0.4, 0.5)
					wall.add_child(win)
				var body := StaticBody3D.new()
				var col := CollisionShape3D.new()
				var sh := BoxShape3D.new()
				sh.size = Vector3(0.95, tall, 0.95)
				col.shape = sh
				body.add_child(col)
				wall.add_child(body)
				props_root.add_child(wall)


func _build_apartment_bath_floor() -> void:
	## Zona do banheiro com azulejo fiel ao Miami (0559 remaster).
	var bath_path := MnApartmentKit.tile_path("bath")
	if bath_path == "" or not ResourceLoader.exists(bath_path):
		return
	var zones: Array = location_def.get("zones", [])
	for z in zones:
		if str(z.get("id", "")) != "bathroom_zone" and str(z.get("tag", "")) != "bathroom":
			continue
		var rect: Array = z.get("rect", [1, 1, 4, 6])
		if rect.size() < 4:
			continue
		var rw := float(rect[2])
		var rh := float(rect[3])
		var mi := MnMeshFactory.box(Vector3(rw, 0.08, rh), Color(0.55, 0.75, 0.85))
		var mat := StandardMaterial3D.new()
		mat.albedo_texture = load(bath_path)
		mat.uv1_scale = Vector3(rw, rh, 1.0)
		mat.texture_filter = BaseMaterial3D.TEXTURE_FILTER_NEAREST
		mi.material_override = mat
		mi.position = Vector3(float(rect[0]) + rw * 0.5, 0.02, float(rect[1]) + rh * 0.5)
		mi.name = "BathFloor"
		floor_root.add_child(mi)
		return


func _build_apartment_windows() -> void:
	## Janelas iso originais (0555) nas paredes norte do apt.
	if not MnApartmentKit.has_sprite("window"):
		return
	var spots: Array = [
		Vector2i(2, 0), Vector2i(7, 0), Vector2i(11, 0),
	]
	for cell in spots:
		if cell.x >= grid.width or cell.y >= grid.height:
			continue
		var spr := MnApartmentKit.make_sprite3d("window", [1, 1])
		if spr == null:
			continue
		spr.name = "Window_%d_%d" % [cell.x, cell.y]
		spr.pixel_size = 0.014
		spr.position = grid.cell_to_world(cell) + Vector3(0, 1.35, 0.15)
		spr.rotation_degrees = Vector3(0, 0, 0)
		props_root.add_child(spr)


func _build_objects() -> void:
	for obj in location_def.get("objects", []):
		var oid := str(obj.get("id", ""))
		var template := str(obj.get("template", ""))
		var cell_a: Array = obj.get("cell", [0, 0])
		var cell := Vector2i(int(cell_a[0]), int(cell_a[1]))
		var item: Dictionary = Bootstrap.game.get_content_item(template)
		var fp: Array = item.get("footprint", [1, 1])
		# marca footprint bloqueado
		for dy in int(fp[1]) if fp.size() > 1 else 1:
			for dx in int(fp[0]) if fp.size() > 0 else 1:
				grid.add_flags(Vector2i(cell.x + dx, cell.y + dy), MnGridMap.FLAG_BLOCKED)
		var node := preload("res://game/objects/interactable.tscn").instantiate()
		props_root.add_child(node)
		node.setup(oid, template, item, obj)
		node.global_position = grid.cell_to_world(cell)
		node.chosen.connect(func(actions): object_chosen.emit(oid, actions))


func _build_furniture_slots() -> void:
	for slot in location_def.get("furnitureSlots", []):
		var node := Node3D.new()
		node.set_script(preload("res://game/objects/furniture_slot.gd"))
		props_root.add_child(node)
		node.setup(slot)
		var ca: Array = slot.get("cell", [0, 0])
		node.global_position = grid.cell_to_world(Vector2i(int(ca[0]), int(ca[1])))


func _build_portals() -> void:
	for p in location_def.get("portals", []):
		var area := Area3D.new()
		area.set_script(preload("res://game/world/portal.gd"))
		var col := CollisionShape3D.new()
		var sh := BoxShape3D.new()
		sh.size = Vector3(1.2, 2.0, 1.2)
		col.shape = sh
		area.add_child(col)
		# marcador visual
		var marker := _make_box(Color(0.2, 0.6, 0.95, 0.7), Vector3(0.8, 0.1, 0.8))
		area.add_child(marker)
		portals_root.add_child(area)
		area.setup(p)
		var cell_a: Array = p.get("cell", [0, 0])
		var cell := Vector2i(int(cell_a[0]), int(cell_a[1]))
		if p.has("rect"):
			var r: Array = p["rect"]
			cell = Vector2i(int(r[0]), int(r[1]))
		area.global_position = grid.cell_to_world(cell) + Vector3(0, 1.0, 0)
		grid.add_flags(cell, MnGridMap.FLAG_DOOR)
		area.activated.connect(func(to, sp): portal_used.emit(to, sp))
		area.blocked.connect(func(msg): _notify(msg))


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
		area.global_position = Vector3(float(rect[0]) + rw * 0.5, 1.0, float(rect[1]) + rh * 0.5)
		area.player_entered.connect(func(tag, _id): zone_changed.emit(tag))


func _spawn_npcs() -> void:
	for entry in location_def.get("npcs", []):
		if entry.get("generic", false):
			var count := int(entry.get("count", 1))
			for i in count:
				_spawn_one_npc("generic_%d" % i, {"name": "@npc.generic"})
			continue
		var nid := str(entry.get("npc", ""))
		_spawn_one_npc(nid, Bootstrap.game.get_content_npc(nid))


func _spawn_one_npc(npc_id: String, def: Dictionary) -> void:
	if npc_id == "":
		return
	var scene: PackedScene = preload("res://game/actors/npc.tscn")
	var npc = scene.instantiate()
	actors_root.add_child(npc)
	npc.setup(npc_id, def, grid)
	# posição: perto do spawn do local
	var base := Bootstrap.game.get_cell()
	npc.global_position = grid.cell_to_world(base + Vector2i(2, 1))


func spawn_npc_at(npc_id: String, cell: Vector2i, facing: String = "S") -> Node:
	## EventBridge ← spawn_npc
	despawn_npc(npc_id)
	var def: Dictionary = Bootstrap.game.get_content_npc(npc_id) if Bootstrap.game else {}
	var scene: PackedScene = preload("res://game/actors/npc.tscn")
	var npc = scene.instantiate()
	actors_root.add_child(npc)
	npc.setup(npc_id, def, grid)
	npc.global_position = grid.cell_to_world(cell)
	if "facing" in npc:
		npc.facing = facing
	return npc


func despawn_npc(npc_id: String) -> void:
	## EventBridge ← despawn_npc
	if actors_root == null:
		return
	for c in actors_root.get_children():
		if c is Node and str(c.get("npc_id")) == npc_id:
			c.queue_free()


func move_npc_to(npc_id: String, cell: Vector2i, run: bool = false) -> void:
	## EventBridge ← move_npc
	if actors_root == null:
		return
	for c in actors_root.get_children():
		if c is Node and str(c.get("npc_id")) == npc_id:
			if c.has_method("go_to_cell"):
				c.go_to_cell(cell)
			else:
				c.global_position = grid.cell_to_world(cell)
			if run and "WALK_SPEED" in c:
				pass
			return


func find_npc(npc_id: String) -> Node:
	if actors_root == null:
		return null
	for c in actors_root.get_children():
		if c is Node and str(c.get("npc_id")) == npc_id:
			return c
	return null


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


func _notify(key: String) -> void:
	if Bootstrap.game and Bootstrap.game.is_native:
		Bootstrap.game.backend.emit_signal("notify", key)
	elif Bootstrap.game and Bootstrap.game.events:
		Bootstrap.game.events.notify.emit(key)
