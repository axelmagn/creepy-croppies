class_name Shop extends Area2D

var is_showing: bool = false
var is_interactable := true

func _ready() -> void:
	Game.ui.shop_ui.close.connect(hide_shop)
	Game.ui.shop_ui.disable()
		
func interact():
	# print("interact")
	if !is_interactable:
		return
	
	if is_showing:
		hide_shop()
	else:
		show_shop()

func show_shop() -> void:
	# print("show_shop")
	Game.ui.shop_ui.enable()
	Game.pause_game()
	is_showing = true
	
func hide_shop() -> void:
	# print("hide_shop")
	Game.ui.shop_ui.disable()
	Game.unpause_game()
	is_showing = false
