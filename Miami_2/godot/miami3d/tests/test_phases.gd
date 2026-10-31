extends SceneTree
## Fases A–G: locais cumulativos + sistemas com fase mínima.
## godot4 --path . --headless -s res://tests/test_phases.gd

func _init() -> void:
	MnTestHelpers.reset()
	var g := MnGame.new()
	MnTestHelpers.assert_eq(g.boot("res://content", "user://saves_test_phase"), OK, "boot")

	# default A
	MnTestHelpers.assert_eq(g.phases.current, "a", "default phase a")
	MnTestHelpers.assert_true(g.world.is_unlocked("player_apartment"), "A apt")
	MnTestHelpers.assert_true(g.world.is_unlocked("first_street"), "A street")
	MnTestHelpers.assert_true(g.world.is_unlocked("apartment_garden"), "A garden")
	MnTestHelpers.assert_true(not g.world.is_unlocked("south_beach"), "A no beach")
	MnTestHelpers.assert_true(not g.world.is_unlocked("stadium"), "A no stadium")
	MnTestHelpers.assert_true(g.phases.system_unlocked("time"), "A time")
	MnTestHelpers.assert_true(g.phases.system_unlocked("needs4"), "A needs")
	MnTestHelpers.assert_true(not g.phases.system_unlocked("jobs"), "A no jobs")
	MnTestHelpers.assert_true(not g.phases.system_unlocked("dating"), "A no dating")

	# aliases
	MnTestHelpers.assert_eq(g.phases.resolve_location_id("restaurant_yuca"), "yuca_restaurant", "alias yuca")
	MnTestHelpers.assert_eq(g.phases.resolve_location_id("press_office"), "newspaper_office", "alias press")
	MnTestHelpers.assert_eq(g.phases.resolve_location_id("beauty_salon"), "beauty_clinic", "alias beauty")

	# avançar B
	var r: Dictionary = g.set_phase("b")
	MnTestHelpers.assert_true(bool(r.get("ok", false)), "set B")
	MnTestHelpers.assert_true(g.world.is_unlocked("police_station"), "B police")
	MnTestHelpers.assert_true(g.world.is_unlocked("player_apartment"), "B keeps A")
	MnTestHelpers.assert_true(g.phases.system_unlocked("economy"), "B economy")
	MnTestHelpers.assert_true(g.phases.system_unlocked("social_menus"), "B social")

	# C beach
	g.set_phase("c")
	MnTestHelpers.assert_true(g.world.is_unlocked("south_beach"), "C beach")
	MnTestHelpers.assert_true(g.phases.system_unlocked("city_map"), "C map")

	# D jobs
	g.set_phase("d")
	for loc in ["yuca_restaurant", "glight_club", "newspaper_office", "stadium"]:
		MnTestHelpers.assert_true(g.world.is_unlocked(loc), "D " + loc)
	MnTestHelpers.assert_true(g.phases.system_unlocked("jobs"), "D jobs")
	MnTestHelpers.assert_true(g.phases.system_unlocked("minigame_dance"), "D dance")
	var work: Dictionary = g.work_shift("pizza_delivery")
	MnTestHelpers.assert_true(typeof(work) == TYPE_DICTIONARY, "work_shift dict")

	# E life
	g.set_phase("e")
	MnTestHelpers.assert_true(g.world.is_unlocked("little_havana"), "E havana")
	MnTestHelpers.assert_true(g.phases.system_unlocked("dating"), "E dating")
	MnTestHelpers.assert_true(g.phases.system_unlocked("pets"), "E pets")
	var pet: Dictionary = g.adopt_pet("buddy", "dog", "lab")
	MnTestHelpers.assert_true(bool(pet.get("ok", false)), "adopt pet")
	var gnome: Dictionary = g.find_gnome("gnome_1")
	MnTestHelpers.assert_true(bool(gnome.get("ok", false)), "gnome")

	# F story + mid/hi
	g.set_phase("f")
	MnTestHelpers.assert_true(g.world.is_unlocked("mansion"), "F mansion")
	MnTestHelpers.assert_true(g.world.is_unlocked("miami_beach"), "F beach")
	var tier: Dictionary = g.set_home_tier(2)
	MnTestHelpers.assert_true(bool(tier.get("ok", false)), "home_hi tier")

	# G mods flag
	g.set_phase("g")
	MnTestHelpers.assert_true(g.phases.system_unlocked("mods"), "G mods")
	MnTestHelpers.assert_true(g.world.is_unlocked("player_apartment"), "G keeps A")

	# gate: dating locked on A
	g.set_phase("a")
	var locked: Dictionary = g.talk("landlord", "date")
	MnTestHelpers.assert_true(not bool(locked.get("ok", false)), "date locked on A")
	MnTestHelpers.assert_eq(str(locked.get("reason", "")), "phase", "date reason phase")

	# enter locked location
	g.enter_location("stadium", "")
	MnTestHelpers.assert_true(g.world.location_id != "stadium", "cannot enter stadium on A")

	var code := MnTestHelpers.summary("test_phases")
	print("TEST_PHASES_", "OK" if code == 0 else "FAIL")
	quit(code)
