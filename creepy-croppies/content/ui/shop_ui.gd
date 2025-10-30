class_name ShopUi extends Control

signal close

@export var close_button : Button
@export var sell_all_button : Button
@export var buy_section : BoxContainer
@export var sell_section : BoxContainer
@export var shop_item : PackedScene

var _init_process_mode: ProcessMode

func _ready() -> void:
	assert(close_button)
	assert(sell_all_button)
	assert(buy_section)
	assert(sell_section)
	close_button.connect("pressed", _on_close_button_pressed)
	sell_all_button.connect("pressed", _on_sell_all_button_pressed)
	_init_process_mode = process_mode
	update_view()

func enable() -> void:
	visible = true
	process_mode = _init_process_mode

func disable() -> void:
	visible = false
	process_mode = Node.PROCESS_MODE_DISABLED
	
func update_view():
	for n in buy_section.get_children():
		n.queue_free()
	for n in sell_section.get_children():
		n.queue_free()
	
	for item_config in Game.item_registry.items:
		if item_config.buyable:
			var shop_item: ShopItem = shop_item.instantiate()
			shop_item.item_config = item_config
			shop_item.type = ShopItem.ShopItemType.BUY
			buy_section.add_child(shop_item)
		
		if item_config.sellable:
			var shop_item: ShopItem = shop_item.instantiate()
			shop_item.item_config = item_config
			shop_item.type = ShopItem.ShopItemType.SELL
			sell_section.add_child(shop_item)

func _on_close_button_pressed() -> void:
	print("close button pressed")
	close.emit()

func _on_sell_all_button_pressed() -> void:
	for item_config in Game.player_items.items:
		if not item_config.sellable:
			continue
			
		var count:int = Game.player_items.items[item_config]
		Game.player_items.add_item(item_config, -count)
		Game.player_money += item_config.price * count
		
