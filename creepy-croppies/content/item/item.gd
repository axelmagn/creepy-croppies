class_name Item extends CharacterBody2D

@export var config: ItemConfig
@export var sprite: Sprite2D
@export var max_speed: float = 64
@export var accel: float = 32
@export var vel_damping: float = 0.5

var attractor: Node2D = null

func _ready() -> void:
	assert(config)
	assert(sprite)
	update_internals()

func _process(delta: float) -> void:
	apply_movement(delta)

func update_internals() -> void:
	sprite.texture = config.texture

func apply_movement(delta: float) -> void:
	velocity *= pow(vel_damping, delta)
	if attractor:
		var dir = (attractor.global_position - global_position).normalized()
		velocity += dir * accel * delta
	move_and_slide()
