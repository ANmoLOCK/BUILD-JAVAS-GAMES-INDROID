extends RefCounted
## Boot da Fase A — chamado indiretamente via MnPhaseDirector + phases.json.
## Mantido para documentação / hooks futuros do corpo.

const PHASE_ID := "a"


static func ready_hint() -> String:
	return "1 dia de jogo sem desmaio, só com necessidades"
