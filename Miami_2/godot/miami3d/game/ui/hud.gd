extends Control
## HUD Fase A: 4 necessidades + relógio + dinheiro.

var game: BrainFacade
@onready var clock: Label = $Clock
@onready var money: Label = $Money
@onready var bars: Dictionary = {}


func _ready() -> void:
	for id in ["hunger", "sleep", "hygiene", "bladder"]:
		var path := id.capitalize()
		if has_node(path):
			bars[id] = get_node(path)


func setup(g: BrainFacade) -> void:
	game = g
	g.connect_signal("minute_tick", func(_m, _d): refresh())
	g.connect_signal("money_changed", func(_c, _b): refresh())
	_attach_icons()
	refresh()


func _attach_icons() -> void:
	if game == null or game.assets == null:
		return
	for id in bars.keys():
		var icon_path: String = game.assets.hud_icon(id)
		if icon_path == "":
			continue
		var bar: ProgressBar = bars[id]
		if bar.get_node_or_null("Icon"):
			continue
		var tex := TextureRect.new()
		tex.name = "Icon"
		tex.texture = load(icon_path)
		tex.custom_minimum_size = Vector2(18, 18)
		tex.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		tex.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		bar.add_child(tex)


func _process(_dt: float) -> void:
	if game:
		refresh()


func refresh() -> void:
	if game == null:
		return
	clock.text = "Dia %d  %02d:%02d" % [game.get_day(), game.get_hour(), game.get_minute_of_day() % 60]
	money.text = "$%d" % game.get_cash()
	for id in bars.keys():
		var bar: ProgressBar = bars[id]
		bar.value = game.get_stat(id)
		bar.tooltip_text = "%s: %d" % [id, game.get_stat(id)]
