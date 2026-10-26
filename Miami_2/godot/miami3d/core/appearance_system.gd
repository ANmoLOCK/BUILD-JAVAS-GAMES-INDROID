class_name MnAppearanceSystem
extends RefCounted
## Vetor [gênero, pele, cabelo, corCabelo, top, corTop, bottom, corBottom, calçado, corCalçado].

const SLOT_INDEX := {
	"skin": 1,
	"hair": 2, "hair_color": 3,
	"top": 4, "top_color": 5,
	"bottom": 6, "bottom_color": 7,
	"shoes": 8, "shoes_color": 9,
}

var player_name: String = "Você"
var gender: String = "m" # m|f
var vector: Array = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
var sex_appeal_bonus: int = 0


func set_from_creator(p_name: String, p_gender: String, v: Array) -> void:
	player_name = p_name
	gender = p_gender
	vector = v.duplicate()
	while vector.size() < 10:
		vector.append(0)
	vector[0] = 0 if p_gender == "m" else 1


func equip_slot(slot: String, variant: int, color: int = -1) -> bool:
	## Aplica peça no vetor de aparência (closet / loja).
	if not SLOT_INDEX.has(slot):
		return false
	_ensure_len()
	vector[SLOT_INDEX[slot]] = variant
	if color >= 0:
		var color_key := slot + "_color"
		if SLOT_INDEX.has(color_key):
			vector[SLOT_INDEX[color_key]] = color
	return true


func cycle_slot(slot: String, max_variants: int = 6) -> int:
	_ensure_len()
	if not SLOT_INDEX.has(slot):
		return -1
	var i: int = SLOT_INDEX[slot]
	vector[i] = (int(vector[i]) + 1) % maxi(1, max_variants)
	return int(vector[i])


func sex_appeal_total(base_stat: int) -> int:
	return clampi(base_stat + sex_appeal_bonus, 0, 100)


func _ensure_len() -> void:
	while vector.size() < 10:
		vector.append(0)


func to_dict() -> Dictionary:
	return {"name": player_name, "gender": gender, "appearance": vector.duplicate(), "sex_appeal_bonus": sex_appeal_bonus}


func from_dict(d: Dictionary) -> void:
	player_name = str(d.get("name", "Você"))
	gender = str(d.get("gender", "m"))
	vector = d.get("appearance", [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]).duplicate()
	_ensure_len()
	sex_appeal_bonus = int(d.get("sex_appeal_bonus", 0))
