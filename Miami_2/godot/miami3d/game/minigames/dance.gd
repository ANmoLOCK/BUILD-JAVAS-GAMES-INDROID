class_name MnDanceMinigame
extends Control
## Sequência de setas (TECHNO/SALSA/POP/METAL).

signal finished(won: bool, score: int)

@onready var prompt: Label = $Panel/Prompt
@onready var score_l: Label = $Panel/Score

var style: String = "techno"
var sequence: Array[String] = []
var index: int = 0
var score: int = 0
var mistakes: int = 0
const ARROWS := {"ui_up": "↑", "ui_down": "↓", "ui_left": "←", "ui_right": "→"}


func _ready() -> void:
	visible = false


func start(p_style: String = "techno", length: int = 6) -> void:
	style = p_style
	sequence.clear()
	var keys := ARROWS.keys()
	for i in length:
		sequence.append(str(keys[randi() % keys.size()]))
	index = 0
	score = 0
	mistakes = 0
	visible = true
	_update()


func _update() -> void:
	if index >= sequence.size():
		visible = false
		finished.emit(true, score)
		return
	prompt.text = "%s  [%s]" % [ARROWS[sequence[index]], style.to_upper()]
	score_l.text = "Pontos %d  Erros %d" % [score, mistakes]


func _unhandled_input(event: InputEvent) -> void:
	if not visible:
		return
	for action in ARROWS.keys():
		if event.is_action_pressed(action):
			if action == sequence[index]:
				score += 10
				index += 1
			else:
				mistakes += 1
				if mistakes >= 3:
					visible = false
					finished.emit(false, score)
					return
			_update()
			get_viewport().set_input_as_handled()
			return
