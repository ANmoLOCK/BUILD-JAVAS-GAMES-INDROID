extends SceneTree
## Testes do sistema de stats.
## godot4 --path . --headless -s res://tests/test_stats.gd

func _init() -> void:
	MnTestHelpers.reset()
	var g := MnGame.new()
	MnTestHelpers.assert_eq(g.boot("res://content", "user://saves_test_stats"), OK, "boot")
	g.rng.seed_value(1)
	g.new_game("StatTester", "m")

	var hunger0: int = g.stats.get_value("hunger")
	MnTestHelpers.assert_ge(hunger0, 0, "hunger initial")
	g.stats.apply_effects([{ "stat": "hunger", "delta": 10 }])
	MnTestHelpers.assert_eq(g.stats.get_value("hunger"), hunger0 + 10, "hunger +10")

	# apply_effects altera valor (clamp pode ser feito em tick/collapse)
	var h2: int = g.stats.get_value("hunger")
	g.stats.apply_effects([{ "stat": "hunger", "delta": 5 }])
	MnTestHelpers.assert_eq(g.stats.get_value("hunger"), h2 + 5, "hunger +5 again")

	var hy: int = g.stats.get_value("hygiene")
	g.stats.apply_effects([{ "stat": "hygiene", "delta": -5 }])
	MnTestHelpers.assert_eq(g.stats.get_value("hygiene"), hy - 5, "hygiene -5")

	# 16 stats no content
	MnTestHelpers.assert_eq(g.content.stats.get("stats", []).size(), 16, "16 stats")

	var code := MnTestHelpers.summary("test_stats")
	print("TEST_STATS_", "OK" if code == 0 else "FAIL")
	quit(code)
