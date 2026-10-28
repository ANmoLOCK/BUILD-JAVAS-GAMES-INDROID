class_name MnStreamBridge
extends RefCounted
## Decide se um deslocamento usa costura (stream) ou troca discreta.
## Mantém o cérebro (enter_location / leave_location) coerente.

var streamer: MnWorldStreamer
var discrete: Node # MnLocationController
var enabled: bool = false


func setup(p_streamer: MnWorldStreamer, p_discrete: Node) -> void:
	streamer = p_streamer
	discrete = p_discrete


func set_enabled(on: bool) -> void:
	enabled = on
	if streamer == null:
		return
	if on:
		streamer.activate()
		if discrete:
			discrete.visible = false
	else:
		streamer.deactivate()
		if discrete:
			discrete.visible = true


func is_stream_outdoor(location_id: String) -> bool:
	if not enabled or streamer == null or not streamer.is_ready_map():
		return false
	return streamer.coords.is_outdoor(location_id)


func enter(location_id: String, spawn_id: String = "") -> String:
	## Retorna "stream" | "discrete" conforme o caminho usado.
	if is_stream_outdoor(location_id):
		if discrete:
			discrete.visible = false
			if discrete.has_method("clear_world"):
				discrete.clear_world()
		streamer.visible = true
		streamer.focus_location(location_id, spawn_id)
		return "stream"
	# indoor / sem âncora → discreto
	if streamer and streamer.active:
		# mantém chunks outdoor carregados sob o indoor? simplifica: esconde streamer
		streamer.visible = false
	if discrete:
		discrete.visible = true
		if discrete.has_method("load_location"):
			discrete.load_location(location_id, spawn_id)
	return "discrete"


func handle_portal(from_id: String, to_id: String, spawn_id: String) -> String:
	## Outdoor→outdoor em stream: costura. Caso contrário: discreto.
	if enabled and streamer and streamer.is_outdoor_seam(from_id, to_id):
		Bootstrap.game.enter_location(to_id, spawn_id)
		streamer.ensure_location(to_id)
		streamer.place_player_at(to_id, spawn_id)
		streamer.focus_location_id = to_id
		streamer.focus_changed.emit(to_id)
		return "stream"
	# indoor transit / discrete
	Bootstrap.game.leave_location()
	Bootstrap.game.enter_location(to_id, spawn_id)
	return enter(to_id, spawn_id)


func handle_travel(location_id: String) -> String:
	Bootstrap.game.leave_location()
	Bootstrap.game.enter_location(location_id, "")
	return enter(location_id, "")
