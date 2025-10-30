class_name RentManager extends Node

func _ready() -> void:
	# tmp: game over on new day
	Game.time.day_end.connect(trigger_game_over)

func trigger_game_over() -> void:
	get_tree().paused = true
	Game.ui.game_over_menu.enable()
