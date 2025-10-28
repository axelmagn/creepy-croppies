class_name ItemManager extends Resource

@export var item_scn: PackedScene
@export var propel_speed: float

func spawn_item(item_config: ItemConfig, location: Vector2, propel: bool) -> void:
	assert(item_scn)
	assert(Game.active_level)
	var item: Item = item_scn.instantiate()
	item.config = item_config
	item.global_position = location
	if propel:
		var angle = randf_range(0, 2*PI)
		item.velocity = Vector2.UP.rotated(angle) * propel_speed
	Game.active_level.add_child(item)