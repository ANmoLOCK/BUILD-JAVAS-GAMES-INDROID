extends SceneTree
## Captura PNGs do apartamento (QA visual: texturas Miami + Sprite3D + animações).


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	DisplayServer.window_set_size(Vector2i(1280, 720))
	var packed := load("res://game/flow/play_root.tscn")
	if packed == null:
		push_error("play_root.tscn não carregou")
		quit(1)
		return
	var play: Node = packed.instantiate()
	root.add_child(play)
	for _i in 6:
		await process_frame

	# novo jogo direto no apartamento (pula criador)
	var boot = root.get_node_or_null("/root/Bootstrap")
	if boot == null or boot.get("game") == null:
		push_error("Bootstrap/game indisponível")
		quit(2)
		return
	var game = boot.game
	var vec := [0, 2, 3, 1, 12, 4, 7, 2, 5, 3]
	game.new_game("QA", "m", vec)
	var player = play.get("player")
	if player and player.has_method("apply_appearance"):
		player.apply_appearance("m", vec)
	game.enter_location("player_apartment", "from_street")
	var world = play.get("world")
	if world:
		world.load_location("player_apartment", "from_street")
	for _i in 10:
		await process_frame
	await create_timer(0.5).timeout

	# relatório da cena montada
	var sprites := 0
	var meshes := 0
	var names: Array = []
	if world and world.get("props_root") != null:
		for c in world.props_root.get_children():
			var v = c.get_node_or_null("MiamiSprite")
			if v == null:
				v = c.get_node_or_null("Visual")
			if v is Sprite3D:
				sprites += 1
				names.append(str(c.get_meta("object_id")) if c.has_meta("object_id") else c.name)
			elif v is MeshInstance3D:
				meshes += 1
			elif c is Sprite3D:
				sprites += 1
	print("[capture-apt] sprite3d=", sprites, " mesh=", meshes)
	if world and world.get("grid") != null:
		var blocked := 0
		for y in world.grid.height:
			for x in world.grid.width:
				if world.grid.get_flags(Vector2i(x, y)) & 1:
					blocked += 1
		print("[capture-apt] grid=", world.grid.width, "x", world.grid.height, " blocked=", blocked)
	var walls := 0
	var vis_walls := 0
	for n in root.get_tree().get_nodes_in_group("cutaway_wall"):
		walls += 1
		if n is Node3D and n.visible:
			vis_walls += 1
	print("[capture-apt] paredes=", walls, " visiveis=", vis_walls)
	print("[capture-apt] objetos=", names.size())

	var dir := OS.get_user_data_dir()
	var cam := root.get_viewport().get_camera_3d()
	if player:
		print("[capture-apt] player em ", player.global_position)
	# enquadra o apartamento inteiro
	var focus := Node3D.new()
	root.add_child(focus)
	var gw := 14.0
	var gh := 19.0
	if world and world.get("grid") != null:
		gw = float(world.grid.width)
		gh = float(world.grid.height)
	focus.global_position = Vector3(gw * 0.5, 0.0, gh * 0.5)
	var cutaway := play.get_node_or_null("World/Cutaway")
	if cutaway and cutaway.has_method("bind_target"):
		# nas panorâmicas o cutaway usa o centro do apartamento, não o jogador
		cutaway.bind_target(focus)
	if cam and cam.has_method("bind_target"):
		cam.bind_target(focus)
		cam.set("distance", 26.0)
		cam.set("height", 22.0)
		cam.set("zoom_max", 40.0)

	for i in 4:
		if i > 0 and cam and cam.has_method("rotate_cw"):
			cam.rotate_cw()
		for _j in 6:
			await process_frame
		await create_timer(0.3).timeout
		var img: Image = root.get_viewport().get_texture().get_image()
		if img == null:
			push_error("sem imagem")
			continue
		img.save_png("user://apt_cam%d.png" % i)
		print("[capture-apt] salvo ", dir.path_join("apt_cam%d.png" % i))

	# enquadramento real de jogo (câmera segue o player)
	if cutaway and cutaway.has_method("bind_target"):
		cutaway.bind_target(player)
	if player and cam and cam.has_method("bind_target"):
		cam.bind_target(player)
		cam.set("distance", 14.0)
		cam.set("height", 12.0)
		for _j in 6:
			await process_frame
		await create_timer(0.3).timeout
		var gimg: Image = root.get_viewport().get_texture().get_image()
		if gimg:
			gimg.save_png("user://apt_game.png")
			var vw := 0
			for n in root.get_tree().get_nodes_in_group("cutaway_wall"):
				if n is Node3D and n.visible:
					vw += 1
			print("[capture-apt] jogo: paredes visiveis=", vw)

	# close-up do player para conferir o personagem 3D
	if player and cam and cam.has_method("bind_target"):
		cam.bind_target(player)
		cam.set("distance", 8.0)
		cam.set("height", 5.5)
		for _j in 6:
			await process_frame
		await create_timer(0.3).timeout
		var pimg: Image = root.get_viewport().get_texture().get_image()
		if pimg:
			pimg.save_png("user://apt_player.png")
			print("[capture-apt] salvo ", dir.path_join("apt_player.png"))

	# animações: percorre clipes no player
	if player and player.has_method("play_action_anim"):
		for clip in ["idle", "walk", "sleep", "shower", "eat", "sit"]:
			player.play_action_anim(clip)
			for _i in 3:
				await process_frame
			print("[capture-apt] anim ok ", clip)
	quit(0)
