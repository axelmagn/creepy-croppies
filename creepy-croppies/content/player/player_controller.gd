class_name PlayerController extends Node

@export var character: Character
@export var cursor: Sprite2D

func _ready() -> void:
	Game.register_player(self)

func _process(_delta: float) -> void:
	if not character:
		return
	apply_inputs()

func apply_inputs() -> void:
	# character must be present for inputs to be aplied
	assert(character)

	# movement
	var move_x: float = Input.get_axis("move_left", "move_right")
	var move_y: float = Input.get_axis("move_up", "move_down")
	var move: Vector2 = Vector2(move_x, move_y)
	character.request_move(move)

	# tool inputs	
	if Input.is_action_pressed("tool_use_primary"):
		character.request_use_tool()
	if Input.is_action_just_pressed("tool_next"):
		character.request_next_tool()
	if Input.is_action_just_pressed("tool_prev"):
		character.request_prev_tool()

	# debug inputs
	if Input.is_action_just_pressed("debug_next_day"):
		Game.time.debug_advance_day()
