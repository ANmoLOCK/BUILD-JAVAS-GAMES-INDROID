class_name MnAnimationMap
extends RefCounted
## Estado lógico → nome de clipe 3D (AnimationTree / anims_human.glb).

const CLIPS := {
	"idle": "idle",
	"walk": "walk",
	"run": "run",
	"sit": "sit",
	"sleep": "sleep",
	"eat": "eat",
	"drink": "drink",
	"talk": "talk",
	"laugh": "laugh",
	"angry": "angry",
	"wave": "wave",
	"shower": "shower",
	"pee": "pee",
	"dance_techno": "dance_techno",
	"dance_salsa": "dance_salsa",
	"dance_pop": "dance_pop",
	"dance_metal": "dance_metal",
	"kiss": "kiss",
	"fight": "fight",
	"faint": "faint",
	"swim": "swim",
	"piano": "piano",
	"lift": "lift",
	"sweep": "sweep",
	"cook": "cook",
	"work_bar": "work_bar",
	"work_poster": "work_poster",
	"work_delivery": "work_delivery",
	"work_extra": "work_extra",
	"use": "use",
	"give": "give",
	"nap": "sleep",
	"take_shower": "shower",
	"use_toilet": "pee",
	"snack": "eat",
	"sunbathe": "sit",
	"relax": "sit",
	"mix_music": "work_bar",
	"play_piano": "piano",
	"lift_weights": "lift",
	"post_posters": "work_poster",
	"deliver_pizza": "work_delivery",
}


static func clip_for(state: String) -> String:
	return str(CLIPS.get(state, CLIPS.get(state.to_lower(), "idle")))


static func all_clips() -> PackedStringArray:
	var seen := {}
	var out: PackedStringArray = []
	for v in CLIPS.values():
		if not seen.has(v):
			seen[v] = true
			out.append(str(v))
	return out
