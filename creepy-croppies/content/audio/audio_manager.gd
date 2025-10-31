class_name AudioManager extends Node

@onready var click_player: AudioStreamPlayer = $AudioStreamPlayerClick
@onready var footstep_player: AudioStreamPlayer = $AudioStreamPlayerFootstep
@onready var plant_seed_player: AudioStreamPlayer = $AudioStreamPlayerPlantSeed
@onready var tool_watering_player: AudioStreamPlayer = $AudioStreamPlayerToolWatering
@onready var tool_scythe_player: AudioStreamPlayer = $AudioStreamPlayerToolScythe
@onready var pick_up_player: AudioStreamPlayer = $AudioStreamPlayerPickUp
@onready var sell_player: AudioStreamPlayer = $AudioStreamPlayerSell
@onready var shop_open_player: AudioStreamPlayer = $AudioStreamPlayerShopOpen
@export var click_sound: AudioStream
@export var footstep_sound: AudioStream
@export var plant_seed_sound: AudioStream
@export var tool_watering_sound: AudioStream
@export var tool_scythe_sound: AudioStream
@export var pick_up_sound: AudioStream
@export var sell_sound: AudioStream
@export var shop_open_sound: AudioStream

func _ready() -> void:
	assert(click_player)
	assert(click_sound)
	assert(footstep_player)
	assert(footstep_sound)
	assert(plant_seed_player)
	assert(plant_seed_sound)
	assert(tool_watering_player)
	assert(tool_watering_sound)
	assert(tool_scythe_player)
	assert(tool_scythe_sound)
	assert(pick_up_player)
	assert(pick_up_sound)
	assert(sell_player)
	assert(sell_sound)
	assert(shop_open_player)
	assert(shop_open_sound)
	click_player.stream = click_sound
	footstep_player.stream = footstep_sound
	plant_seed_player.stream = plant_seed_sound
	tool_watering_player.stream = tool_watering_sound
	tool_scythe_player.stream = tool_scythe_sound
	pick_up_player.stream = pick_up_sound
	sell_player.stream = sell_sound
	shop_open_player.stream = shop_open_sound

func play_click():
	click_player.play()

func play_footstep():
	if footstep_player.is_playing():
		return
		
	footstep_player.play()

func stop_footstep():
	footstep_player.stop()
	
func play_plant_seed():
	plant_seed_player.play()
	
func play_tool_watering():
	tool_watering_player.play()
	
func play_tool_scythe():
	tool_scythe_player.play()
	
func play_pick_up():
	pick_up_player.play()
	
func play_sell():
	sell_player.play()

func play_shop_open():
	shop_open_player.play()
