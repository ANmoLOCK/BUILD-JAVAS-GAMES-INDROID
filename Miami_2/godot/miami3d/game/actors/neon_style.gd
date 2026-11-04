class_name MnNeonStyle
extends RefCounted
## Neon Nightlife — estilo Everwind 2D/3D + presets M/F + avarias.

const STYLE_ID := "neon_nightlife"
const ROOT := "res://assets/characters/neon_nightlife"

const PRESET_M := [0, 2, 8, 0, 12, 4, 10, 0, 6, 0]
const PRESET_F := [1, 2, 10, 0, 18, 0, 8, 0, 9, 0]

## Cores marca Miami Life / neon
const COL_MAGENTA := Color(0.95, 0.22, 0.55)
const COL_CYAN := Color(0.25, 0.9, 0.95)
const COL_NAVY := Color(0.05, 0.08, 0.14)
const COL_SKIN_M := Color(0.78, 0.58, 0.45)
const COL_SKIN_F := Color(0.86, 0.68, 0.52)
const COL_HAIR := Color(0.12, 0.1, 0.12)
const COL_BLAZER := Color(0.08, 0.08, 0.1)
const COL_SHIRT := Color(0.92, 0.18, 0.55)
const COL_PANTS := Color(0.1, 0.1, 0.12)
const COL_DRESS := Color(0.95, 0.95, 0.98)
const COL_HEEL := Color(0.92, 0.92, 0.95)

## Expressões (atlas 6 colunas)
const FACE_IDLE := 0
const FACE_TALK := 1
const FACE_LAUGH := 2
const FACE_ANGRY := 3
const FACE_KISS := 4
const FACE_FAINT := 5

## Avarias / condições visuais
const CONDITION_NONE := ""
const CONDITION_DIRTY := "dirty"
const CONDITION_WET := "wet"
const CONDITION_BRUISED := "bruised"
const CONDITION_SWEATY := "sweaty"
const CONDITION_DUSTY := "dusty"
const CONDITION_TIRED := "tired"

const CONDITION_ATLAS := {
	"dirty": 0,
	"wet": 1,
	"bruised": 2,
	"sweaty": 3,
	"dusty": 4,
	"tired": 5,
}


static func body_tex(gender: String) -> String:
	var g := "m" if gender != "f" else "f"
	var jpg := "%s/textures/body_%s_front.jpg" % [ROOT, g]
	var png := "%s/textures/body_%s_front.png" % [ROOT, g]
	if ResourceLoader.exists(png):
		return png
	return jpg


static func faces_tex() -> String:
	var jpg := "%s/faces/faces_sheet.jpg" % ROOT
	var png := "%s/faces/faces_sheet.png" % ROOT
	if ResourceLoader.exists(png):
		return png
	return jpg


static func avarias_tex() -> String:
	var jpg := "%s/overlays/avarias_sheet.jpg" % ROOT
	var png := "%s/overlays/avarias_sheet.png" % ROOT
	if ResourceLoader.exists(png):
		return png
	return jpg


static func preset_vector(gender: String) -> Array:
	return PRESET_F.duplicate() if gender == "f" else PRESET_M.duplicate()


static func matches(gender: String, v: Array) -> bool:
	## True se o vetor é o preset Neon ou usa as variantes Neon nos slots chave.
	if v.is_empty():
		return false
	var target: Array = preset_vector(gender)
	if v.size() >= 10:
		var same := true
		for i in range(1, 10):
			if int(v[i]) != int(target[i]):
				same = false
				break
		if same:
			return true
	# variantes Neon: top_m_12 / top_f_18 etc.
	var top := int(v[4]) if v.size() > 4 else -1
	var hair := int(v[2]) if v.size() > 2 else -1
	if gender == "f":
		return top == 18 or hair == 10
	return top == 12 or hair == 8


static func face_for_anim(clip: String) -> int:
	match clip:
		"talk", "use", "give", "wave":
			return FACE_TALK
		"laugh":
			return FACE_LAUGH
		"angry", "fight":
			return FACE_ANGRY
		"kiss":
			return FACE_KISS
		"faint", "sleep":
			return FACE_FAINT
		_:
			return FACE_IDLE


static func condition_from_stats(hygiene: int, energy: int, in_fight: bool, wet: bool) -> String:
	if in_fight:
		return CONDITION_BRUISED
	if wet:
		return CONDITION_WET
	if hygiene < 25:
		return CONDITION_DIRTY
	if hygiene < 45:
		return CONDITION_SWEATY
	if energy < 20:
		return CONDITION_TIRED
	return CONDITION_NONE
