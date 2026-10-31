extends SceneTree
## Smoke: instancia o menu B e valida nós críticos.


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	var err := OK
	var packed := load("res://game/flow/main_menu.tscn")
	if packed == null:
		push_error("main_menu.tscn failed to load")
		quit(1)
		return
	var menu: Control = packed.instantiate()
	root.add_child(menu)
	await process_frame
	await process_frame
	var studio: Label = menu.get_node_or_null("StudioLine")
	var list: VBoxContainer = menu.get_node_or_null("Rail/VBox/Scroll/List")
	var brand: Label = menu.get_node_or_null("BrandColumn/BrandBlock/Title")
	if studio == null or list == null or brand == null:
		push_error("missing critical nodes")
		quit(2)
		return
	if studio.horizontal_alignment != HORIZONTAL_ALIGNMENT_LEFT:
		push_error("StudioLine must be left-aligned")
		err = 3
	if studio.anchor_top < 0.99:
		push_error("StudioLine must be bottom-anchored")
		err = 4
	var n := list.get_child_count()
	if n < 7:
		push_error("expected 7 menu buttons, got %d" % n)
		err = 5
	else:
		var labels: PackedStringArray = []
		for c in list.get_children():
			if c is Button:
				labels.append((c as Button).text)
		print("[smoke] buttons=", ",".join(labels))
		print("[smoke] studio='", studio.text, "' offsets=", studio.offset_left, ",", studio.offset_top, ",", studio.offset_right, ",", studio.offset_bottom)
		print("[smoke] brand=", brand.text)
	menu.queue_free()
	quit(err)
