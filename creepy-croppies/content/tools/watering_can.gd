class_name WateringCan extends Tool

func use_primary(user: Character):
	if not can_use(user):
		return
	var tcoord = user.get_interact_terrain()
	Game.active_level.terrain.water(tcoord)
	print("used watering can")
