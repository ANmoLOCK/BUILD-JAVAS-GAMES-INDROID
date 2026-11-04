extends SceneTree
## Smoke: Neon Nightlife M/F + clips + avarias.


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	var PaperDollScr = load("res://game/actors/paper_doll.gd")
	var AnimScr = load("res://game/actors/anim_controller.gd")
	var StyleScr = load("res://game/actors/neon_style.gd")
	if PaperDollScr == null or AnimScr == null:
		push_error("failed to load scripts")
		quit(1)
		return
	var err := 0
	for gender in ["m", "f"]:
		var doll: Node3D = Node3D.new()
		doll.set_script(PaperDollScr)
		root.add_child(doll)
		doll.call("apply_neon_preset", gender)
		# sync frames
		for _i in 3:
			await process_frame
		if doll.get_node_or_null("BodyBillboard") == null:
			push_error("missing BodyBillboard for " + gender)
			err = 1
		if doll.get_node_or_null("FaceOverlay") == null:
			push_error("missing FaceOverlay for " + gender)
			err = 2
		doll.call("set_face_expression", 1)
		doll.call("set_condition", "bruised")
		var ov := doll.get_node_or_null("ConditionOverlay") as Sprite3D
		if ov == null or not ov.visible:
			push_error("condition overlay failed for " + gender)
			err = 3
		var anim: Node = Node.new()
		anim.set_script(AnimScr)
		root.add_child(anim)
		anim.call("bind", doll, gender)
		for clip in ["idle", "walk", "run", "dance_techno", "fight", "faint", "kiss", "talk"]:
			anim.call("play", clip)
			await process_frame
		var bill: Sprite3D = doll.get_node_or_null("BodyBillboard")
		print("[smoke-neon] gender=", gender, " tex=", bill != null and bill.texture != null, " err=", err)
		anim.queue_free()
		doll.queue_free()
	var pm = StyleScr.preset_vector("m")
	var pf = StyleScr.preset_vector("f")
	print("[smoke-neon] preset_m=", pm)
	print("[smoke-neon] preset_f=", pf)
	print("[smoke-neon] matches=", StyleScr.matches("m", pm), StyleScr.matches("f", pf))
	quit(err)
