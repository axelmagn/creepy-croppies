class_name Tool extends Resource
## abstract tool class

@export var display_name: String
@export var required_terrain_flag: String

func can_use(user: Character):
	if required_terrain_flag.is_empty():
		return true
	var tcoord = user.get_interact_terrain()
	if not tcoord:
		return false
	return tcoord.has_flag(required_terrain_flag)


func use_primary(user: Character):
	pass # abstract

func use_secondary(user: Character):
	pass # abstract
