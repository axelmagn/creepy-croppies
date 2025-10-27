extends Node2D

@export var config: PlantConfig
@export var sprite: Sprite2D

var days_alive: int = 0
var active_stage_idx: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	assert(config)
	assert(sprite)
	Game.time.day_start.connect(tick_day)
	update_internals()

func tick_day() -> void:
	days_alive += 1

	# advance stage if possible
	var next_stage = get_next_stage()
	if next_stage and days_alive >= next_stage.day:
		active_stage_idx += 1
		update_internals()


func get_active_stage() -> GrowthStage:
	return config.stages.get(active_stage_idx)

func get_next_stage() -> GrowthStage:
	return config.stages.get(active_stage_idx+1)
	

func update_internals() -> void:
	var stage = get_active_stage()
	sprite.texture = stage.texture
