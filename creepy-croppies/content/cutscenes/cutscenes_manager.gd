class_name CutscenesManager extends Node

@export var visitations: Array[Visitation]

func _ready() -> void:
	Game.time.day_start.connect(_on_day_start)

func _on_day_start() -> void:
	printt("checking visitations")
	for visitation in visitations:
		if visitation.day == Game.time.day:
			printt("playing visitation:", visitation)
			Game.ui.cutscene.play(visitation.cutscene)