class_name Level extends Node2D

@export var pause_game_time: bool = false
@export var terrain: Terrain # nullable
@export var character: Character
@export var shop: Shop

func pause():
	get_tree().paused = true
	
func unpause():
	get_tree().paused = false
