extends SceneTree
## Testes do AssetRegistry / manifests.
## godot4 --path . --headless -s res://tests/test_asset_registry.gd

func _init() -> void:
	MnTestHelpers.reset()
	var assets := MnAssetRegistry.new()
	MnTestHelpers.assert_eq(assets.boot("res://assets"), OK, "boot assets")
	MnTestHelpers.assert_true(assets.ready, "ready")

	var counts: Dictionary = assets.summary()
	MnTestHelpers.assert_ge(int(counts.get("furniture", 0)), 60, "furniture")
	MnTestHelpers.assert_ge(int(counts.get("kits", 0)), 25, "kits")
	MnTestHelpers.assert_ge(int(counts.get("anim_clips", 0)), 20, "clips")

	var rig: String = assets.rig_path()
	MnTestHelpers.assert_true(rig.begins_with("res://"), "rig path")
	var resolved: String = assets.resolve_mesh(rig)
	MnTestHelpers.assert_true(resolved != "", "resolve rig/placeholder")

	var part: String = assets.part_path("head", "m", 0)
	MnTestHelpers.assert_true(part != "", "part path")

	var floor_tex: String = assets.kit_texture("player_apartment", "albedo")
	MnTestHelpers.assert_true(floor_tex.contains("textures"), "kit texture")

	var icon: String = assets.hud_icon("hunger")
	MnTestHelpers.assert_true(icon.ends_with("hunger.png") or icon == "", "hud icon")

	MnTestHelpers.assert_eq(MnAnimationMap.clip_for("sleep"), "sleep", "anim map")
	MnTestHelpers.assert_eq(MnAnimationMap.clip_for("dance_salsa"), "dance_salsa", "dance")

	var code := MnTestHelpers.summary("test_asset_registry")
	print("TEST_ASSET_REGISTRY_", "OK" if code == 0 else "FAIL")
	quit(code)
