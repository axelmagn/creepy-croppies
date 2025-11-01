class_name DaySummary extends Control

signal continue_game

@export var continue_button: Button
@export var day_stats: DayStatsContent

@export var win_text: String = "You Win"
@export var success_text: String = "Next Day"
@export var fail_text: String = "You're Broke!"

var _init_process_mode: ProcessMode

func _ready() -> void:
	assert(continue_button)
	assert(day_stats)
	continue_button.pressed.connect(_on_continue_pressed)
	_init_process_mode = process_mode
	Game.player_money_changed.connect(update_continue_text)
	update_continue_text()

func enable() -> void:
	visible = true
	process_mode = _init_process_mode
	day_stats.update_internals()
	continue_button.grab_focus()


func disable() -> void:
	visible = false
	process_mode = Node.PROCESS_MODE_DISABLED

func _on_continue_pressed() -> void:
	# print("continue pressed")
	Game.audio.play_click()
	continue_game.emit()

func update_continue_text() -> void:
	if Game.player_money < 0:
		continue_button.text = fail_text
	elif Game.rent.rent_idx >= Game.rent.rents.size() - 1: # hack	
		continue_button.text = win_text
	else:
		continue_button.text = success_text
