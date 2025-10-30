class_name Merchant extends Node2D

@export var enter: NodePath
@export var spot: NodePath
@export var exit: NodePath
@export var appear_hour: int = 10 # hour of day
@export var travel_minutes := 30 # minutes
@export var wait_minutes: int = 60 # minutes

enum MerchantState { STATE_HIDDEN, STATE_WALKING_TO_SPOT, STATE_WAITING, STATE_WALKING_TO_EXIT }

var state: MerchantState = MerchantState.STATE_HIDDEN

var start : Vector2
var target : Vector2
var elapsed_travel_minutes := 0
var elapsed_waiting_minutes := 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	assert(enter)
	assert(spot)
	assert(exit)
	Game.time.minute_tick.connect(_on_minute_tick)
	_set_state(MerchantState.STATE_HIDDEN)

func _set_move_target(new_target: Vector2) -> void:
	start = global_position
	target = new_target
	travel_minutes = 30
	elapsed_travel_minutes = 0
	
func _on_minute_tick() -> void:
	match state:
		MerchantState.STATE_HIDDEN:
			if Game.time.hour() == appear_hour:
				_set_state(MerchantState.STATE_WALKING_TO_SPOT)
		MerchantState.STATE_WALKING_TO_SPOT:
			if _move_step():
				_set_state(MerchantState.STATE_WAITING)
		MerchantState.STATE_WAITING:
			elapsed_waiting_minutes += 1
			if elapsed_waiting_minutes >= wait_minutes:
				_set_state(MerchantState.STATE_WALKING_TO_EXIT)
		MerchantState.STATE_WALKING_TO_EXIT:
			if _move_step():
				_set_state(MerchantState.STATE_HIDDEN)
			
func _move_step() -> bool:
	elapsed_travel_minutes += 1
	var t = clamp(float(elapsed_travel_minutes) / travel_minutes, 0.0, 1.0)
	var eased_t := 0.5 - cos(t * PI) * 0.5 # ease in out
	global_position = start.lerp(target, eased_t)
	if t >= 1.0:
		return true
	return false
		
func _set_state(new_state: MerchantState) -> void:
	self.state = new_state
	
	match state:
		MerchantState.STATE_HIDDEN:
			visible = false
		MerchantState.STATE_WALKING_TO_SPOT:
			visible = true
			global_position = get_node(enter).position
			_set_move_target(get_node(spot).position)
		MerchantState.STATE_WAITING:
			visible = true
			global_position = get_node(spot).position
			elapsed_waiting_minutes = 0
		MerchantState.STATE_WALKING_TO_EXIT:
			visible = true
			_set_move_target(get_node(exit).position)