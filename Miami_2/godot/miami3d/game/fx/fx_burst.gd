extends Node3D
## Burst visual placeholder: Label3D + partículas simples, auto-destrói.

@export var label_text: String = "♥"
@export var tint: Color = Color(1, 0.4, 0.55)


func _ready() -> void:
	_ensure()


func play(lifetime: float = 2.0) -> void:
	_ensure()
	var tw := create_tween()
	tw.set_parallel(true)
	tw.tween_property(self, "position:y", position.y + 1.2, lifetime)
	tw.tween_property($Label, "modulate:a", 0.0, lifetime)
	tw.chain().tween_callback(queue_free)


func _ensure() -> void:
	if has_node("Label"):
		return
	var lab := Label3D.new()
	lab.name = "Label"
	lab.text = label_text
	lab.font_size = 64
	lab.modulate = tint
	lab.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	lab.position = Vector3(0, 0.5, 0)
	add_child(lab)
	var mi := MeshInstance3D.new()
	mi.name = "Spark"
	var sphere := SphereMesh.new()
	sphere.radius = 0.12
	sphere.height = 0.24
	mi.mesh = sphere
	var mat := StandardMaterial3D.new()
	mat.albedo_color = tint
	mat.emission_enabled = true
	mat.emission = tint
	mat.emission_energy_multiplier = 1.5
	mi.material_override = mat
	mi.position = Vector3(0, 0.3, 0)
	add_child(mi)
