class_name DaySummary extends Control

signal continue_game

@export var continue_button: Button

var _init_process_mode: ProcessMode

func _ready() -> void:
	assert(continue_button)
	continue_button.pressed.connect(_on_continue_pressed)
	_init_process_mode = process_mode

func enable() -> void:
	visible = true
	process_mode = _init_process_mode

func disable() -> void:
	visible = false
	process_mode = Node.PROCESS_MODE_DISABLED

func _on_continue_pressed() -> void:
	print("continue pressed")
	continue_game.emit()