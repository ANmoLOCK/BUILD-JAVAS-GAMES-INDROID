extends Node
## Autoload: sobe o cérebro (C++ MnBrain se compilado, senão MnGame GDScript).

var game: BrainFacade
## discrete (padrão, não quebra o game) | stream (WorldStreamer chunks)
var world_mode: String = "discrete"


func _ready() -> void:
	world_mode = str(ProjectSettings.get_setting("miami/world_mode", "discrete")).to_lower()
	if world_mode != "stream":
		world_mode = "discrete"
	game = BrainFacade.new()
	var content_dir := str(ProjectSettings.get_setting("miami/content_dir", "res://content"))
	var save_dir := str(ProjectSettings.get_setting("miami/save_dir", "user://saves"))
	var assets_dir := str(ProjectSettings.get_setting("miami/assets_dir", "res://assets"))
	var err := game.boot(content_dir, save_dir, assets_dir)
	if err != OK:
		push_error("Falha ao carregar content pack em %s" % content_dir)
	else:
		var mode := "C++" if game.is_native else "GDScript"
		print("[Bootstrap] cérebro %s pronto — local default após new_game" % mode)
		print("[Bootstrap] world_mode=%s (miami/world_mode)" % world_mode)
		var summary: Dictionary = game.get_content_summary() if game.has_method("get_content_summary") else {}
		if not summary.is_empty():
			print("[Bootstrap] pack %s v%s — locs=%s npcs=%s items=%s acts=%s quests=%s jobs=%s" % [
				summary.get("pack", "?"), summary.get("version", "?"),
				summary.get("locations", 0), summary.get("npcs", 0),
				summary.get("items", 0), summary.get("interactions", 0),
				summary.get("quests", 0), summary.get("jobs", 0),
			])
		if game.has_method("get_phase"):
			print("[Bootstrap] fase ativa: %s (miami/phase)" % game.get_phase())


func set_world_mode(mode: String) -> void:
	var m := mode.to_lower()
	world_mode = "stream" if m == "stream" else "discrete"


func is_stream_mode() -> bool:
	return world_mode == "stream"


func _process(delta: float) -> void:
	if game and game.ready:
		game.tick_real(delta)
