extends SceneTree
## Runner headless de todos os testes (sem GUT/gdUnit4).
## godot4 --path . --headless -s res://tests/run_all.gd
##
## Cada suite é um SceneTree separado — aqui apenas documentamos a ordem e
## imprimimos o comando. Para CI use tests/run_all.sh.

func _init() -> void:
	print("Miami 3D — suites headless:")
	var suites := [
		"res://tests/test_content_registry.gd",
		"res://tests/test_stats.gd",
		"res://tests/test_economy.gd",
		"res://tests/test_asset_registry.gd",
		"res://tests/test_interactions.gd",
		"res://tests/test_event_commands.gd",
		"res://tests/test_phases.gd",
		"res://tests/test_phase_ops.gd",
		"res://tests/text_day.gd",
	]
	for s in suites:
		print("  ", s)
	print("RUN_ALL_HINT use tests/run_all.sh")
	quit(0)
