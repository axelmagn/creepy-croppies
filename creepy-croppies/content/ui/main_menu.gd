class_name MainMenu extends Control

@export var play_button: Button
@export var exit_button: Button

var _init_process_mode: ProcessMode

func _ready() -> void:
	assert(play_button)
	assert(exit_button)
	play_button.pressed.connect(_on_play_pressed)
	exit_button.pressed.connect(_on_exit_pressed)
	_init_process_mode = process_mode

func enable() -> void:
	visible = true
	process_mode = _init_process_mode
	get_tree().paused = true

func disable() -> void:
	visible = false
	process_mode = Node.PROCESS_MODE_DISABLED
	get_tree().paused = false

func _on_play_pressed() -> void:
	print("play pressed")
	Game.load_level(Game.main_level_scn)
	disable()

func _on_exit_pressed() -> void:
	print("exit pressed")
	get_tree().quit()
