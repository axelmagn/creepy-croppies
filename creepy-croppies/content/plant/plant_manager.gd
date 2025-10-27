class_name PlantManager extends Resource

@export var plant_scn: PackedScene

func _ready() -> void:
	assert(plant_scn)


## place a plant without any sort of checks
func place_plant(location: Vector2, config: PlantConfig) -> void:
	assert(plant_scn)
	var plant: Plant = plant_scn.instantiate()
	plant.global_position = location
	plant.config = config
	Game.active_level.add_child(plant)
