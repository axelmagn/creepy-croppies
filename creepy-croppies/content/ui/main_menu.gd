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
	if OS.get_name() == "Web":
		exit_button.disabled = true
		exit_button.visible = false
	play_button.grab_focus()

func enable() -> void:
	visible = true
	process_mode = _init_process_mode
	get_tree().paused = true
	play_button.grab_focus()

func disable() -> void:
	visible = false
	process_mode = Node.PROCESS_MODE_DISABLED
	get_tree().paused = false

func _on_play_pressed() -> void:
	# print("play pressed")
	Game.audio.play_click()
	Game.load_level(Game.main_level_scn)
	disable()

func _on_exit_pressed() -> void:
	# print("exit pressed")
	Game.audio.play_click()
	get_tree().quit()
