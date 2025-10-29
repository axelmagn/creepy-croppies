class_name ItemsIndicator extends PanelContainer

@export var item_grid: GridContainer

var item_container: ItemContainer

func _ready() -> void:
	assert(item_grid)
	if not item_container:
		item_container = Game.player_items
	item_container.items_changed.connect(update_item_grid)
	update_item_grid()

func update_item_grid() -> void:
	for child in item_grid.get_children():
		child.queue_free()
	var items = Game.player_items.items.keys()
	items.sort()
	for item in items:
		var icon = TextureRect.new()
		icon.texture = item.texture
		icon.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST_WITH_MIPMAPS
		icon.custom_minimum_size = Vector2(32, 32)
		item_grid.add_child(icon)
		var label = Label.new()
		label.text = "%d" % Game.player_items.items[item]
		item_grid.add_child(label)
