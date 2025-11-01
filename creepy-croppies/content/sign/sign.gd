class_name Sign extends Area2D

@export var cutscene: CutsceneConfig

func _ready() -> void:
	assert(cutscene)

func interact() -> void:
	# printt("sign interacted")
	Game.ui.cutscene.play(cutscene)
