class_name MnAppearanceSystem
extends RefCounted
## Vetor [gênero, pele, cabelo, corCabelo, top, corTop, bottom, corBottom, calçado, corCalçado].

var player_name: String = "Você"
var gender: String = "m" # m|f
var vector: Array = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
var sex_appeal_bonus: int = 0


func set_from_creator(p_name: String, p_gender: String, v: Array) -> void:
	player_name = p_name
	gender = p_gender
	vector = v.duplicate()
	vector[0] = 0 if p_gender == "m" else 1


func sex_appeal_total(base_stat: int) -> int:
	return clampi(base_stat + sex_appeal_bonus, 0, 100)


func to_dict() -> Dictionary:
	return {"name": player_name, "gender": gender, "appearance": vector.duplicate(), "sex_appeal_bonus": sex_appeal_bonus}


func from_dict(d: Dictionary) -> void:
	player_name = str(d.get("name", "Você"))
	gender = str(d.get("gender", "m"))
	vector = d.get("appearance", [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]).duplicate()
	sex_appeal_bonus = int(d.get("sex_appeal_bonus", 0))
