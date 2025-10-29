class_name DayManager extends Node

@export var time: GameTime
@export var ui: MainUI

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	assert(time)
	assert(ui)
	time.day_start.connect(_on_day_start)
	time.day_end.connect(_on_day_end)
	ui.day_summary.disable()
	ui.day_summary.continue_game.connect(_on_start_next_day)

func _on_day_start() -> void:
	print("day start")

func _on_day_end() -> void:
	print("day end")
	time.stop()
	ui.day_summary.enable()
	get_tree().paused = true
	
func _on_start_next_day() -> void:
	print("continue game")
	time.start()
	ui.day_summary.disable()
	get_tree().paused = false
