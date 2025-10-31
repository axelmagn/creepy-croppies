class_name Plant extends Node2D

@export var config: PlantConfig
@export var sprite: Sprite2D

var days_alive: int = 0
var days_watered: int = 0
var active_stage_idx: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	assert(config)
	assert(sprite)
	Game.time.day_end.connect(tick_day)
	update_internals()

func tick_day() -> void:
	days_alive += 1

	if is_watered():
		days_watered += 1

	# advance stage if possible
	var next_stage = get_next_stage()
	if next_stage and days_watered >= next_stage.day:
		active_stage_idx += 1
		update_internals()

func can_harvest() -> bool:
	return get_active_stage().item_drop != null

func get_active_stage() -> GrowthStage:
	return config.stages.get(active_stage_idx)

func get_next_stage() -> GrowthStage:
	return config.stages.get(active_stage_idx+1)
	

func update_internals() -> void:
	var stage = get_active_stage()
	sprite.texture = stage.texture


func harvest() -> void:
	# extract variables and queue free
	var stage = get_active_stage()
	var pos = global_position
	queue_free()

	# unwater tile
	# var tcoord = Game.active_level.terrain.get_showing_cell(pos)
	# printt("unwatering terrain:", str(tcoord.layer), str(tcoord.coord))
	# assert(tcoord)
	# Game.active_level.terrain.unwater(tcoord)

	# drop items
	if stage.item_drop:
		var n_items = randi_range(stage.item_drop.min_count, stage.item_drop.max_count)
		for _i in range(n_items):
			Game.items.spawn_item(stage.item_drop.item, pos, true)
	if stage.seed_drop:
		var seed_days = days_watered - stage.day
		var min_seeds = min(stage.seed_drop.min_count, seed_days)
		var max_seeds = min(stage.seed_drop.max_count, seed_days)
		var n_seeds = randi_range(min_seeds, max_seeds)
		for _i in range(n_seeds):
			Game.items.spawn_item(stage.seed_drop.item, pos, true)

func is_watered() -> bool:
	var tcoord = Game.active_level.terrain.get_showing_cell(global_position)
	assert(tcoord)
	return Game.active_level.terrain.is_watered(tcoord)
