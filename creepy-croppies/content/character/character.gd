class_name Character extends CharacterBody2D

enum ActionState {IDLE, WALK}

signal active_tool_changed
signal stamina_changed

@export var max_speed: float = 64
@export var interact_reach: float = 16
@export_flags_2d_physics var interact_collision: int = 0

@export var tmp_test_plant: PackedScene
@export var tools: Array[Tool]
## TODO: cursor class?
@export var cursor: Node2D
@export var cooldown_timer: Timer
@export var magnet_area: Area2D
@export var pickup_area: Area2D
@export var max_stamina: float = 100

var _input_move: Vector2 = Vector2.ZERO
var facing_dir: Vector2 = Vector2.DOWN
var active_tool_idx: int = 0
var cooling_down: bool = false

var stamina: float = 0

func _ready() -> void:
	assert(cooldown_timer)
	cooldown_timer.timeout.connect(reset_cooldown)
	
	if magnet_area:
		magnet_area.body_entered.connect(_on_magnet_body_entered)
	if pickup_area:
		pickup_area.body_entered.connect(_on_pickup_body_entered)
	
	Game.time.day_start.connect(_on_day_start)
	stamina = max_stamina

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
	active_tool_idx += 1
	active_tool_idx %= tools.size()
	active_tool_changed.emit()

func request_prev_tool() -> void:
	if tools.is_empty():
		return
	active_tool_idx += tools.size() - 1
	active_tool_idx %= tools.size()
	active_tool_changed.emit()

func get_action_state() -> ActionState:
	if velocity.length_squared() > 0:
		return ActionState.WALK
	return ActionState.IDLE
	
## global position of interaction point
func get_interact_point() -> Vector2:
	var tcoord = get_interact_terrain()
	if not tcoord:
		return global_position + facing_dir * interact_reach
	return tcoord.to_global()

func get_interact_terrain() -> Terrain.TerrainCoord:
	var ipos = global_position + facing_dir * interact_reach
	return Game.active_level.terrain.get_showing_cell(ipos)

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
	update_cursor()

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

func update_cursor() -> void:
	if not cursor or not Game.active_level or not Game.active_level.terrain:
		return
	cursor.global_position = get_interact_point()


func get_active_tool() -> Tool:
	return tools.get(active_tool_idx)

func get_active_tool_idx() -> int:
	return active_tool_idx

func start_cooldown(time: float) -> void:
	cooling_down = true
	cooldown_timer.start(time)

func reset_cooldown() -> void:
	cooling_down = false

## perform a collision cast at the interaction point
func cast_interact() -> Array[Dictionary]:
	var space_state = get_world_2d().direct_space_state
	var qpoint = PhysicsPointQueryParameters2D.new()
	qpoint.collide_with_areas = true
	qpoint.collision_mask = interact_collision
	qpoint.position = get_interact_point()
	return space_state.intersect_point(qpoint)
	
func interact():
	var objects: Array[Dictionary] = cast_interact()
	for object in objects:
		print(object)
		if object["collider"].has_method("interact"):
			object["collider"].interact()
	
func set_stamina(value: float) -> void:
	if stamina == value:
		return
	stamina = value
	stamina_changed.emit()

func _on_magnet_body_entered(body: Node2D) -> void:
	if body is Item:
		body.attractor = self

func _on_magnet_body_exited(body: Node2D) -> void:
	if body is Item and body.attractor == self:
		body.attractor = null

func _on_pickup_body_entered(body: Node2D) -> void:
	printt("detected pickup collision")
	if body is Item:
		printt("picked up item:", body.config.name)
		Game.player_items.add_item(body.config, 1)
		body.queue_free()

func _on_day_start() -> void:
	stamina = max_stamina
