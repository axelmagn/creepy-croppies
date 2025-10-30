class_name ShopItem extends Node

enum ShopItemType { BUY, SELL }

@export var item_config: ItemConfig
@export var icon: TextureRect
@export var name_label: Label
@export var price_label: Label
@export var action_button: Button
@export var type: ShopItemType

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	assert(item_config)
	assert(icon)
	assert(name_label)
	assert(price_label)
	assert(action_button)
	action_button.connect("pressed", action)
	update_view()
	
func _process(delta: float) -> void:
	if type == ShopItemType.BUY:
		action_button.disabled = Game.player_money < item_config.price
	else:
		action_button.disabled = !Game.player_items.has_enough(item_config, 1)

func update_view() -> void:
	icon.texture = item_config.texture
	name_label.text = item_config.name
	price_label.text = str(item_config.price)
	
func action() -> void:
	if type == ShopItemType.BUY:
		buy()
	else:
		sell()
	
func buy() -> void:
	var multiplier: int = 1
	if Input.is_key_pressed(KEY_SHIFT):
		multiplier = 10
		
	var price = item_config.price * multiplier
	if Game.player_money < price:
		return
		
	Game.player_items.add_item(item_config, 1 * multiplier)
	Game.player_money -= price
	Game.day.stats.add_expense(price)
	Game.audio.play_pick_up()

func sell() -> void:
	var multiplier: int = 1
	if Input.is_key_pressed(KEY_SHIFT):
		multiplier = 10
		
	if !Game.player_items.has_enough(item_config, 1 * multiplier):
		return
		
	Game.player_items.add_item(item_config, -1 * multiplier)
	var price =item_config.price * multiplier
	Game.player_money += price
	Game.day.stats.add_income(price)
	Game.audio.play_sell()
