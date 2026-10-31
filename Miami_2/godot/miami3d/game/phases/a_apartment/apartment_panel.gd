extends VBoxContainer
## Fase A — painel do apartamento (UI placeholder).

var game: BrainFacade
var main
@onready var loc_label: Label = $LocLabel
@onready var actions: VBoxContainer = $Actions
@onready var places: HBoxContainer = $Places


func setup(g: BrainFacade, main_ref) -> void:
	game = g
	main = main_ref
	refresh()


func refresh() -> void:
	if game == null:
		return
	loc_label.text = "Local: %s  célula %s" % [game.get_location(), str(game.get_cell())]
	_rebuild_actions()
	_rebuild_places()


func _rebuild_actions() -> void:
	for c in actions.get_children():
		c.queue_free()
	var loc: Dictionary = game.get_content_location(game.get_location())
	for obj in loc.get("objects", []):
		var oid := str(obj.get("id", ""))
		var template := str(obj.get("template", ""))
		var item: Dictionary = game.get_content_item(template)
		for aid in item.get("actions", []):
			var idef: Dictionary = game.get_content_interaction(str(aid))
			var btn := Button.new()
			btn.text = "%s — %s" % [oid, game.resolve_text(str(idef.get("name", aid)))]
			btn.pressed.connect(_on_action.bind(oid, str(aid)))
			actions.add_child(btn)
	for slot in loc.get("furnitureSlots", []):
		var def_item := str(slot.get("default", ""))
		if def_item == "":
			continue
		var item2: Dictionary = game.get_content_item(def_item)
		for aid2 in item2.get("actions", []):
			var idef2: Dictionary = game.get_content_interaction(str(aid2))
			var btn2 := Button.new()
			btn2.text = "%s — %s" % [def_item, game.resolve_text(str(idef2.get("name", aid2)))]
			btn2.pressed.connect(_on_action.bind(str(slot.get("id", def_item)), str(aid2)))
			actions.add_child(btn2)


func _rebuild_places() -> void:
	for c in places.get_children():
		c.queue_free()
	var loc: Dictionary = game.get_content_location(game.get_location())
	for p in loc.get("portals", []):
		var btn := Button.new()
		var to := str(p.get("to", ""))
		btn.text = "Ir → " + to
		btn.pressed.connect(_on_portal.bind(to, str(p.get("spawn", ""))))
		places.add_child(btn)


func _on_action(object_id: String, action_id: String) -> void:
	var r: Dictionary = game.interact(object_id, action_id)
	if main:
		main.log_line("ação %s/%s → %s" % [object_id, action_id, str(r)])
	refresh()


func _on_portal(to: String, spawn: String) -> void:
	game.enter_location(to, spawn)
	if main:
		main.log_line("portal → %s" % to)
	refresh()
