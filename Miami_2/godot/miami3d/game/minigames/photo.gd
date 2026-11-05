class_name MnPhotoMinigame
extends Control
## Selfie de perfil — aceitar/refazer.

signal finished(won: bool, score: int)

@onready var preview: ColorRect = $Panel/VBox/Preview


func _ready() -> void:
	visible = false
	$Panel/VBox/Keep.pressed.connect(func(): visible = false; finished.emit(true, 100))
	$Panel/VBox/Retry.pressed.connect(_retry)


func start(_style: String = "") -> void:
	visible = true
	_retry()


func _retry() -> void:
	if preview:
		preview.color = Color(randf(), randf() * 0.5 + 0.3, randf() * 0.4 + 0.4)
