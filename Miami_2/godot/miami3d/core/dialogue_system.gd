class_name MnDialogueSystem
extends RefCounted
## Menus sociais + assuntos (like / neutral / dislike).

var events: MnEvents
var game
var topics: Dictionary = {} # category_id -> {interests: [...]}
var reactions: Dictionary = {}


func setup(ev: MnEvents, g = null) -> void:
	events = ev
	game = g


func load_topics(data: Dictionary) -> void:
	topics = data.get("categories", data).duplicate(true) if typeof(data) == TYPE_DICTIONARY else {}


func load_reactions(data: Dictionary) -> void:
	reactions = data.duplicate(true)


func talk_topic(npc_id: String, interest_id: String) -> Dictionary:
	var s = game.relationships.ensure(npc_id)
	s.interactions_today += 1
	var polar := "neutral"
	if interest_id in s.likes:
		polar = "like"
		game.relationships.apply_delta(npc_id, 8, 0, 10)
	elif interest_id in s.dislikes:
		polar = "dislike"
		game.relationships.apply_delta(npc_id, -10, 0, -15)
	else:
		var dim := 2 if s.interactions_today <= 3 else -2
		game.relationships.apply_delta(npc_id, dim, 0, 0)
	var line := _pick_line(interest_id, polar)
	if events:
		events.dialogue_requested.emit({"npc": npc_id, "line": line, "polarity": polar})
	return {"polarity": polar, "line": line}


func social_action(npc_id: String, action_def: Dictionary) -> Dictionary:
	var s = game.relationships.ensure(npc_id)
	var req: Dictionary = action_def.get("requires", {})
	if not game.rules.eval(req, {"npc": npc_id}):
		return {"ok": false, "reason": "requires"}
	var rel: Dictionary = action_def.get("relationship", {})
	var fri := int(rel.get("friendship", 0))
	var rom := int(rel.get("romance", 0))
	var mood := int(rel.get("mood", 0))
	var after := int(action_def.get("diminishingAfter", 99))
	if s.interactions_today >= after:
		fri = mini(fri, 1)
		rom = mini(rom, 0)
		if events:
			events.dialogue_requested.emit({"npc": npc_id, "key": str(action_def.get("reactions", {}).get("bored", "@react.bored"))})
	game.relationships.apply_delta(npc_id, fri, rom, mood)
	s.interactions_today += 1
	if action_def.has("effects"):
		game.stats.apply_effects(action_def["effects"])
	if action_def.has("then"):
		game.rules.run(action_def["then"], {"npc": npc_id})
	if action_def.has("crime"):
		game.crime.note_crime(int(action_def["crime"]), true)
	var ok_key := str(action_def.get("reactions", {}).get("success", ""))
	if ok_key != "" and events:
		events.dialogue_requested.emit({"npc": npc_id, "key": ok_key})
	return {"ok": true}


func _pick_line(interest_id: String, polar: String) -> String:
	# busca simplificada nas categorias carregadas
	var cats = topics.get("categories", topics) if topics.has("categories") else topics
	if typeof(cats) == TYPE_ARRAY:
		for cat in cats:
			for interest in cat.get("interests", []):
				if str(interest.get("id", "")) == interest_id:
					var lines: Dictionary = interest.get("lines", {})
					var key := "npcLike" if polar == "like" else ("npcDislike" if polar == "dislike" else "npcNeutral")
					var arr: Array = lines.get(key, lines.get("npcNeutral", []))
					if arr.is_empty():
						return "@topic.fallback"
					return str(arr[randi() % arr.size()])
	return "@topic.fallback"
