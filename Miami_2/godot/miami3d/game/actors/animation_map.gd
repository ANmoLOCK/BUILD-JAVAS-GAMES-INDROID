class_name MnAnimationMap
extends RefCounted
## Estado lógico → nome de clipe 3D (AnimationTree / AnimationPlayer).

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
	"cook": "cook",
	"work_bar": "work_bar",
	"work_poster": "work_poster",
	"work_delivery": "work_delivery",
}


static func clip_for(state: String) -> String:
	return str(CLIPS.get(state, "idle"))
