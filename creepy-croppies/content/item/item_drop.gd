class_name ItemDrop extends Resource

@export var item: ItemConfig
@export var min_count: int
@export var max_count: int

func validate() -> void:
	assert(item)
	assert(min_count >= 0)
	assert(min_count <= max_count)