class_name WateringCan extends Tool

func use_primary(user: Character):
	if not can_use(user):
		return
	super.use_primary(user)
	var tcoord = user.get_interact_terrain()
	Game.active_level.terrain.water(tcoord)
	Game.audio.play_tool_watering()
	# print("used watering can")
