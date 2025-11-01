extends Area2D

@export var bridge: Bridge

func _ready() -> void:
	assert(bridge)
	
func interact():
	# print("interact")
	if bridge.is_fixed:
		return
		
	Game.ui.bridge_menu.bridge = bridge
	Game.ui.bridge_menu.enable()
