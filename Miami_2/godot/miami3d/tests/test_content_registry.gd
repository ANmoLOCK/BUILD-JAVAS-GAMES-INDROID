extends SceneTree
## Testes do ContentRegistry / pack base.
## godot4 --path . --headless -s res://tests/test_content_registry.gd

func _init() -> void:
	MnTestHelpers.reset()
	var reg := MnContentRegistry.new()
	MnTestHelpers.assert_eq(reg.load_pack("res://content"), OK, "load_pack")

	var s: Dictionary = reg.summary()
	MnTestHelpers.assert_ge(int(s.get("locations", 0)), 25, "locations")
	MnTestHelpers.assert_ge(int(s.get("npcs", 0)), 90, "npcs")
	MnTestHelpers.assert_ge(int(s.get("items", 0)), 50, "items")
	MnTestHelpers.assert_ge(int(s.get("interactions", 0)), 100, "interactions")
	MnTestHelpers.assert_ge(int(s.get("quests", 0)), 90, "quests")
	MnTestHelpers.assert_eq(int(s.get("jobs", 0)), 4, "jobs")

	MnTestHelpers.assert_true(reg.get_location("player_apartment").has("grid"), "apartment")
	MnTestHelpers.assert_true(reg.get_npc("landlord").has("id"), "landlord")
	MnTestHelpers.assert_true(reg.get_interaction("sleep").has("effects"), "sleep")
	MnTestHelpers.assert_true(not reg.regions.is_empty(), "regions")
	MnTestHelpers.assert_eq(int(reg.rent.get("apartment", {}).get("amount", 0)), 300, "rent")

	var code := MnTestHelpers.summary("test_content_registry")
	print("TEST_CONTENT_REGISTRY_", "OK" if code == 0 else "FAIL")
	quit(code)
