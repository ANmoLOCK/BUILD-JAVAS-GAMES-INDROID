class_name MnPortal
extends Area3D
## Area3D de portal: ao entrar, pede troca de local.

signal activated(to_location: String, spawn_id: String)
signal blocked(message_key: String)

@export var portal_id: String = ""
@export var to_location: String = ""
@export var spawn_id: String = ""
@export var requires_flag: String = ""
@export var closed_message: String = "@msg.locked"

var _cooldown: float = 0.0


func _ready() -> void:
	body_entered.connect(_on_body)
	monitoring = true
	monitorable = false
	collision_layer = 0
	collision_mask = 1


func _process(delta: float) -> void:
	if _cooldown > 0.0:
		_cooldown -= delta


func setup(def: Dictionary) -> void:
	portal_id = str(def.get("id", portal_id))
	to_location = str(def.get("to", ""))
	spawn_id = str(def.get("spawn", ""))
	closed_message = str(def.get("closedMessage", closed_message))
	if def.has("requires") and typeof(def["requires"]) == TYPE_DICTIONARY:
		var r: Dictionary = def["requires"]
		if r.has("flag"):
			requires_flag = str(r["flag"])


func _on_body(body: Node) -> void:
	if _cooldown > 0.0 or not body.is_in_group("player"):
		return
	if requires_flag != "" and Bootstrap.game and not _flag(requires_flag):
		blocked.emit(closed_message)
		return
	_cooldown = 1.2
	activated.emit(to_location, spawn_id)


func _flag(f: String) -> bool:
	var g = Bootstrap.game
	if g == null:
		return true
	return g.backend.has_flag(f) if g.is_native else g.world.has_flag(f)
