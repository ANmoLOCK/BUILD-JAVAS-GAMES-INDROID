extends SceneTree
## Teste headless do cérebro C++ (MnBrain) se a GDExtension estiver carregada.
## godot4 --path . --headless -s res://tests/text_day_native.gd

func _init() -> void:
	if not ClassDB.class_exists("MnBrain"):
		push_error("MnBrain não encontrado — rode Miami_2/godot/native/build.sh")
		quit(1)
	var g = ClassDB.instantiate("MnBrain")
	assert(g.boot("res://content", "user://saves_test_cpp") == OK)
	g.new_game("CppTester", "m")
	print("native loc=", g.get_location(), " hunger=", g.get_stat("hunger"))
	var r = g.interact("slot_bed", "sleep")
	print("sleep -> ", r, " sleep=", g.get_stat("sleep"))
	r = g.interact("fridge", "snack")
	print("snack -> ", r, " hunger=", g.get_stat("hunger"))
	g.advance_minutes(60)
	print("after 1h hunger=", g.get_stat("hunger"), " snapshot=", g.snapshot())
	assert(g.save_game(0) == OK)
	print("TEXT_DAY_NATIVE_OK")
	quit(0)
