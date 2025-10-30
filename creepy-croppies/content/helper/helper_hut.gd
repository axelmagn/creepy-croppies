class_name HelperHut extends Area2D

@export var fix_price: int
@export var routine_price: ItemContainer
@export var is_fixed: bool = false
# TODO: replace with routine recording
@export var has_routine: bool = false

func _ready() -> void:
	assert(routine_price)

func interact() -> void:
	Game.ui.hut.enable(self)

func can_fix() -> bool:
	return Game.player_money >= fix_price

func fix() -> void:
	Game.player_money -= fix_price
	Game.day.stats.expenses += fix_price
	is_fixed = true

func record_routine() -> void:
	# TODO: replace with actual routine recording
	has_routine = true

func can_activate_routine() -> bool:
	if not has_routine:
		return false
	for item in routine_price.items.keys():
		var amt = routine_price.items[item]
		if not Game.player_items.has_enough(item, amt):
			return false
	return true

func activate_routine() -> void:
	assert(can_activate_routine())
	for item in routine_price.items.keys():
		var amt = routine_price.items[item]
		Game.player_items.add_item(item, -amt)
	printt("routine activated")
