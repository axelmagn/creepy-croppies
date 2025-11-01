class_name GameOverMenu extends Control

@export var retry_button: Button
@export var main_menu_button: Button
@export var win: bool = false

var _init_process_mode: ProcessMode

func _ready() -> void:
	assert(retry_button)
	assert(main_menu_button)
	retry_button.pressed.connect(_on_retry_pressed)
	main_menu_button.pressed.connect(_on_main_menu_pressed)
	_init_process_mode = process_mode

func enable() -> void:
	visible = true
	process_mode = _init_process_mode
	retry_button.grab_focus()

func disable() -> void:
	visible = false
	process_mode = Node.PROCESS_MODE_DISABLED

func _on_retry_pressed() -> void:
	# print("retry pressed")
	Game.audio.play_click()
	Game.load_level(Game.main_level_scn)
	get_tree().paused = false
	disable()

func _on_main_menu_pressed() -> void:
	# print("main menu pressed")
	Game.audio.play_click()
	Game.ui.main_menu.enable()
	disable()
