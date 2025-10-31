class_name InputManager extends Node

var character: Character

func _ready() -> void:
	Game.level_loaded.connect(_on_level_loaded)
	
func _on_level_loaded(level: Level) -> void:
	character = level.character

func _process(_delta: float) -> void:
	if not character:
		return
	apply_inputs()

func apply_inputs() -> void:
	# character must be present for inputs to be aplied
	assert(character)

	if not get_tree().paused:
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
			
		# interact with objects
		if Input.is_action_just_pressed("interact"):
			character.interact()
		if Input.is_action_just_pressed("menu_pause") and Game.active_level:
				Game.ui.pause_menu.enable()
	else:
		if Input.is_action_just_pressed("interact") or Input.is_action_just_pressed("ui_cancel"):
			Game.ui.close_active_menu()