class_name CutsceneTrigger extends Area2D

@export var cutscene: CutsceneConfig
@export var finished: bool = false

func _ready() -> void:
	assert(cutscene)
	body_entered.connect(play_cutscene)
	# area_entered.connect(play_cutscene)

func play_cutscene(_other) -> void:
	# printt("body entered cutscene area")
	if not finished:
		finished = true
		Game.ui.cutscene.play(cutscene)
