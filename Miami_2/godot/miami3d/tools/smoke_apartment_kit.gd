extends SceneTree
## Smoke: kit do apartamento Miami (tiles + Sprite3D nos itens).


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	var err := 0
	var m := MnApartmentKit.manifest()
	if m.is_empty():
		push_error("manifest vazio")
		err = 1
	var items: Dictionary = m.get("items", {})
	print("[smoke-apt] items=", items.size(), " tiles=", m.get("tiles", {}).keys())
	var need := ["bed_standard", "sofa_basic", "tv", "fridge", "shower", "toilet", "stove", "closet", "window", "sink"]
	for n in need:
		if not items.has(n):
			push_error("item ausente: " + n)
			err = 2
			continue
		var p := str(items[n].get("x4", ""))
		if not FileAccess.file_exists(p):
			push_error("tex ausente: " + p)
			err = 3
	for t in ["floor", "wall", "bath"]:
		var tp := MnApartmentKit.tile_path(t)
		if tp == "" or not FileAccess.file_exists(tp):
			push_error("tile ausente: " + t)
			err = 4

	# Sprite3D real por template
	var sprites := 0
	var root3 := Node3D.new()
	root.add_child(root3)
	for template in ["bed_standard", "sofa_basic", "tv", "fridge", "shower", "toilet", "closet", "kitchen", "table", "plant"]:
		if not MnApartmentKit.has_sprite(template):
			push_error("sem sprite: " + template)
			err = 5
			continue
		var spr := MnApartmentKit.make_sprite3d(template, [1, 1])
		if spr == null or spr.texture == null:
			push_error("Sprite3D falhou: " + template)
			err = 6
			continue
		root3.add_child(spr)
		sprites += 1
		print("[smoke-apt] sprite ok ", template, " ", spr.texture.get_width(), "x", spr.texture.get_height())
	print("[smoke-apt] sprites3d=", sprites)

	# location JSON
	var loc_path := "res://content/locations/player_apartment.json"
	var f := FileAccess.open(loc_path, FileAccess.READ)
	var loc = JSON.parse_string(f.get_as_text())
	var objs: Array = loc.get("objects", [])
	var vis: Dictionary = loc.get("visual", {})
	print("[smoke-apt] objects=", objs.size(), " style=", vis.get("style", ""), " floor=", vis.get("floor_tex", ""))
	if str(vis.get("style", "")).find("miami_low_apt") < 0:
		push_error("visual.style não é miami_low_apt")
		err = 7
	if objs.size() < 10:
		push_error("poucos objects no apt")
		err = 8
	# todos templates do apt têm sprite
	var missing_spr := 0
	for o in objs:
		var t := str(o.get("template", ""))
		if t != "" and not MnApartmentKit.has_sprite(t):
			print("[smoke-apt] WARN sem sprite template=", t)
			missing_spr += 1
	if missing_spr > 0:
		push_error("templates do apartamento sem sprite Miami: %d" % missing_spr)
		err = 9

	print("[smoke-apt] RESULT=", "OK" if err == 0 else "FAIL err=%d" % err)
	quit(err)
