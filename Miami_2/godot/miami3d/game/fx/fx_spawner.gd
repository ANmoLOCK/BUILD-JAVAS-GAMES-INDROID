class_name MnFxSpawner
extends Node
## Spawna efeitos de feedback (corações, Zzz, fedor, moscas, estrelas) no mundo 3D.

const SCENES := {
	"hearts": "res://game/fx/hearts.tscn",
	"zzz": "res://game/fx/zzz.tscn",
	"stink": "res://game/fx/stink.tscn",
	"flies": "res://game/fx/flies.tscn",
	"stars": "res://game/fx/stars.tscn",
}


func spawn(kind: String, at: Vector3, parent: Node = null, lifetime: float = 2.0) -> Node3D:
	var path := str(SCENES.get(kind, ""))
	if path == "":
		push_warning("fx desconhecido: " + kind)
		return null
	var packed: PackedScene = load(path)
	if packed == null:
		return null
	var node: Node3D = packed.instantiate()
	var host: Node = parent if parent else get_tree().current_scene
	host.add_child(node)
	node.global_position = at
	if node.has_method("play"):
		node.play(lifetime)
	else:
		var t := get_tree().create_timer(lifetime)
		t.timeout.connect(node.queue_free)
	return node
