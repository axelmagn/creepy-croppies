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
	
func _process(delta: float) -> void:
	sell_all_button.disabled = !Game.player_items.has_items_to_sell()

func enable() -> void:
	visible = true
	process_mode = _init_process_mode
	update_view()
	close_button.grab_focus()

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
			var plant = item_config.get_plant()
			if plant:
				shop_item.action_button.tooltip_text = plant.tooltip()
			shop_item.update_view()
			buy_section.add_child(shop_item)

	if Game.player_items != null:
		# printt("found player items")
		var player_items = Game.player_items.items.keys()
		player_items.sort_custom(cmp_player_items)
		for item_config in player_items:
			# printt("found player item:", item_config.name)
			if item_config.sellable:
				var shop_item: ShopItem = shop_item.instantiate()
				shop_item.item_config = item_config
				shop_item.type = ShopItem.ShopItemType.SELL
				shop_item.update_view()
				sell_section.add_child(shop_item)
				shop_item.action_button.disabled = Game.player_items.items.get(shop_item.item_config, 0) > 0

func _on_close_button_pressed() -> void:
	# print("close button pressed")
	Game.audio.play_click()
	close.emit()

func _on_sell_all_button_pressed() -> void:
	Game.audio.play_sell()
	for item_config in Game.player_items.items:
		if not item_config.sellable:
			continue
			
		var count:int = Game.player_items.items[item_config]
		Game.player_items.add_item(item_config, -count)
		var price = item_config.price * count
		Game.player_money += price
		Game.day.stats.add_income(price)
		
func cmp_player_items(k1: ItemConfig, k2: ItemConfig) -> bool:
	return k1.price < k2.price
