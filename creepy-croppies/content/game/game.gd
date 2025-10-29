class_name GameAutoload extends Node

signal player_changed

@export var plants: PlantManager
@export var items: ItemManager
@export var world: Node2D
@export var ui: MainUI
@export var time: GameTime
@export var main_level_scn: PackedScene

@export var player_items: ItemContainer
@export var player_money: int = 10

signal level_loaded(level: Level)

var active_player: Character = null
var active_level: Level = null

func _ready() -> void:
	assert(world)
	assert(ui)
	assert(time)
	assert(main_level_scn)
	assert(plants)
	assert(items)
	assert(player_items)

## load a new level
func load_level(level_scn: PackedScene) -> void:
	# unload old children
	for n in world.get_children():
		n.queue_free()
	# load new level
	var level: Level = level_scn.instantiate()
	world.add_child(level)
	active_level = level
	if active_level.pause_game_time:
		time.stop()
	else:
		time.start()
	register_player(active_level.character)
	level_loaded.emit(active_level)

## register a new player
func register_player(player: Character) -> void:
	printt("new player registered:", player)
	assert(active_player == null)
	active_player = player
	ui.player_hud.register_player(player)
	
func pause_game():
	time.stop()
	if active_level != null:
		active_level.pause()

func unpause_game():
	time.start()
	if active_level != null:
		active_level.unpause()