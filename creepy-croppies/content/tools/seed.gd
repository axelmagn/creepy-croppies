class_name Seed extends Tool

@export var plant: PlantConfig

func use_primary(user: Character):
	# TODO: seed functionality
	var loc = user.get_interact_point()
	Game.plants.place_plant(loc, plant)
	print("used seed")

