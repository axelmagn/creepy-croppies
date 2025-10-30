class_name CutscenesManager extends Node

@export var visitations: Dictionary[int, CutsceneConfig]

func _ready() -> void:
	Game.time.day_start.connect(_on_day_start)

func _on_day_start() -> void:
	if Game.time.day in visitations:
		printt("playing cutscene")
		Game.ui.cutscene.play(visitations[Game.time.day])
