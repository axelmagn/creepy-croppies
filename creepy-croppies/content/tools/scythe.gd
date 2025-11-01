class_name Scythe extends Tool

func can_use(user: Character):
	if user.cooling_down:
		return false
	var overlaps = user.cast_interact()
	for overlap in overlaps:
		var collider = overlap["collider"]
		if collider is Plant:
			return collider.can_harvest()
	return false

func use_primary(user: Character):
	if not can_use(user):
		return
	super.use_primary(user)
	var overlaps = user.cast_interact()
	for overlap in overlaps:
		var collider = overlap["collider"]
		if collider is Plant:
			collider.harvest()
	# TODO: scythe functionality
	Game.audio.play_tool_scythe()
	# print("used scythe")
