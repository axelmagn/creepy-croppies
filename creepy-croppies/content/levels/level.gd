class_name Level extends Node2D

@export var pause_game_time: bool = false
@export var terrain: Terrain # nullable
@export var character: Character
@export var player_reset_marker: Marker2D
# @export var shop: Shop

func _ready() -> void:
	if character and player_reset_marker:
		var t = get_tree().create_timer(0.5) # hack
		await t.timeout
		Game.time.day_start.connect(reset_player_pos)

func pause():
	get_tree().paused = true
	
func unpause():
	get_tree().paused = false

func reset_player_pos() -> void:
	character.global_position = player_reset_marker.global_position
