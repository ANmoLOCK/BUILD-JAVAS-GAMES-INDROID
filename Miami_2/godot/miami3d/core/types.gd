class_name MnTypes
extends Object
## Enums e constantes compartilhadas pelo cérebro (sem Node).

enum StatId {
	HUNGER, SLEEP, HYGIENE, BLADDER,
	FITNESS, CULTURE, CHARISMA, CRIME,
	KINDNESS, DANCE, CRAZINESS, SEX_APPEAL,
	MOOD, SOCIAL, HEALTH, SELF_ESTEEM,
}

const STAT_IDS: PackedStringArray = [
	"hunger", "sleep", "hygiene", "bladder",
	"fitness", "culture", "charisma", "crime",
	"kindness", "dance", "craziness", "sex_appeal",
	"mood", "social", "health", "self_esteem",
]

enum SocialMenu { TALK, OFFER, FLIRT, OFFEND }

enum EventKind {
	TALKED_TO, USED_OBJECT, ENTERED, LEFT, TIME,
	STAT_CHANGED, ITEM_GAINED, DATE_STARTED, SLEPT, PERIODIC, SHOWERED,
}

enum NpcFlag {
	KNOWN = 1,
	PHONE = 2,
	DATING = 4,
	ROOMMATE = 8,
	ENEMY = 16,
	BLOCKED = 32,
}

enum HomeTier { LOW, MID_A, MID_B, HI }

const FACINGS: PackedStringArray = ["N", "NE", "E", "SE", "S", "SW", "W", "NW"]

static func stat_index(id: String) -> int:
	return STAT_IDS.find(id)


static func event_name(kind: EventKind) -> String:
	match kind:
		EventKind.TALKED_TO: return "talked_to"
		EventKind.USED_OBJECT: return "used_object"
		EventKind.ENTERED: return "entered"
		EventKind.LEFT: return "left"
		EventKind.TIME: return "time"
		EventKind.STAT_CHANGED: return "stat_changed"
		EventKind.ITEM_GAINED: return "item_gained"
		EventKind.DATE_STARTED: return "date_started"
		EventKind.SLEPT: return "slept"
		EventKind.PERIODIC: return "periodic"
		EventKind.SHOWERED: return "showered"
	return ""
