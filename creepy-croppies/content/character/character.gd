class_name Character extends CharacterBody2D

enum ActionState {IDLE, WALK}

@export var max_speed: float = 64

var _input_move: Vector2 = Vector2.ZERO

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	# clamp input move
	velocity = _consume_move() * max_speed
	move_and_slide()

func request_move(dir: Vector2) -> void:
	_input_move += dir

func get_action_state() -> ActionState:
	if velocity.length_squared() > 0:
		return ActionState.WALK
	return ActionState.IDLE
		

func _consume_move() -> Vector2:
	var out = _input_move
	_input_move = Vector2.ZERO
	if out.length_squared() > 1:
		out = out.normalized()
	return out
