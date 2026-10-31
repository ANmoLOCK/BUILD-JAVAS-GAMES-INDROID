class_name MnEventBridge
extends Node
## Corpo: conecta sinais cérebro → reações (luz, HUD, NPCs, áudio, toast, save).
## Comandos corpo → cérebro passam por BrainFacade (tick_real, interact, …).

signal collapse_cutscene(stat_id: String)
signal location_unlocked(location_id: String)
signal quest_marker(quest_id: String, stage_id: String)

var facade: BrainFacade
var world: MnLocationController
var player: Node3D
var hud
var dialogue
var toast: MnToast
var city_map
var sun: DirectionalLight3D
var fill: OmniLight3D
var fx
var camera: Node3D

var _sfx: AudioStreamPlayer
var _music: AudioStreamPlayer
var _minigame_host: Node
var _autosaving: bool = false
var _bound: bool = false


func bind(
	g: BrainFacade,
	p_world: MnLocationController,
	p_player: Node3D,
	p_hud = null,
	p_dialogue = null,
	p_toast: MnToast = null,
	p_city_map = null,
	p_sun: DirectionalLight3D = null,
	p_fill: OmniLight3D = null,
	p_fx = null,
	p_camera: Node3D = null,
) -> void:
	facade = g
	world = p_world
	player = p_player
	hud = p_hud
	dialogue = p_dialogue
	toast = p_toast
	city_map = p_city_map
	sun = p_sun
	fill = p_fill
	fx = p_fx
	camera = p_camera
	_ensure_audio()
	if not _bound:
		_connect_all()
		_bound = true
	_apply_daylight(facade.get_hour() if facade else 12)


func _ensure_audio() -> void:
	if _sfx == null:
		_sfx = AudioStreamPlayer.new()
		_sfx.name = "Sfx"
		_sfx.bus = "Master"
		add_child(_sfx)
	if _music == null:
		_music = AudioStreamPlayer.new()
		_music.name = "Music"
		_music.bus = "Master"
		add_child(_music)


func _connect_all() -> void:
	var g := facade
	if g == null:
		return
	g.connect_signal("minute_tick", _on_minute)
	g.connect_signal("hour_tick", _on_hour)
	g.connect_signal("day_tick", _on_day)
	g.connect_signal("stat_changed", _on_stat)
	g.connect_signal("warning", _on_warning)
	g.connect_signal("collapse", _on_collapse)
	g.connect_signal("dialogue_requested", _on_dialogue)
	g.connect_signal("quest_stage_entered", _on_quest_stage)
	g.connect_signal("quest_completed", _on_quest_done)
	g.connect_signal("spawn_npc", _on_spawn_npc)
	g.connect_signal("despawn_npc", _on_despawn_npc)
	g.connect_signal("move_npc", _on_move_npc)
	g.connect_signal("teleport", _on_teleport)
	g.connect_signal("unlock_location", _on_unlock)
	g.connect_signal("lock_location", _on_lock)
	g.connect_signal("play_sound", _on_sound)
	g.connect_signal("play_music", _on_music)
	g.connect_signal("cutscene", _on_cutscene)
	g.connect_signal("notify", _on_notify)
	g.connect_signal("save_hint", _on_save_hint)
	g.connect_signal("minigame_requested", _on_minigame)
	g.connect_signal("money_changed", _on_money)
	g.connect_signal("location_changed", _on_location_changed)


# --- tempo / luz ---

func _on_minute(_minute: int, _day: int) -> void:
	if hud and hud.has_method("refresh"):
		hud.refresh()


func _on_hour(hour: int, _day: int) -> void:
	_apply_daylight(hour)
	if hud and hud.has_method("refresh"):
		hud.refresh()


func _on_day(_day: int) -> void:
	if toast:
		toast.push_key("@msg.rent_reminder", MnToast.Kind.TIP)


func _apply_daylight(hour: int) -> void:
	if sun == null:
		return
	# ciclo simples: noite baixa, meio-dia forte, pôr-do-sol quente
	var h := float(hour)
	var energy := 0.15
	var color := Color(0.55, 0.6, 0.85)
	if h >= 6.0 and h < 8.0:
		energy = lerpf(0.3, 0.9, (h - 6.0) / 2.0)
		color = Color(1.0, 0.75, 0.55)
	elif h >= 8.0 and h < 17.0:
		energy = 1.15
		color = Color(1.0, 0.97, 0.9)
	elif h >= 17.0 and h < 20.0:
		energy = lerpf(1.0, 0.25, (h - 17.0) / 3.0)
		color = Color(1.0, 0.55, 0.35)
	else:
		energy = 0.12
		color = Color(0.45, 0.55, 0.9)
	sun.light_energy = energy
	sun.light_color = color
	if fill:
		fill.light_energy = clampf(energy * 0.35, 0.08, 0.5)


# --- stats ---

func _on_stat(_stat_id: String, _value: int, _level: int) -> void:
	if hud and hud.has_method("refresh"):
		hud.refresh()


func _on_warning(_stat_id: String, text_key: String) -> void:
	if toast:
		toast.push_key(text_key, MnToast.Kind.ATTENTION)
	elif dialogue and dialogue.has_method("show_key"):
		dialogue.show_key(text_key)


func _on_collapse(stat_id: String, text_key: String) -> void:
	if toast:
		toast.push_key(text_key if text_key != "" else "@msg.collapse", MnToast.Kind.ATTENTION)
	if fx and player:
		fx.spawn("zzz", player.global_position + Vector3(0, 1.5, 0), self)
	collapse_cutscene.emit(stat_id)
	# cérebro já avançou / efeitos; corpo só confirma UI
	if facade:
		facade.advance_time_request(60)


func _on_money(_cash: int, _bank: int) -> void:
	if hud and hud.has_method("refresh"):
		hud.refresh()


# --- diálogo / missões / toast ---

func _on_dialogue(payload: Dictionary) -> void:
	var key := str(payload.get("key", payload.get("line", "")))
	if key == "":
		return
	if dialogue and dialogue.has_method("show_key"):
		dialogue.show_key(key, payload)
	elif dialogue and dialogue.has_method("show_text") and facade:
		dialogue.show_text(facade.resolve_text(key, payload))


func _on_quest_stage(quest_id: String, stage_id: String) -> void:
	quest_marker.emit(quest_id, stage_id)
	if toast:
		toast.push_key("@msg.quest_stage", MnToast.Kind.QUEST)
	if city_map and city_map.has_method("mark_quest"):
		city_map.mark_quest(quest_id, stage_id)


func _on_quest_done(quest_id: String) -> void:
	if toast:
		toast.push("%s — %s" % [facade.resolve_text("@msg.quest_done") if facade else "Missão", quest_id], MnToast.Kind.QUEST)


func _on_notify(text_key: String) -> void:
	var kind := MnToast.Kind.DEFAULT
	if toast:
		kind = toast.classify_key(text_key)
		toast.push_key(text_key, kind)
	elif dialogue and dialogue.has_method("show_text") and facade:
		dialogue.show_text(facade.resolve_text(text_key))


# --- NPCs ---

func _on_spawn_npc(npc_id: String, cell: Vector2i, facing: String) -> void:
	if world and world.has_method("spawn_npc_at"):
		world.spawn_npc_at(npc_id, cell, facing)


func _on_despawn_npc(npc_id: String) -> void:
	if world and world.has_method("despawn_npc"):
		world.despawn_npc(npc_id)


func _on_move_npc(npc_id: String, cell: Vector2i, run: bool) -> void:
	if world and world.has_method("move_npc_to"):
		world.move_npc_to(npc_id, cell, run)


# --- mundo ---

func _on_teleport(location_id: String, spawn_id: String) -> void:
	if world:
		world.load_location(location_id, spawn_id)
	if fx and player:
		fx.spawn("stars", player.global_position + Vector3(0, 1.5, 0), self)


func _on_unlock(location_id: String) -> void:
	location_unlocked.emit(location_id)
	if city_map and city_map.has_method("set_unlocked"):
		city_map.set_unlocked(location_id, true)
	if toast:
		toast.push_key("@msg.tip", MnToast.Kind.TIP)


func _on_lock(location_id: String) -> void:
	if city_map and city_map.has_method("set_unlocked"):
		city_map.set_unlocked(location_id, false)


func _on_location_changed(_location_id: String) -> void:
	if hud and hud.has_method("refresh"):
		hud.refresh()


# --- áudio / cutscene / minigame ---

func _on_sound(sound_id: String) -> void:
	var path := _resolve_audio("sfx", sound_id)
	if path == "" or _sfx == null:
		return
	var stream = load(path)
	if stream:
		_sfx.stream = stream
		_sfx.play()


func _on_music(music_id: String) -> void:
	var path := _resolve_audio("music", music_id)
	if path == "" or _music == null:
		return
	var stream = load(path)
	if stream:
		_music.stream = stream
		_music.play()


func _resolve_audio(kind: String, id: String) -> String:
	if facade == null or facade.assets == null:
		return ""
	if kind == "music" and facade.assets.has_method("music_path"):
		return facade.assets.music_path(id)
	if kind == "sfx" and facade.assets.has_method("sfx_path"):
		return facade.assets.sfx_path(id)
	# fallback por convenção de pastas
	var base := "res://assets/audio/%s/%s" % [kind, id]
	for ext in [".ogg", ".wav", ".mp3"]:
		if ResourceLoader.exists(base + ext):
			return base + ext
	return ""


func _on_cutscene(payload: Dictionary) -> void:
	## Placeholder: trava input leve + FX; câmera segue se payload pedir.
	if fx and player:
		fx.spawn(str(payload.get("fx", "stars")), player.global_position + Vector3(0, 1.6, 0), self)
	if payload.has("notify"):
		_on_notify(str(payload["notify"]))


func _on_minigame(payload: Dictionary) -> void:
	var mid := str(payload.get("id", payload.get("minigame", "dance")))
	var scene_map := {
		"dance": "res://game/minigames/dance.tscn",
		"posters": "res://game/minigames/posters.tscn",
		"photo": "res://game/minigames/photo.tscn",
	}
	var scene_path: String = str(scene_map.get(mid, "res://game/minigames/dance.tscn"))
	if not ResourceLoader.exists(scene_path):
		if facade:
			facade.start_minigame_result(mid, false, 0)
		return
	if _minigame_host and is_instance_valid(_minigame_host):
		_minigame_host.queue_free()
	var packed: PackedScene = load(scene_path)
	_minigame_host = packed.instantiate()
	add_child(_minigame_host)
	if _minigame_host.has_signal("finished"):
		_minigame_host.finished.connect(func(won: bool, score: int):
			if facade:
				facade.start_minigame_result(mid, won, score)
			if is_instance_valid(_minigame_host):
				_minigame_host.queue_free()
				_minigame_host = null
		)
	if _minigame_host.has_method("start"):
		_minigame_host.start(str(payload.get("style", "techno")))


# --- save ---

func _on_save_hint() -> void:
	if _autosaving or facade == null:
		return
	_autosaving = true
	var err: Error = facade.save_game(0)
	_autosaving = false
	if err == OK and toast:
		toast.push_key("@msg.saved", MnToast.Kind.TIP)
