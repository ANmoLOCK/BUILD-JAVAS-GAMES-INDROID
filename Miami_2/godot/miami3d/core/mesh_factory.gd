class_name MnMeshFactory
extends RefCounted
## Malhas procedurais enquanto os GLB finais não existem.

static func box(size: Vector3, color: Color) -> MeshInstance3D:
	var mi := MeshInstance3D.new()
	var mesh := BoxMesh.new()
	mesh.size = size
	mi.mesh = mesh
	mi.material_override = _mat(color)
	return mi


static func capsule(height: float, radius: float, color: Color) -> MeshInstance3D:
	var mi := MeshInstance3D.new()
	var mesh := CapsuleMesh.new()
	mesh.height = height
	mesh.radius = radius
	mi.mesh = mesh
	mi.material_override = _mat(color)
	return mi


static func sphere(radius: float, color: Color) -> MeshInstance3D:
	var mi := MeshInstance3D.new()
	var mesh := SphereMesh.new()
	mesh.radius = radius
	mesh.height = radius * 2.0
	mi.mesh = mesh
	mi.material_override = _mat(color)
	return mi


static func paper_doll_part(slot: String, color: Color) -> MeshInstance3D:
	match slot:
		"Head":
			var h := sphere(0.16, color)
			h.position = Vector3(0, 1.55, 0)
			h.name = "Head"
			return h
		"Hair":
			var hair := box(Vector3(0.32, 0.16, 0.32), color)
			hair.position = Vector3(0, 1.72, 0)
			hair.name = "Hair"
			return hair
		"Top":
			var top := box(Vector3(0.45, 0.5, 0.25), color)
			top.position = Vector3(0, 1.15, 0)
			top.name = "Top"
			return top
		"Bottom":
			var bottom := box(Vector3(0.4, 0.45, 0.25), color)
			bottom.position = Vector3(0, 0.65, 0)
			bottom.name = "Bottom"
			return bottom
		"Shoes":
			var shoes := box(Vector3(0.35, 0.12, 0.4), color)
			shoes.position = Vector3(0, 0.12, 0)
			shoes.name = "Shoes"
			return shoes
		_:
			return box(Vector3(0.3, 0.3, 0.3), color)


static func item_visual(item_id: String, footprint: Array, color: Color = Color(0.65, 0.55, 0.4)) -> MeshInstance3D:
	var sx := float(footprint[0]) if footprint.size() > 0 else 1.0
	var sz := float(footprint[1]) if footprint.size() > 1 else 1.0
	var h := 0.9
	match item_id:
		"bed_standard", "bed_1", "bed_2", "bed_3":
			h = 0.45
		"sofa_basic", "sofa_1", "sofa_2", "sofa_3":
			h = 0.55
		"shower", "toilet", "sink":
			h = 1.1
			color = Color(0.55, 0.75, 0.85)
		"fridge", "kitchen":
			h = 1.4
			color = Color(0.7, 0.7, 0.75)
		"plant":
			h = 0.8
			color = Color(0.35, 0.55, 0.3)
		"sun_lounger":
			h = 0.25
		"bar", "dj_desk":
			h = 1.0
	var mi := box(Vector3(maxf(0.4, sx * 0.85), h, maxf(0.4, sz * 0.85)), color)
	mi.position.y = h * 0.5
	mi.name = "Visual"
	return mi


static func pet_visual(species: String) -> MeshInstance3D:
	match species:
		"cat":
			return box(Vector3(0.35, 0.25, 0.55), Color(0.75, 0.55, 0.35))
		"bird":
			return sphere(0.12, Color(0.9, 0.8, 0.2))
		"crocodile":
			return box(Vector3(0.5, 0.25, 1.4), Color(0.25, 0.45, 0.25))
		_:
			return box(Vector3(0.4, 0.45, 0.7), Color(0.55, 0.4, 0.25))


static func kit_floor(width: float, height: float, indoor: bool, tex_path: String = "") -> MeshInstance3D:
	var mi := box(Vector3(width, 0.1, height), Color(0.22, 0.35, 0.28) if indoor else Color(0.30, 0.42, 0.25))
	if tex_path != "" and ResourceLoader.exists(tex_path):
		var mat := StandardMaterial3D.new()
		mat.albedo_texture = load(tex_path)
		mat.uv1_scale = Vector3(width * 0.5, height * 0.5, 1)
		mi.material_override = mat
	mi.position = Vector3(width * 0.5, -0.05, height * 0.5)
	mi.name = "Floor"
	return mi


static func kit_wall_cell(color: Color = Color(0.45, 0.40, 0.35)) -> MeshInstance3D:
	return box(Vector3(0.95, 2.2, 0.95), color)


static func try_instance_scene(path: String) -> Node3D:
	if path == "" or not ResourceLoader.exists(path):
		return null
	var res = load(path)
	if res is PackedScene:
		return res.instantiate()
	if res is Mesh:
		var mi := MeshInstance3D.new()
		mi.mesh = res
		return mi
	return null


static func _mat(color: Color) -> StandardMaterial3D:
	var mat := StandardMaterial3D.new()
	mat.albedo_color = color
	return mat
