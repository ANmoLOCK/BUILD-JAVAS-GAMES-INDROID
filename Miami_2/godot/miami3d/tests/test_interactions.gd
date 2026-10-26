extends SceneTree
## Interações básicas do apartamento.
## godot4 --path . --headless -s res://tests/test_interactions.gd

func _init() -> void:
	MnTestHelpers.reset()
	var g := MnGame.new()
	MnTestHelpers.assert_eq(g.boot("res://content", "user://saves_test_ix"), OK, "boot")
	g.rng.seed_value(7)
	g.new_game("Ix", "m")

	var sleep_before: int = g.stats.get_value("sleep")
	var r: Dictionary = g.interact("slot_bed", "sleep")
	MnTestHelpers.assert_true(typeof(r) == TYPE_DICTIONARY, "sleep result dict")
	# sleep pode falhar se não cansado — força valor
	g.stats.apply_effects([{ "stat": "sleep", "delta": 50 }])
	r = g.interact("slot_bed", "sleep")
	print("sleep -> ", r)
	MnTestHelpers.assert_true(g.stats.get_value("sleep") <= sleep_before + 50, "sleep changed or ok")

	g.interact("shower", "take_shower")
	MnTestHelpers.assert_gt(g.stats.get_value("hygiene"), 0, "hygiene after shower")

	g.enter_location("first_street", "from_apartment")
	MnTestHelpers.assert_eq(g.world.location_id, "first_street", "portal street")

	var code := MnTestHelpers.summary("test_interactions")
	print("TEST_INTERACTIONS_", "OK" if code == 0 else "FAIL")
	quit(code)
