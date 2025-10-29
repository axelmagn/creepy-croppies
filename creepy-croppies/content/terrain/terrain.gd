class_name Terrain extends Node2D
## manage the terrain of a level.
## translates between tileset data and game data

@export var dry_dirt_sid: int
@export var wet_dirt_sid: int

@export var unwater_on_day_start: bool = true

var watered_tiles: Array[TerrainCoord]

func _ready():
	Game.time.day_start.connect(_on_day_start)

## translate a global position to local tile coordinates
func _global_to_map(global_pos: Vector2, layer: TileMapLayer) -> Vector2i:
	var local = layer.to_local(global_pos)
	return layer.local_to_map(local)

## get the address of the showing cell at a position
func get_showing_cell(global_pos: Vector2) -> TerrainCoord:
	var max_z: int = -9223372036854775808
	var tcoord: TerrainCoord = null
	for child in get_children():
		if not child is TileMapLayer:
			continue
		var layer: TileMapLayer = child
		if layer.z_index < max_z:
			continue
		var lcoord = _global_to_map(global_pos, layer)
		var cell_id = layer.get_cell_source_id(lcoord)
		if cell_id < 0:
			continue
		if not tcoord:
			tcoord = TerrainCoord.new()
		tcoord.layer = layer
		tcoord.coord = lcoord
	return tcoord

func water(tcoord: TerrainCoord) -> void:
	var acoord = tcoord.layer.get_cell_atlas_coords(tcoord.coord)
	tcoord.layer.set_cell(tcoord.coord, wet_dirt_sid, acoord)
	watered_tiles.append(tcoord)

func unwater(tcoord: TerrainCoord) -> void:
	var acoord = tcoord.layer.get_cell_atlas_coords(tcoord.coord)
	tcoord.layer.set_cell(tcoord.coord, dry_dirt_sid, acoord)
	for i in range(watered_tiles.size()):
		var watered = watered_tiles[i]
		if tcoord.equals(watered):
			watered_tiles.remove_at(i)
			return

func unwater_all() -> void:
	for tcoord in watered_tiles:
		var acoord = tcoord.layer.get_cell_atlas_coords(tcoord.coord)
		tcoord.layer.set_cell(tcoord.coord, dry_dirt_sid, acoord)
	watered_tiles.clear()

func is_watered(tcoord: TerrainCoord) -> bool:
	for i in range(watered_tiles.size()):
		var watered = watered_tiles[i]
		if tcoord.equals(watered):
			return true
	return false

func _on_day_start() -> void:
	if unwater_on_day_start:
		unwater_all()


class TerrainCoord extends RefCounted:
	var layer: TileMapLayer
	var coord: Vector2i

	func to_global() -> Vector2:
		# return layer.to_global(layer.map_to_local(coord)) + Vector2(layer.tile_set.tile_size) / 2
		return layer.to_global(layer.map_to_local(coord))

	func has_flag(flag_name: String) -> bool:
		var tdata = layer.get_cell_tile_data(coord)
		return tdata.has_custom_data(flag_name) and bool(tdata.get_custom_data(flag_name))

	func equals(other: TerrainCoord) -> bool:
		return layer == other.layer and coord == other.coord
