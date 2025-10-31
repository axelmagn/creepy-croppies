class_name GameAutoload extends Node

signal player_changed
signal player_items_changed
signal player_money_changed

@export var plants: PlantManager
@export var items: ItemManager
@export var audio: AudioManager
@export var item_registry: ItemRegistry
@export var world: Node2D
@export var ui: MainUI
@export var time: GameTime
@export var main_level_scn: PackedScene
@export var rent: RentManager
@export var day: DayManager
@export var cutscenes: CutscenesManager

@export var init_player_items: ItemContainer
@export var init_player_money: int = 10

signal level_loaded(level: Level)

var active_player: Character = null
var active_level: Level = null

var player_items: ItemContainer
var player_money: int:
	set(value):
		if player_money == value:
			return
		player_money = value
		player_money_changed.emit()

func _ready() -> void:
	assert(world)
	assert(ui)
	assert(time)
	assert(main_level_scn)
	assert(plants)
	assert(items)
	assert(init_player_items)
	assert(rent)
	assert(day)
	assert(audio)
	assert(cutscenes)

	player_items = init_player_items.duplicate()
	player_items.items = init_player_items.items.duplicate()
	player_money = init_player_money
	player_items_changed.emit()
	get_tree().paused = true


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
	reset_global_state()
	ui.day_summary.disable()
	get_tree().paused = false
	time.day_start.emit()
	rent.reset()
	level_loaded.emit(active_level)

## register a new player
func register_player(player: Character) -> void:
	printt("new player registered:", player)
	active_player = player
	ui.player_hud.register_player(player)
	player_changed.emit()
	
func pause_game():
	time.stop()
	if active_level != null:
		active_level.pause()

func unpause_game():
	time.start()
	if active_level != null:
		active_level.unpause()

func reset_global_state():
	time.reset()
	player_items = init_player_items.duplicate()
	player_items.items = init_player_items.items.duplicate()
	player_money = init_player_money
	player_items_changed.emit()


func trigger_game_over(win: bool) -> void:
	if win:
		ui.cutscene.play(cutscenes.win_cutscene)
	else:
		ui.cutscene.play(cutscenes.fail_cutscene)
	await ui.cutscene.finished
	get_tree().paused = true
	ui.game_over_menu.win = win
	ui.game_over_menu.enable()


func cmp_keys(k1: ItemConfig, k2: ItemConfig) -> bool:
	return k1.price < k2.price
