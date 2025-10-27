class_name Character extends CharacterBody2D

enum ActionState {IDLE, WALK}

@export var max_speed: float = 64
@export var interact_reach: float = 16

@export var tmp_test_plant: PackedScene
@export var tools: Array[Tool]

var _input_move: Vector2 = Vector2.ZERO
var facing_dir: Vector2 = Vector2.DOWN
var _active_tool_idx: int = 0

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	_apply_move()

func request_move(dir: Vector2) -> void:
	_input_move += dir

func request_use_tool() -> void:
	var active_tool: Tool = get_active_tool()
	if not active_tool:
		return
	active_tool.use_primary(self)

func request_next_tool() -> void:
	if tools.is_empty():
		return
	_active_tool_idx += 1
	_active_tool_idx %= tools.size()

func request_prev_tool() -> void:
	if tools.is_empty():
		return
	_active_tool_idx += tools.size() - 1
	_active_tool_idx %= tools.size()

func get_action_state() -> ActionState:
	if velocity.length_squared() > 0:
		return ActionState.WALK
	return ActionState.IDLE
	
## global position of interaction point
func get_interact_point() -> Vector2:
	return global_position + facing_dir * interact_reach

# TODO: plant manager
func tmp_place_plant() -> void:
	assert(tmp_test_plant)
	var place_loc = get_interact_point()
	if place_loc == null:
		return
	var plant: Node2D = tmp_test_plant.instantiate()
	plant.global_position = place_loc
	Game.active_level.add_child(plant)
		

## return normalized movement inputs and reset accumulator variables back to zero
func _consume_move() -> Vector2:
	var out = _input_move
	_input_move = Vector2.ZERO
	if out.length_squared() > 1:
		out = out.normalized()
	return out

func _apply_move() -> void:
	# clamp input move
	velocity = _consume_move() * max_speed
	update_facing_dir()
	move_and_slide()

func update_facing_dir() -> void:
	if velocity == Vector2.ZERO:
		return
	var best_match: Vector2 = Vector2.DOWN
	var best_dot: float = velocity.dot(best_match)
	for dir in [Vector2.UP, Vector2.LEFT, Vector2.RIGHT]:
		var x = velocity.dot(dir)
		if x > best_dot:
			best_match = dir
			best_dot = x
	facing_dir = best_match

func get_active_tool() -> Tool:
	return tools.get(_active_tool_idx)

func get_active_tool_idx() -> int:
	return _active_tool_idx




