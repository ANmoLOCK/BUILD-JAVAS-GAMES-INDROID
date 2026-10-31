extends SceneTree
## Teste headless do cérebro: simula 24 h + algumas ações.
## Rode: godot4 --headless -s res://tests/text_day.gd

func _init() -> void:
	var g := MnGame.new()
	var err := g.boot("res://content", "user://saves_test")
	assert(err == OK)
	g.rng.seed_value(42)
	g.new_game("Tester", "m")
	print("start @ ", g.world.location_id, " cash=", g.economy.cash)
	print("stats hunger=", g.stats.get_value("hunger"), " sleep=", g.stats.get_value("sleep"))

	# dorme
	var r = g.interact("slot_bed", "sleep")
	print("sleep -> ", r, " sleep=", g.stats.get_value("sleep"), " time=", g.time.hour())

	# banho
	r = g.interact("shower", "take_shower")
	print("shower -> ", r, " hygiene=", g.stats.get_value("hygiene"))

	# lanchar
	r = g.interact("fridge", "snack")
	print("snack -> ", r, " hunger=", g.stats.get_value("hunger"))

	# avança 24 h via time (não real-time)
	g.time.advance_minutes(24 * 60)
	print("after 24h day=", g.time.day, " hunger=", g.stats.get_value("hunger"), " sleep=", g.stats.get_value("sleep"))

	# portal
	g.enter_location("first_street", "from_apartment")
	print("street=", g.world.location_id)

	# save/load
	assert(g.saves.save_game(g, 0) == OK)
	var g2 := MnGame.new()
	assert(g2.boot("res://content", "user://saves_test") == OK)
	assert(g2.saves.load_game(g2, 0) == OK)
	print("loaded day=", g2.time.day, " loc=", g2.world.location_id)

	print("TEXT_DAY_OK")
	quit(0)
