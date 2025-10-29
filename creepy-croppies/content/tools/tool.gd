class_name Tool extends Resource
## abstract tool class

@export var display_name: String
@export var required_terrain_flag: String
@export var allow_overlaps: bool = true
@export var cooldown: float = 0.2
@export var texture: Texture

func can_use(user: Character):
	if user.cooling_down:
		return false
	var tcoord = user.get_interact_terrain()
	if not tcoord:
		return false
	if not required_terrain_flag.is_empty() and not tcoord.has_flag(required_terrain_flag):
		return false
	if not allow_overlaps and user.cast_interact().size() > 0:
		return false
	return true


func use_primary(user: Character):
	user.start_cooldown(cooldown)

func use_secondary(user: Character):
	# TODO: deprecate
	pass # abstract
