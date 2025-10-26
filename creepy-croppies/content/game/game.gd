class_name GameAutoload extends Node

# TODO: custom classes
@export var world: Node2D
@export var ui: MainUI

@export var main_level_scn: PackedScene

var active_player: PlayerController = null

func _ready() -> void:
	assert(world)
	assert(ui)
	assert(main_level_scn)

## load a new level
func load_level(level_scn: PackedScene) -> void:
	# unload old children
	for n in world.get_children():
		n.queue_free()
	# load new level
	var level = level_scn.instantiate()
	world.add_child(level)

## register a new player
func register_player(player: PlayerController) -> void:
	printt("new player registered:", player)
	assert(active_player == null)
	active_player = player
	ui.player_hud.register_player(player)
