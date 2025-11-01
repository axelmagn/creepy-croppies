class_name ItemContainer extends Resource

signal items_changed

## item counts for contained items
@export var items: Dictionary[ItemConfig, int]

func add_item(item: ItemConfig, count: int) -> void:
	items[item] = items.get(item, 0) + count
	# printt("item count:", item.name, items[item])
	items_changed.emit()
	
func has_enough(item: ItemConfig, count: int) -> bool:
	return items.get(item, 0) >= count

func reset() -> void:
	items.clear()
	
func has_items_to_sell() -> bool:
	for item in items:
		if item.sellable && items[item] > 0:
			return true
	return false