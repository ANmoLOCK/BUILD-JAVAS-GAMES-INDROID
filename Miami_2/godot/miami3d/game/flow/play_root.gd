extends Node3D
## Loop de jogo 3D: local + player + câmera + overlays UI.
## Sinais do cérebro passam pelo MnEventBridge; ações passam pelo BrainFacade.
## WorldStreamer (opt-in miami/world_mode=stream) costura outdoors sem quebrar discrete.

signal request_menu

@onready var world: MnLocationController = $World/Location
@onready var streamer: MnWorldStreamer = $World/Streamer
@onready var player: MnPlayer = $World/Player
@onready var camera: MnIsoCamera = $World/IsoCamera
@onready var cutaway: MnCutawayWalls = $World/Cutaway
@onready var sun: DirectionalLight3D = $World/Sun
@onready var fill: OmniLight3D = $World/Fill
@onready var ui: CanvasLayer = $UI
@onready var hud = $UI/HUD
@onready var radial = $UI/RadialMenu
@onready var social = $UI/SocialMenu
@onready var dialogue = $UI/DialoguePanel
@onready var phone = $UI/Phone
@onready var city_map = $UI/CityMap
@onready var pause_menu = $UI/PauseMenu
@onready var creator = $UI/CharacterCreator
@onready var closet_ui = $UI/Closet
@onready var shop_ui = $UI/Shop
@onready var bank_ui = $UI/BankAtm
@onready var toast: MnToast = $UI/Toast
@onready var btn_bar: HBoxContainer = $UI/BtnBar

var fx := MnFxSpawner.new()
var bridge: MnEventBridge
var stream_bridge := MnStreamBridge.new()
var _pending_appearance: Array = []
var _gender: String = "m"
var _stream_tick: float = 0.0


func setup(new_game: bool, player_name: String = "Você", gender: String = "m", appearance: Array = []) -> void:
	_gender = gender
	_pending_appearance = appearance
	add_child(fx)
	camera.bind_target(player)
	cutaway.bind_camera(camera)
	var g: BrainFacade = Bootstrap.game
	_setup_streamer()
	bridge = MnEventBridge.new()
	bridge.name = "EventBridge"
	add_child(bridge)
	bridge.bind(g, world, player, hud, dialogue, toast, city_map, sun, fill, fx, camera)
	world.portal_used.connect(_on_portal)
	world.object_chosen.connect(_on_object_chosen)
	world.location_ready.connect(_on_location_ready)
	radial.action_picked.connect(_on_action)
	if social.has_signal("action_picked"):
		social.action_picked.connect(_on_social_action)
	city_map.travel.connect(_travel)
	if phone.has_signal("open_map_requested"):
		phone.open_map_requested.connect(func(): city_map.open())
	if closet_ui.has_signal("appearance_changed"):
		closet_ui.appearance_changed.connect(_on_closet_appearance)
	pause_menu.resume.connect(func(): pause_menu.close_unpause())
	pause_menu.to_menu.connect(func(): request_menu.emit())
	_wire_buttons()
	hud.setup(g)
	if new_game:
		if appearance.is_empty():
			creator.visible = true
			creator.confirmed.connect(_on_creator_done, CONNECT_ONE_SHOT)
		else:
			g.new_game(player_name, gender, appearance)
			player.apply_appearance(gender, appearance)
			_enter_current()
	else:
		var err := g.load_game(0)
		if err != OK:
			var fallback: Array = appearance if not appearance.is_empty() else _pending_appearance
			g.new_game(player_name, gender, fallback)
		if _pending_appearance.is_empty():
			_pending_appearance = MnNeonStyle.preset_vector(_gender)
		player.apply_appearance(_gender, _pending_appearance)
		_enter_current()


func _setup_streamer() -> void:
	if streamer == null:
		streamer = MnWorldStreamer.new()
		streamer.name = "Streamer"
		$World.add_child(streamer)
	var err := streamer.setup()
	if err != OK:
		push_warning("WorldStreamer map: %s — caindo para discrete" % err)
		stream_bridge.setup(streamer, world)
		stream_bridge.set_enabled(false)
		return
	stream_bridge.setup(streamer, world)
	var on := Bootstrap.is_stream_mode()
	stream_bridge.set_enabled(on)
	streamer.portal_used.connect(_on_stream_portal)
	streamer.object_chosen.connect(_on_object_chosen)
	streamer.focus_changed.connect(_on_stream_focus)
	if not on:
		streamer.visible = false


func _on_creator_done(n: String, gender: String, vector: Array) -> void:
	_gender = gender
	_pending_appearance = vector
	creator.visible = false
	Bootstrap.game.new_game(n, gender, vector)
	player.apply_appearance(gender, vector)
	_enter_current()


func _on_closet_appearance(vector: Array) -> void:
	_pending_appearance = vector
	if vector.size() > 0:
		_gender = "f" if int(vector[0]) == 1 else "m"


func _enter_current() -> void:
	var loc := Bootstrap.game.get_location()
	if loc == "" or loc == null:
		loc = "player_apartment"
		Bootstrap.game.enter_location(loc, "")
	var spawn := ""
	if Bootstrap.game.world:
		spawn = str(Bootstrap.game.world.spawn_id)
	if stream_bridge.enabled:
		stream_bridge.enter(loc, spawn)
	else:
		world.load_location(loc, spawn)


func _on_location_ready(_id: String) -> void:
	hud.refresh()


func _on_portal(to_loc: String, spawn: String) -> void:
	var from_id := Bootstrap.game.get_location()
	if stream_bridge.enabled:
		stream_bridge.handle_portal(from_id, to_loc, spawn)
	else:
		Bootstrap.game.leave_location()
		Bootstrap.game.enter_location(to_loc, spawn)
		world.load_location(to_loc, spawn)
	fx.spawn("stars", player.global_position + Vector3(0, 1.5, 0), self)


func _on_stream_portal(to_loc: String, spawn: String) -> void:
	_on_portal(to_loc, spawn)


func _on_stream_focus(location_id: String) -> void:
	## Sincroniza cérebro ao cruzar quarteirão sem portal explícito.
	if Bootstrap.game.get_location() == location_id:
		return
	if Bootstrap.game.world and Bootstrap.game.world.is_unlocked(location_id):
		Bootstrap.game.enter_location(location_id, "")
		_sync_global_cell()
	hud.refresh()


func _travel(location_id: String) -> void:
	if stream_bridge.enabled:
		stream_bridge.handle_travel(location_id)
	else:
		Bootstrap.game.leave_location()
		Bootstrap.game.enter_location(location_id, "")
		world.load_location(location_id)
	_sync_global_cell()


func _sync_global_cell() -> void:
	if not stream_bridge.enabled or streamer == null or Bootstrap.game.world == null:
		return
	var gcell := streamer.coords.world_to_global(player.global_position)
	Bootstrap.game.world.global_cell = gcell
	var loc := Bootstrap.game.get_location()
	if loc != "" and streamer.coords.is_outdoor(loc):
		Bootstrap.game.world.cell = streamer.coords.global_to_local(loc, gcell)


func _process(delta: float) -> void:
	if not stream_bridge.enabled or streamer == null or not streamer.active:
		return
	_stream_tick += delta
	if _stream_tick < 0.35:
		return
	_stream_tick = 0.0
	streamer.update_from_player_world(player.global_position)
	_sync_global_cell()


func _on_object_chosen(object_id: String, actions: Array) -> void:
	# atalhos de UI embutidos em ações de content
	var lower_actions: Array = []
	for a in actions:
		lower_actions.append(str(a).to_lower())
	if "open_shop" in lower_actions or object_id.begins_with("shop_"):
		shop_ui.open()
		return
	if "open_closet" in lower_actions or "change_clothes" in lower_actions:
		closet_ui.open()
		return
	if "use_atm" in lower_actions or "pay_rent" in lower_actions:
		bank_ui.open()
		return
	radial.open_for(object_id, actions)


func _on_action(action_id: String) -> void:
	var oid: String = str(radial.object_id)
	var a := action_id.to_lower()
	# dormir / trabalho / cirurgia → confirma e pede advance_time_request
	if "sleep" in a or "dorm" in a or "nap" in a:
		var result: Dictionary = Bootstrap.game.interact(oid, action_id)
		if bool(result.get("ok", false)):
			# duração extra se a ação não avançou sozinha
			var act: Dictionary = Bootstrap.game.get_content_interaction(action_id)
			var mins := int(act.get("durationMinutes", 0))
			if mins > 0 and not bool(act.get("advancesTime", false)):
				Bootstrap.game.advance_time_request(mins)
		_feedback_for_action(action_id, result)
		hud.refresh()
		return
	var result2: Dictionary = Bootstrap.game.interact(oid, action_id)
	_feedback_for_action(action_id, result2)
	hud.refresh()


func _on_social_action(npc_id: String, action_id: String) -> void:
	var result: Dictionary = Bootstrap.game.talk(npc_id, action_id)
	var a := action_id.to_lower()
	if a in ["flirt", "flertar", "offer", "oferecer"]:
		fx.spawn("hearts", player.global_position + Vector3(0, 1.6, 0), self)
	if player and player.has_method("play_action_anim"):
		if "kiss" in a or "beijo" in a:
			player.play_action_anim("kiss")
		elif "flirt" in a or "flertar" in a:
			player.play_action_anim("laugh")
		elif "offend" in a or "ofender" in a:
			player.play_action_anim("angry")
		else:
			player.play_action_anim("talk")
	hud.refresh()
	if result.has("line") or result.has("key"):
		if bridge:
			bridge._on_dialogue(result)


func _feedback_for_action(action_id: String, _result: Dictionary) -> void:
	var a := action_id.to_lower()
	var at := player.global_position + Vector3(0, 1.5, 0)
	var anim := "use"
	if "sleep" in a or "dorm" in a or "nap" in a:
		fx.spawn("zzz", at, self)
		anim = "sleep"
	elif "bath" in a or "shower" in a or "banho" in a:
		fx.spawn("stars", at, self)
		anim = "shower"
		_set_world_flag("wet", true)
	elif "swim" in a or "nadar" in a:
		anim = "swim"
		_set_world_flag("wet", true)
	elif "dance" in a or "dançar" in a:
		anim = "dance_pop"
	elif "fight" in a or "briga" in a or "punch" in a:
		anim = "fight"
		_set_world_flag("in_fight", true)
	elif "kiss" in a or "beijo" in a:
		fx.spawn("hearts", at, self)
		anim = "kiss"
	elif "flirt" in a:
		fx.spawn("hearts", at, self)
		anim = "laugh"
	elif "eat" in a or "comer" in a or "snack" in a:
		anim = "eat"
	elif "drink" in a or "beber" in a:
		anim = "drink"
	elif "sit" in a or "sentar" in a:
		anim = "sit"
	elif "piano" in a:
		anim = "piano"
	elif "lift" in a or "peso" in a:
		anim = "lift"
	elif "stink" in a or "trash" in a or "lixo" in a:
		fx.spawn("stink", at, self)
		anim = "angry"
	elif "talk" in a or "falar" in a:
		anim = "talk"
	if player and player.has_method("play_action_anim"):
		player.play_action_anim(anim)
	if player and player.has_method("refresh_visual_conditions"):
		player.refresh_visual_conditions()


func _set_world_flag(flag: String, on: bool) -> void:
	var g: BrainFacade = Bootstrap.game
	if g == null or g.is_native:
		return
	var world = g.backend.get("world") if g.get("backend") else null
	if world and world.has_method("set_flag"):
		if on:
			world.set_flag(flag, true)
		elif world.has_method("clear_flag"):
			world.clear_flag(flag)


func _wire_buttons() -> void:
	for child in btn_bar.get_children():
		child.queue_free()
	_add_btn("Telefone", func(): phone.open())
	_add_btn("Mapa", func(): city_map.open())
	_add_btn("Girar ◀", func(): camera.rotate_ccw())
	_add_btn("Girar ▶", func(): camera.rotate_cw())
	_add_btn("Pausa", func(): pause_menu.open())


func _add_btn(text: String, cb: Callable) -> void:
	var b := Button.new()
	b.text = text
	b.pressed.connect(cb)
	btn_bar.add_child(b)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE:
		pause_menu.open()
		return
	var tap_pos: Vector2
	var is_tap := false
	if event is InputEventScreenTouch and event.pressed:
		tap_pos = event.position
		is_tap = true
	elif event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		tap_pos = event.position
		is_tap = true
	if not is_tap:
		return
	_handle_tap(tap_pos)


func _handle_tap(screen_pos: Vector2) -> void:
	var from := camera.project_ray_origin(screen_pos)
	var dir := camera.project_ray_normal(screen_pos)
	var space := get_world_3d().direct_space_state
	var q := PhysicsRayQueryParameters3D.create(from, from + dir * 200.0)
	q.collide_with_areas = false
	q.collision_mask = 1 | 2 | 4
	var hit := space.intersect_ray(q)
	if hit.is_empty():
		if absf(dir.y) > 0.001:
			var t := -from.y / dir.y
			if t > 0:
				var world_pos := from + dir * t
				player.go_to_world(world_pos)
		return
	var collider = hit.collider
	if collider is MnInteractable:
		(collider as MnInteractable).request_menu()
		return
	if collider is Node and collider.has_meta("is_furniture_slot"):
		radial.open_for(str(collider.get_meta("object_id")), collider.get_meta("actions"))
		return
	if collider is Node and collider.is_in_group("npc"):
		if social.has_method("open_for"):
			var nid := str(collider.get("npc_id")) if collider.get("npc_id") != null else str(collider.name)
			social.open_for(nid)
		return
	player.go_to_world(hit.position)
