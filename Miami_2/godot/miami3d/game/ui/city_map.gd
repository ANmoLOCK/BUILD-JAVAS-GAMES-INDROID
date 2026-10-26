class_name MnCityMap
extends Control
## Mapa da cidade: 9 regiões a partir de content/regions.json.

signal travel(location_id: String)
signal closed

@onready var list: VBoxContainer = $Panel/VBox/List

var _unlock_override: Dictionary = {} # location_id -> bool
var _quest_markers: Dictionary = {} # location_id -> quest_id


func _ready() -> void:
	visible = false


func set_unlocked(location_id: String, unlocked: bool) -> void:
	_unlock_override[location_id] = unlocked


func mark_quest(quest_id: String, _stage_id: String) -> void:
	## Marca missão ativa (texto no botão); local vem do content se houver.
	_quest_markers[quest_id] = true


func _is_unlocked(id: String) -> bool:
	if _unlock_override.has(id):
		return bool(_unlock_override[id])
	var g: BrainFacade = Bootstrap.game
	if g and g.has_method("is_location_unlocked"):
		return g.is_location_unlocked(id)
	if g and not g.is_native and g.world:
		return g.world.is_unlocked(id)
	return false


func open() -> void:
	visible = true
	for c in list.get_children():
		c.queue_free()
	var locs: Dictionary = Bootstrap.game.get_all_locations()
	var regions_doc: Dictionary = Bootstrap.game.get_regions()
	var regions: Array = regions_doc.get("regions", [])
	if regions.is_empty():
		_fallback_flat(locs)
		return
	var listed: Dictionary = {}
	for r in regions:
		var header := Label.new()
		header.text = "— " + Bootstrap.game.resolve_text(str(r.get("name", r.get("id", "")))) + " —"
		list.add_child(header)
		for id in r.get("locations", []):
			listed[id] = true
			if not locs.has(id):
				continue
			list.add_child(_make_loc_btn(str(id), locs[id]))
	for id in locs.keys():
		if listed.has(id):
			continue
		list.add_child(_make_loc_btn(str(id), locs[id]))
	_add_close()


func _make_loc_btn(id: String, def: Dictionary) -> Button:
	var btn := Button.new()
	var label := Bootstrap.game.resolve_text(str(def.get("name", id)))
	if not _quest_markers.is_empty():
		label = "★ " + label
	btn.text = label
	var here := (id == Bootstrap.game.get_location())
	var locked := not _is_unlocked(id)
	btn.disabled = here or locked
	if locked:
		btn.text = label + " (bloqueado)"
	btn.pressed.connect(_go.bind(id))
	return btn


func _fallback_flat(locs: Dictionary) -> void:
	for id in locs.keys():
		list.add_child(_make_loc_btn(str(id), locs[id]))
	_add_close()


func _add_close() -> void:
	var close_btn := Button.new()
	close_btn.text = "Fechar"
	close_btn.pressed.connect(func(): visible = false; closed.emit())
	list.add_child(close_btn)


func _go(id: String) -> void:
	visible = false
	travel.emit(id)
	closed.emit()
