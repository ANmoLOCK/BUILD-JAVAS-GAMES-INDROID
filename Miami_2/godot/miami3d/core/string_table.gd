class_name MnStringTable
extends RefCounted
## Resolve chaves @… e tags {player}, {npc}, {place}, {m:…|f:…}.

var _strings: Dictionary = {} # key -> text
var player_name: String = "Você"
var player_gender: String = "m" # "m" | "f"
var npc_name: String = ""
var place_name: String = ""


func load_map(data: Dictionary) -> void:
	_strings = data.duplicate()


func has_key(key: String) -> bool:
	return _strings.has(_strip(key))


func raw(key: String) -> String:
	var k := _strip(key)
	return str(_strings.get(k, key))


func resolve(key_or_text: String, ctx: Dictionary = {}) -> String:
	var text := key_or_text
	if text.begins_with("@"):
		text = raw(text)
	var pname: String = str(ctx.get("player", player_name))
	var nname: String = str(ctx.get("npc", npc_name))
	var place: String = str(ctx.get("place", place_name))
	var gender: String = str(ctx.get("gender", player_gender))
	text = text.replace("{player}", pname)
	text = text.replace("{npc}", nname)
	text = text.replace("{place}", place)
	text = text.replace("{x}", pname)
	text = text.replace("{d}", nname)
	text = text.replace("{o}", place)
	# {m:masc|f:fem}
	var re := RegEx.new()
	re.compile("\\{m:([^}|]*)\\|f:([^}]*)\\}")
	for m in re.search_all(text):
		var repl := m.get_string(1) if gender == "m" else m.get_string(2)
		text = text.replace(m.get_string(0), repl)
	# [b]…[/b] já é BBCode Godot
	return text


func _strip(key: String) -> String:
	return key.substr(1) if key.begins_with("@") else key
