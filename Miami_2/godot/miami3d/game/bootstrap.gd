extends Node
## Autoload: sobe o cérebro (C++ MnBrain se compilado, senão MnGame GDScript).

var game: BrainFacade


func _ready() -> void:
	game = BrainFacade.new()
	var content_dir := str(ProjectSettings.get_setting("miami/content_dir", "res://content"))
	var save_dir := str(ProjectSettings.get_setting("miami/save_dir", "user://saves"))
	var err := game.boot(content_dir, save_dir)
	if err != OK:
		push_error("Falha ao carregar content pack em %s" % content_dir)
	else:
		var mode := "C++" if game.is_native else "GDScript"
		print("[Bootstrap] cérebro %s pronto — local default após new_game" % mode)


func _process(delta: float) -> void:
	if game and game.ready:
		game.tick_real(delta)
