class_name MnBrand
extends RefCounted
## Identidade Miami Life — troca de estúdio/título sem hardcode Gameloft.

const PATH := "res://content/brand.json"

static var _cache: Dictionary = {}


static func data() -> Dictionary:
	if not _cache.is_empty():
		return _cache
	if not FileAccess.file_exists(PATH):
		_cache = {
			"game_title": "Miami Life",
			"game_title_short": "MIAMI LIFE",
			"tagline_pt": "A cidade é sua.",
			"studio_name": "Coral Pulse",
			"studio_legal": "Coral Pulse Interactive",
			"assets": {
				"studio_logo": "res://assets/ui/brand/coral_pulse_studio.png",
				"game_logo": "res://assets/ui/brand/miami_life_logo.png",
				"hero_bg": "res://assets/ui/brand/miami_life_hero.png",
			},
			"boot": {"studio_hold_s": 1.6, "loading_min_s": 1.8, "tips_pt": []},
		}
		return _cache
	var f := FileAccess.open(PATH, FileAccess.READ)
	var parsed = JSON.parse_string(f.get_as_text())
	f.close()
	_cache = parsed if typeof(parsed) == TYPE_DICTIONARY else {}
	return _cache


static func title() -> String:
	return str(data().get("game_title", "Miami Life"))


static func title_short() -> String:
	return str(data().get("game_title_short", "MIAMI LIFE"))


static func tagline() -> String:
	return str(data().get("tagline_pt", ""))


static func studio() -> String:
	return str(data().get("studio_name", "Coral Pulse"))


static func studio_legal() -> String:
	return str(data().get("studio_legal", studio()))


static func asset(key: String) -> String:
	var a: Dictionary = data().get("assets", {})
	return str(a.get(key, ""))


static func boot() -> Dictionary:
	return data().get("boot", {})


static func load_texture(key: String) -> Texture2D:
	var path := asset(key)
	if path == "" or not ResourceLoader.exists(path):
		return null
	return load(path) as Texture2D
