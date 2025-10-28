class_name Scythe extends Tool

func use_primary(user: Character):
	if not can_use(user):
		return
	super.use_primary(user)
	# TODO: scythe functionality
	print("used scythe")
