class_name HouseMenu extends Control

@export var go_to_bed_button: Button
@export var close_button: Button

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	assert(go_to_bed_button)
	assert(close_button)
	go_to_bed_button.pressed.connect(_on_skip_day_button_pressed)
	close_button.pressed.connect(_on_close_button_pressed)
	
func enable() -> void:
	visible = true
	close_button.grab_focus()
	Game.pause_game()

func disable() -> void:
	visible = false
	Game.unpause_game()
	
func _on_skip_day_button_pressed() -> void:
	disable()
	Game.audio.play_click()
	Game.time.debug_advance_day()
	
func _on_close_button_pressed() -> void:
	disable()
	Game.audio.play_click()
