class_name Bridge extends Node

@export var broken_bridge: Node2D
@export var broken_bridge_collider: CollisionShape2D
@export var fixed_bridge: Node2D
@export var fix_cost: int = 100

var is_fixed := false

func _ready() -> void:
	assert(broken_bridge)
	assert(fixed_bridge)
	assert(broken_bridge_collider)
	broken_bridge.show()
	fixed_bridge.hide()
	broken_bridge_collider.disabled = false

func fix() -> void:
	if Game.player_money < fix_cost:
		return
		
	Game.player_money -= fix_cost
	is_fixed = true
	broken_bridge.hide()
	broken_bridge_collider.disabled = true
	fixed_bridge.show()