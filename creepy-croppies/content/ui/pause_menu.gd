class_name PauseMenu extends Control

@export var continue_button: Button
@export var exit_button: Button


func _ready() -> void:
	assert(continue_button)
	assert(exit_button)
	continue_button.pressed.connect(_on_continue)
	exit_button.pressed.connect(_on_exit)

func enable() -> void:
	visible = true
	process_mode = Node.PROCESS_MODE_ALWAYS
	get_tree().paused = true
	continue_button.grab_focus()

func disable() -> void:
	visible = false
	process_mode = Node.PROCESS_MODE_DISABLED
	get_tree().paused = false

func _on_continue():
	disable()
	
func _on_exit():
	disable()
	Game.ui.main_menu.enable()
