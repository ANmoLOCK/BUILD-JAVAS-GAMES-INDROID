class_name MnHomeSystem
extends RefCounted
## Níveis LOW/MID_A/MID_B/HI, slots de móvel, anões, colega de quarto.

var tier: int = MnTypes.HomeTier.LOW
var slots: Dictionary = {} # slot_id -> item_id
var gnomes_found: Dictionary = {} # gnome_id -> true
var roommate_id: String = ""


func set_furniture(slot_id: String, item_id: String) -> void:
	slots[slot_id] = item_id


func find_gnome(gnome_id: String) -> void:
	gnomes_found[gnome_id] = true


func gnomes_count() -> int:
	return gnomes_found.size()


func set_roommate(npc_id: String) -> void:
	roommate_id = npc_id


func clear_roommate() -> void:
	roommate_id = ""


func to_dict() -> Dictionary:
	return {
		"tier": tier,
		"slots": slots.duplicate(),
		"gnomes": gnomes_found.keys(),
		"roommate": roommate_id,
	}


func from_dict(d: Dictionary) -> void:
	tier = int(d.get("tier", 0))
	slots = d.get("slots", {}).duplicate()
	gnomes_found.clear()
	for g in d.get("gnomes", []):
		gnomes_found[str(g)] = true
	roommate_id = str(d.get("roommate", ""))
