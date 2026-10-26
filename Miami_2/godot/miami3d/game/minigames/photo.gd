class_name MnPhotoMinigame
extends Control
## Selfie de perfil — aceitar/refazer.

signal finished(kept: bool)

@onready var preview: ColorRect = $Panel/Preview


func _ready() -> void:
	visible = false
	$Panel/Keep.pressed.connect(func(): visible = false; finished.emit(true))
	$Panel/Retry.pressed.connect(_retry)


func start() -> void:
	visible = true
	_retry()


func _retry() -> void:
	preview.color = Color(randf(), randf() * 0.5 + 0.3, randf() * 0.4 + 0.4)
