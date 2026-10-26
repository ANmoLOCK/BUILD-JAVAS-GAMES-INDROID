class_name MnCityMap
extends Control
## Mapa da cidade: 9 regiões a partir de content/regions.json.

signal travel(location_id: String)
signal closed

@onready var list: VBoxContainer = $Panel/VBox/List


func _ready() -> void:
	visible = false


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
			var def: Dictionary = locs[id]
			var btn := Button.new()
			btn.text = Bootstrap.game.resolve_text(str(def.get("name", id)))
			btn.disabled = (id == Bootstrap.game.get_location())
			btn.pressed.connect(_go.bind(str(id)))
			list.add_child(btn)
	for id in locs.keys():
		if listed.has(id):
			continue
		var def2: Dictionary = locs[id]
		var btn2 := Button.new()
		btn2.text = Bootstrap.game.resolve_text(str(def2.get("name", id)))
		btn2.disabled = (id == Bootstrap.game.get_location())
		btn2.pressed.connect(_go.bind(str(id)))
		list.add_child(btn2)
	_add_close()


func _fallback_flat(locs: Dictionary) -> void:
	for id in locs.keys():
		var def: Dictionary = locs[id]
		var btn := Button.new()
		btn.text = Bootstrap.game.resolve_text(str(def.get("name", id)))
		btn.disabled = (id == Bootstrap.game.get_location())
		btn.pressed.connect(_go.bind(str(id)))
		list.add_child(btn)
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
