class_name ItemConfig extends Resource

@export var name: String = ""
@export var texture: Texture
@export var price: int = 1
@export var buyable: bool = false
@export var sellable: bool = true
@export_file var plant_path: String

func get_plant() -> PlantConfig:
	return load(plant_path)

func is_seed() -> bool:
	return name.ends_with("Seed")

func sort_score() -> int:
	var score = price
	if not is_seed():
		score += 1000
	return score
