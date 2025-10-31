class_name Sign extends Area2D

@export var cutscene: CutsceneConfig

func _ready() -> void:
	assert(cutscene)

func interact() -> void:
	Game.ui.cutscenes.play(cutscene)
