extends SceneTree
## Smoke: personagem 3D Neon (GLB) + sem billboard de corpo.


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	var PaperDollScr = load("res://game/actors/paper_doll.gd")
	var AnimScr = load("res://game/actors/anim_controller.gd")
	var err := 0
	for gender in ["m", "f"]:
		var doll: Node3D = Node3D.new()
		doll.set_script(PaperDollScr)
		root.add_child(doll)
		doll.call("apply_neon_preset", gender)
		for _i in 4:
			await process_frame
		if doll.get_node_or_null("BodyBillboard") != null:
			push_error("BodyBillboard não deve existir mais — use GLB 3D")
			err = 10
		if doll.get_node_or_null("Head") == null:
			push_error("missing Head 3D for " + gender)
			err = 1
		if doll.get_node_or_null("Top") == null:
			push_error("missing Top 3D for " + gender)
			err = 2
		if doll.get_node_or_null("ArmL") == null:
			push_error("missing ArmL for " + gender)
			err = 3
		# GLB path must exist on disk
		var glb := "res://assets/models/characters/tops/top_%s_%02d.glb" % [
			gender, 18 if gender == "f" else 12
		]
		if not FileAccess.file_exists(glb) and not ResourceLoader.exists(glb):
			push_error("missing glb " + glb)
			err = 4
		var anim: Node = Node.new()
		anim.set_script(AnimScr)
		root.add_child(anim)
		anim.call("bind", doll, gender)
		for clip in ["idle", "walk", "run", "dance_techno", "fight"]:
			anim.call("play", clip)
			await process_frame
		print("[smoke-neon3d] gender=", gender, " head=", doll.get_node_or_null("Head") != null, " billboard=", doll.get_node_or_null("BodyBillboard") != null)
		anim.queue_free()
		doll.queue_free()
	# locations enriched
	for loc in ["player_apartment", "first_street"]:
		var p := "res://content/locations/%s.json" % loc
		if not FileAccess.file_exists(p):
			push_error("missing " + p)
			err = 5
		else:
			var f := FileAccess.open(p, FileAccess.READ)
			var d = JSON.parse_string(f.get_as_text())
			print("[smoke-neon3d] ", loc, " objects=", (d.get("objects", []) as Array).size(), " visual=", d.has("visual"))
	quit(err)
