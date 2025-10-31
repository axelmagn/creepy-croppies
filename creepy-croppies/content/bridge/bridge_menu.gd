class_name BridgeMenu extends Control

@export var fix_button: Button
@export var close_button: Button

var bridge: Bridge

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	assert(fix_button)
	assert(close_button)
	fix_button.pressed.connect(_on_fix_button_pressed)
	close_button.pressed.connect(_on_close_button_pressed)
	
func _process(_delta: float) -> void:
	if bridge == null:
		return
		
	fix_button.disabled = Game.player_money < bridge.fix_cost
	
func enable() -> void:
	visible = true
	update_view()
	close_button.grab_focus()
	Game.pause_game()

func disable() -> void:
	visible = false
	Game.unpause_game()
	
func update_view() -> void:
	fix_button.text = "Fix: $" + str(bridge.fix_cost)
	
func _on_close_button_pressed() -> void:
	disable()
	Game.audio.play_click()
	
func _on_fix_button_pressed() -> void:
	if bridge == null:
		return
		
	bridge.fix()
	disable()
	Game.audio.play_click()
