extends Node
## Autoload: instancia o cérebro MnGame e expõe para o resto do jogo.

var game: MnGame


func _ready() -> void:
	game = MnGame.new()
	var content_dir := str(ProjectSettings.get_setting("miami/content_dir", "res://content"))
	var save_dir := str(ProjectSettings.get_setting("miami/save_dir", "user://saves"))
	var err := game.boot(content_dir, save_dir)
	if err != OK:
		push_error("Falha ao carregar content pack em %s" % content_dir)
	else:
		print("[Bootstrap] pack '%s' v%s — %d locais, %d interações, %d quests" % [
			str(game.content.pack.get("id", "?")),
			str(game.content.pack.get("version", "?")),
			game.content.locations.size(),
			game.content.interactions.size(),
			game.content.quests.size(),
		])


func _process(delta: float) -> void:
	if game and game.ready and not game.time.paused:
		game.tick_real(delta)
