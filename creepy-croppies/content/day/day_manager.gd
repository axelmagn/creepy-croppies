class_name DayManager extends Node

@export var time: GameTime
@export var ui: MainUI

var stats: DayStats = DayStats.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	assert(time)
	assert(ui)
	time.day_start.connect(_on_day_start)
	time.day_end.connect(_on_day_end)
	ui.day_summary.continue_game.connect(_on_start_next_day)
	printt("player money on day manager ready:", Game.player_money)
	stats.reset()

func _on_day_start() -> void:
	print("day start")
	printt("player money on day start:", Game.player_money)
	stats.reset()

func _on_day_end() -> void:
	print("day end")
	ui.day_summary.enable()
	Game.pause_game()
	
func _on_start_next_day() -> void:
	print("continue game")
	ui.day_summary.disable()
	Game.unpause_game()
	Game.time.advance_day()
