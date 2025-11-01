class_name HelperTrack extends RefCounted
## stores a record of positions and actions
## can produce a tween to drive a helper


var actions: Array[Action]

func clear() -> void:
	actions.clear()

func build_tween(tween: Tween, character: Character) -> void:
	if actions.is_empty():
		return
	var last_time = actions[0].time_usec
	for action in actions:
		action.build_tween(tween, character, last_time)
		last_time = action.time_usec

func record_move(global_position: Vector2, facing_dir: Vector2) -> void:
	actions.append(PropertyAction.new("global_position", global_position))
	actions.append(PropertyAction.new("facing_dir", facing_dir))

func record_method_call(method: Callable, args: Array[Variant]) -> void:
	assert(false, "deprecated")
	actions.append(MethodAction.new(method, args))

func record_tool_use(tool_idx: int) -> void:
	actions.append(ToolAction.new(tool_idx))



func last_action_usec() -> int:
	if actions.is_empty():
		return -1
	return actions[-1].time_usec

func dt_since_last_action() -> float:
	var now = Time.get_ticks_usec()
	return float(now - last_action_usec()) / 1000000

class Action extends RefCounted:
	var time_usec: int

	func _init() -> void:
		time_usec = Time.get_ticks_usec()

	func build_tween(tween: Tween, character: Character,  last_time_usec: int) -> void:
		assert(false, "abstract")

	func dt(last_time_usec: int) -> float:
		assert(time_usec >= last_time_usec)
		return float(time_usec - last_time_usec) / 1000000.0

class PropertyAction extends Action:
	var _property: NodePath
	var _final_val: Variant

	func _init(property: NodePath, final_val: Variant):
		super._init()
		_property = property
		_final_val = final_val

	func build_tween(tween: Tween, character: Character, last_time_usec: int) -> void:
		var ltdt = dt(last_time_usec)
		# printt("tween::prop::dt", ltdt)
		tween.tween_property(character, _property, _final_val, ltdt)

class ToolAction extends Action:
	var _tool_idx: int

	func _init(tool_idx: int):
		super._init()
		_tool_idx = tool_idx

	func build_tween(tween: Tween, character: Character,  last_time_usec: int) -> void:
		var set_tool = character.set_tool.bind(_tool_idx)
		tween.tween_callback(set_tool).set_delay(dt(last_time_usec))
		tween.tween_callback(character.request_use_tool)


class MethodAction extends Action:
	var _method: Callable
	var _args: Array[Variant]

	func _init(method: Callable, args: Array[Variant]):
		super._init()
		# printt("adding method:", method, method.get_bound_arguments_count(), method.get_argument_count())
		_method = method.unbind(1) # unbind the object from the method
		_args = args
	
	func build_tween(tween: Tween, character: Character,  last_time_usec: int) -> void:
		var cb = _method.bind(character)
		if not _args.is_empty():
			cb = cb.bindv(_args)
		# printt("bound callback:", cb, cb.get_bound_arguments_count(), cb.get_argument_count())
		var ltdt = dt(last_time_usec)
		# printt("tween::prop::dt", ltdt)
		tween.tween_callback(cb).set_delay(ltdt)

	
