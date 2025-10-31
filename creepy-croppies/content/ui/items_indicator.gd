class_name ItemsIndicator extends PanelContainer

@export var item_grid: GridContainer

var item_container: ItemContainer

func _ready() -> void:
	assert(item_grid)
	if item_container:
		update_item_grid()
	else:
		if Game.player_items:
			set_item_container(Game.player_items)
		Game.player_items_changed.connect(set_player_item_container)

func set_player_item_container() -> void:
	set_item_container(Game.player_items)

func set_item_container(container: ItemContainer) -> void:
	item_container = container
	item_container.items_changed.connect(update_item_grid)
	update_item_grid()

func update_item_grid() -> void:
	for child in item_grid.get_children():
		child.queue_free()
	var items = Game.player_items.items.keys()
	items.sort_custom(cmp_items)
	for item in items:
		var icon = TextureRect.new()
		icon.texture = item.texture
		icon.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST_WITH_MIPMAPS
		icon.custom_minimum_size = Vector2(32, 32)
		item_grid.add_child(icon)
		var label = Label.new()
		label.text = "%d" % Game.player_items.items[item]
		item_grid.add_child(label)
		
func cmp_items(k1: ItemConfig, k2: ItemConfig) -> bool:
	return k1.sort_score() < k2.sort_score()
