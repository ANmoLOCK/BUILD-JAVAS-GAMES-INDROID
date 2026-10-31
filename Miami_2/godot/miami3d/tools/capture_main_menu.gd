extends SceneTree
## Captura PNG do menu B (pula boot) para QA visual.


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	var win := root.get_window()
	if win:
		win.size = Vector2i(1280, 720)
	DisplayServer.window_set_size(Vector2i(1280, 720))
	var packed := load("res://game/flow/main_menu.tscn")
	if packed == null:
		push_error("load failed")
		quit(1)
		return
	var menu: Control = packed.instantiate()
	root.add_child(menu)
	# espera textures + layout
	for i in 8:
		await process_frame
	await create_timer(0.35).timeout
	var img: Image = root.get_viewport().get_texture().get_image()
	if img == null:
		push_error("no image")
		quit(2)
		return
	var out := "user://menu_b_capture.png"
	var err := img.save_png(out)
	var abs_path := OS.get_user_data_dir().path_join("menu_b_capture.png")
	print("[capture] err=", err, " path=", abs_path, " size=", img.get_width(), "x", img.get_height())
	quit(0 if err == OK else 3)
