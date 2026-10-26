class_name MnZone
extends Area3D
## Zona com tag: indoor / shade / beach / water / dancefloor / custom.

signal player_entered(tag: String, zone_id: String)
signal player_exited(tag: String, zone_id: String)

@export var zone_id: String = ""
@export var tag: String = "custom"


func _ready() -> void:
	body_entered.connect(_on_enter)
	body_exited.connect(_on_exit)
	monitoring = true
	collision_layer = 0
	collision_mask = 1


func setup(def: Dictionary) -> void:
	zone_id = str(def.get("id", zone_id))
	tag = str(def.get("tag", tag))


func _on_enter(body: Node) -> void:
	if body.is_in_group("player"):
		player_entered.emit(tag, zone_id)


func _on_exit(body: Node) -> void:
	if body.is_in_group("player"):
		player_exited.emit(tag, zone_id)
