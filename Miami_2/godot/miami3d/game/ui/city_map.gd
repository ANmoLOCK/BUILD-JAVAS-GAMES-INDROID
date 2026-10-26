class_name MnCityMap
extends Control
## Mapa da cidade: 9 regiões / locais desbloqueados.

signal travel(location_id: String)
signal closed

@onready var list: VBoxContainer = $Panel/VBox/List

const REGION_ORDER := [
	"downtown", "south_beach", "little_havana", "ocean_drive",
	"coconut_grove", "miami_beach", "pelican_island", "key_biscayne", "everglades",
]

const REGION_NAMES := {
	"downtown": "Downtown",
	"south_beach": "South Beach",
	"little_havana": "Little Havana",
	"ocean_drive": "Ocean Drive",
	"coconut_grove": "Coconut Grove",
	"miami_beach": "Miami Beach / Light House",
	"pelican_island": "Pelican Island",
	"key_biscayne": "Key Biscayne",
	"everglades": "Everglades",
}


func _ready() -> void:
	visible = false


func open() -> void:
	visible = true
	for c in list.get_children():
		c.queue_free()
	var locs: Dictionary = Bootstrap.game.get_all_locations()
	var by_region: Dictionary = {}
	for id in locs.keys():
		var def: Dictionary = locs[id]
		var region := str(def.get("region", "downtown"))
		if not by_region.has(region):
			by_region[region] = []
		by_region[region].append(id)
	for region in REGION_ORDER:
		if not by_region.has(region):
			continue
		var header := Label.new()
		header.text = "— " + str(REGION_NAMES.get(region, region)) + " —"
		list.add_child(header)
		var ids: Array = by_region[region]
		ids.sort()
		for id in ids:
			var def: Dictionary = locs[id]
			var btn := Button.new()
			btn.text = Bootstrap.game.resolve_text(str(def.get("name", id)))
			btn.disabled = (id == Bootstrap.game.get_location())
			btn.pressed.connect(_go.bind(id))
			list.add_child(btn)
	# regiões extras não listadas
	for region in by_region.keys():
		if region in REGION_ORDER:
			continue
		var header2 := Label.new()
		header2.text = "— " + str(region) + " —"
		list.add_child(header2)
		for id in by_region[region]:
			var def2: Dictionary = locs[id]
			var btn2 := Button.new()
			btn2.text = Bootstrap.game.resolve_text(str(def2.get("name", id)))
			btn2.disabled = (id == Bootstrap.game.get_location())
			btn2.pressed.connect(_go.bind(id))
			list.add_child(btn2)
	var close_btn := Button.new()
	close_btn.text = "Fechar"
	close_btn.pressed.connect(func(): visible = false; closed.emit())
	list.add_child(close_btn)


func _go(id: String) -> void:
	visible = false
	travel.emit(id)
	closed.emit()
