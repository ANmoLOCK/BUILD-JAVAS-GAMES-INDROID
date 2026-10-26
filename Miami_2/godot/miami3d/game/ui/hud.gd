extends Control
## HUD Fase A: 4 necessidades + relógio + dinheiro.

var game: MnGame
@onready var clock: Label = $Clock
@onready var money: Label = $Money
@onready var bars: Dictionary = {}


func _ready() -> void:
	for id in ["hunger", "sleep", "hygiene", "bladder"]:
		var path := id.capitalize()
		if has_node(path):
			bars[id] = get_node(path)


func setup(g: MnGame) -> void:
	game = g
	game.events.minute_tick.connect(func(_m, _d): refresh())
	game.events.money_changed.connect(func(_c, _b): refresh())
	refresh()


func _process(_dt: float) -> void:
	if game:
		refresh()


func refresh() -> void:
	if game == null:
		return
	clock.text = "Dia %d  %02d:%02d" % [game.time.day, game.time.hour(), game.time.minute_of_day % 60]
	money.text = "$%d" % game.economy.cash
	for id in bars.keys():
		var bar: ProgressBar = bars[id]
		bar.value = game.stats.get_value(id)
		bar.tooltip_text = "%s: %d" % [id, game.stats.get_value(id)]
