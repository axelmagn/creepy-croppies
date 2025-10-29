class_name ShopUi extends Control

signal close

@export var close_button : Button

var _init_process_mode: ProcessMode

func _ready() -> void:
	assert(close_button)
	close_button.connect("pressed", _on_close_button_pressed)
	_init_process_mode = process_mode

func enable() -> void:
	visible = true
	process_mode = _init_process_mode

func disable() -> void:
	visible = false
	process_mode = Node.PROCESS_MODE_DISABLED

func _on_close_button_pressed() -> void:
	print("close button pressed")
	close.emit()
