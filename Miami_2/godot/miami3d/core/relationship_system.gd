class_name MnRelationshipSystem
extends RefCounted
## NPCs: amizade −100..100, romance 0..100, humor, flags, interesses.

class NpcState:
	var id: String = ""
	var friendship: int = 0
	var romance: int = 0
	var mood: int = 50
	var flags: int = 0
	var likes: PackedStringArray = []
	var dislikes: PackedStringArray = []
	var interactions_today: int = 0
	var gifts_today: int = 0
	var last_day: int = -1

	func friendship_level() -> int:
		# 0..4 estrelas (20 cada)
		var f := clampi(friendship, 0, 100)
		return mini(4, f / 20)

	func to_dict() -> Dictionary:
		return {
			"friendship": friendship, "romance": romance, "mood": mood,
			"flags": flags, "likes": Array(likes), "dislikes": Array(dislikes),
			"interactions_today": interactions_today, "gifts_today": gifts_today,
		}

	func from_dict(d: Dictionary) -> void:
		friendship = int(d.get("friendship", 0))
		romance = int(d.get("romance", 0))
		mood = int(d.get("mood", 50))
		flags = int(d.get("flags", 0))
		likes = PackedStringArray(d.get("likes", []))
		dislikes = PackedStringArray(d.get("dislikes", []))
		interactions_today = int(d.get("interactions_today", 0))
		gifts_today = int(d.get("gifts_today", 0))


var events: MnEvents
var npcs: Dictionary = {} # id -> NpcState
var _day_seen: int = -1


func setup(ev: MnEvents) -> void:
	events = ev


func ensure(npc_id: String, def: Dictionary = {}) -> NpcState:
	if npcs.has(npc_id):
		return npcs[npc_id]
	var s := NpcState.new()
	s.id = npc_id
	var init: Dictionary = def.get("initial", {})
	s.friendship = int(init.get("friendship", 0))
	s.romance = int(init.get("romance", 0))
	s.mood = int(init.get("mood", 50))
	s.likes = PackedStringArray(def.get("likes", []))
	s.dislikes = PackedStringArray(def.get("dislikes", []))
	npcs[npc_id] = s
	return s


func get_npc(npc_id: String) -> NpcState:
	return npcs.get(npc_id)


func friendship_level(npc_id: String) -> int:
	var s := get_npc(npc_id)
	return s.friendship_level() if s else 0


func count_friends_at_least_level(level: int) -> int:
	var n := 0
	for id in npcs.keys():
		if npcs[id].friendship_level() >= level:
			n += 1
	return n


func apply_delta(npc_id: String, friendship: int = 0, romance: int = 0, mood: int = 0) -> void:
	var s := ensure(npc_id)
	s.friendship = clampi(s.friendship + friendship, -100, 100)
	s.romance = clampi(s.romance + romance, 0, 100)
	s.mood = clampi(s.mood + mood, 0, 100)
	s.flags |= MnTypes.NpcFlag.KNOWN


func on_hour_tick() -> void:
	for id in npcs.keys():
		var s: NpcState = npcs[id]
		# humor decai 2/h até 50
		if s.mood > 50:
			s.mood = maxi(50, s.mood - 2)
		elif s.mood < 50:
			s.mood = mini(50, s.mood + 1)
		# relacionamento secundário −5/h até piso leve
		if s.romance > 0:
			s.romance = maxi(0, s.romance - 1)


func on_day_tick(day: int) -> void:
	if day == _day_seen:
		return
	_day_seen = day
	for id in npcs.keys():
		npcs[id].interactions_today = 0
		npcs[id].gifts_today = 0


func to_dict() -> Dictionary:
	var out := {}
	for id in npcs.keys():
		out[id] = npcs[id].to_dict()
	return out


func from_dict(d: Dictionary) -> void:
	npcs.clear()
	for id in d.keys():
		var s := NpcState.new()
		s.id = str(id)
		s.from_dict(d[id])
		npcs[id] = s
