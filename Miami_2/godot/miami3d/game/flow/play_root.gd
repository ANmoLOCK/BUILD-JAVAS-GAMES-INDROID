extends Node3D
## Loop de jogo 3D: local + player + câmera + overlays UI.

signal request_menu

@onready var world: MnLocationController = $World/Location
@onready var player: MnPlayer = $World/Player
@onready var camera: MnIsoCamera = $World/IsoCamera
@onready var cutaway: MnCutawayWalls = $World/Cutaway
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
@onready var btn_bar: HBoxContainer = $UI/BtnBar

var fx := MnFxSpawner.new()
var _pending_appearance: Array = []
var _gender: String = "m"


func setup(new_game: bool, player_name: String = "Você", gender: String = "m", appearance: Array = []) -> void:
	_gender = gender
	_pending_appearance = appearance
	add_child(fx)
	camera.bind_target(player)
	cutaway.bind_camera(camera)
	var g: BrainFacade = Bootstrap.game
	g.connect_signal("notify", _on_notify)
	g.connect_signal("dialogue_requested", _on_dialogue)
	g.connect_signal("teleport", _on_teleport)
	g.connect_signal("stat_changed", func(_a, _b, _c): hud.refresh())
	g.connect_signal("money_changed", func(_a, _b): hud.refresh())
	world.portal_used.connect(_on_portal)
	world.object_chosen.connect(_on_object_chosen)
	world.location_ready.connect(_on_location_ready)
	radial.action_picked.connect(_on_action)
	if social.has_signal("action_picked"):
		social.action_picked.connect(_on_social_action)
	city_map.travel.connect(_travel)
	pause_menu.resume.connect(func(): pause_menu.close_unpause())
	pause_menu.to_menu.connect(func(): request_menu.emit())
	_wire_buttons()
	hud.setup(g)
	if new_game:
		if appearance.is_empty():
			creator.visible = true
			creator.confirmed.connect(_on_creator_done, CONNECT_ONE_SHOT)
		else:
			g.new_game(player_name, gender)
			player.apply_appearance(gender, appearance)
			_enter_current()
	else:
		var err := g.load_game(0)
		if err != OK:
			g.new_game(player_name, gender)
		player.apply_appearance(_gender, _pending_appearance)
		_enter_current()


func _on_creator_done(n: String, gender: String, vector: Array) -> void:
	_gender = gender
	_pending_appearance = vector
	creator.visible = false
	Bootstrap.game.new_game(n, gender)
	player.apply_appearance(gender, vector)
	_enter_current()


func _enter_current() -> void:
	var loc := Bootstrap.game.get_location()
	if loc == "" or loc == null:
		loc = "player_apartment"
		Bootstrap.game.enter_location(loc, "")
	world.load_location(loc)


func _on_location_ready(_id: String) -> void:
	hud.refresh()


func _on_portal(to_loc: String, spawn: String) -> void:
	Bootstrap.game.enter_location(to_loc, spawn)
	world.load_location(to_loc, spawn)
	fx.spawn("stars", player.global_position + Vector3(0, 1.5, 0), self)


func _on_teleport(location_id: String, spawn_id: String) -> void:
	world.load_location(location_id, spawn_id)


func _travel(location_id: String) -> void:
	Bootstrap.game.enter_location(location_id, "")
	world.load_location(location_id)


func _on_object_chosen(object_id: String, actions: Array) -> void:
	radial.open_for(object_id, actions)


func _on_action(action_id: String) -> void:
	var oid := radial.object_id
	var result: Dictionary = Bootstrap.game.interact(oid, action_id)
	_feedback_for_action(action_id, result)
	hud.refresh()


func _on_social_action(npc_id: String, action_id: String) -> void:
	var result: Dictionary = Bootstrap.game.talk(npc_id, action_id)
	if action_id in ["flirt", "FLERTAR", "offer", "OFERECER"]:
		fx.spawn("hearts", player.global_position + Vector3(0, 1.6, 0), self)
	hud.refresh()
	if result.has("line") or result.has("key"):
		_on_dialogue(result)


func _feedback_for_action(action_id: String, _result: Dictionary) -> void:
	var a := action_id.to_lower()
	var at := player.global_position + Vector3(0, 1.5, 0)
	if "sleep" in a or "dorm" in a or "nap" in a:
		fx.spawn("zzz", at, self)
	elif "bath" in a or "shower" in a or "banho" in a:
		fx.spawn("stars", at, self)
	elif "flirt" in a or "kiss" in a:
		fx.spawn("hearts", at, self)
	elif "stink" in a or "trash" in a or "lixo" in a:
		fx.spawn("stink", at, self)


func _on_notify(key: String) -> void:
	if dialogue and dialogue.has_method("show_text"):
		dialogue.show_text(Bootstrap.game.resolve_text(key))


func _on_dialogue(payload: Dictionary) -> void:
	var key := str(payload.get("key", payload.get("line", "")))
	if key == "":
		return
	if dialogue and dialogue.has_method("show_key"):
		dialogue.show_key(key, payload)
	elif dialogue and dialogue.has_method("show_text"):
		dialogue.show_text(Bootstrap.game.resolve_text(key, payload))


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
	# UI em cima? ignora se mouse sobre Control opaco — Godot já marca handled
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
		# chão: projeta no plano y=0
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
	# chão / parede → move perto do ponto
	player.go_to_world(hit.position)
