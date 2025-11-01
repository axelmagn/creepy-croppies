class_name CutscenesManager extends Node

@export var visitations: Array[Visitation]
@export var win_cutscene: CutsceneConfig
@export var fail_cutscene: CutsceneConfig

func _ready() -> void:
	assert(win_cutscene)
	assert(fail_cutscene)
	Game.time.day_start.connect(_on_day_start)

func _on_day_start() -> void:
	# printt("checking visitations")
	for visitation in visitations:
		if visitation.day == Game.time.day:
			# printt("playing visitation:", visitation)
			Game.ui.cutscene.play(visitation.cutscene)
