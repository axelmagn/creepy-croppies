class_name Merchant extends Node2D

@export var shop: Shop
@export var enterPath: Path2D
@export var exitPath: Path2D
@export var appear_hour: int = 10 # hour of day
@export var enter_travel_minutes := 30 # minutes
@export var exit_travel_minutes := 30 # minutes
@export var wait_minutes: int = 60 # minutes

enum MerchantState { STATE_HIDDEN, STATE_WALKING_TO_SPOT, STATE_WAITING, STATE_WALKING_TO_EXIT }

var state: MerchantState = MerchantState.STATE_HIDDEN

var elapsed_travel_minutes := 0
var elapsed_waiting_minutes := 0
var current_path: Curve2D
var total_travel_duration := 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	assert(shop)
	assert(enterPath)
	assert(exitPath)
	Game.time.minute_tick.connect(_on_minute_tick)
	Game.time.day_start.connect(_on_day_start)
	_set_state(MerchantState.STATE_HIDDEN)
	
func _on_day_start() -> void:
	_set_state(MerchantState.STATE_HIDDEN)

func _init_move_path(path : Curve2D, travel_duration) -> void:
	current_path = path
	total_travel_duration = travel_duration
	elapsed_travel_minutes = 0
	global_position = path.sample_baked(0)
	
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
	var t = clamp(float(elapsed_travel_minutes) / total_travel_duration, 0.0, 1.0)
	var eased_t := 0.5 - cos(t * PI) * 0.5 # ease in out
	var current := current_path.get_baked_length() * eased_t
	global_position = current_path.sample_baked(current)
		
	if t >= 1.0:
		return true
	return false
		
func _set_state(new_state: MerchantState) -> void:
	self.state = new_state
	
	match state:
		MerchantState.STATE_HIDDEN:
			visible = false
			global_position = enterPath.curve.sample_baked(0)
		MerchantState.STATE_WALKING_TO_SPOT:
			visible = true
			shop.is_interactable = false
			_init_move_path(enterPath.curve, enter_travel_minutes)
		MerchantState.STATE_WAITING:
			visible = true
			elapsed_waiting_minutes = 0
			shop.is_interactable = true
			Game.audio.play_shop_open()
		MerchantState.STATE_WALKING_TO_EXIT:
			visible = true
			shop.is_interactable = false
			_init_move_path(exitPath.curve, exit_travel_minutes)
