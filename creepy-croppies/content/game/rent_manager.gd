class_name RentManager extends Node
## Note: actual rent deduction is triggered by day summary screen

signal rent_changed

@export var rent_interval: int = 7
@export var rents: Array[int]

@export var auto_rent_base: float = 100
@export var auto_rent_factor: float = 1.5
@export var auto_rent_num: int = 10

var rent_date: int
var rent_idx: int

func _ready() -> void:
	if rents.is_empty():
		var rent = auto_rent_base
		for _i in range(auto_rent_num):
			rents.append(int(rent))
			rent = rent * auto_rent_factor
	reset()

	Game.time.day_start.connect(_on_day_start)
	Game.time.day_end.connect(_on_day_end)

func reset():
	rent_date = rent_interval
	rent_idx = 0
	rent_changed.emit()

func trigger_game_over() -> void:
	get_tree().paused = true
	Game.ui.game_over_menu.enable()

func is_rent_due() -> bool:
	return Game.time.day >= rent_date

func can_deduct_rent() -> bool:
	return Game.player_money > get_next_rent_amount()

func deduct_rent() -> void:
	var rent_amt = get_next_rent_amount()
	Game.player_money -= rent_amt
	rent_idx += 1
	rent_date += rent_interval
	Game.day.stats.add_rent(rent_amt)
	rent_changed.emit()

func get_next_rent_amount() -> int:
	if rent_idx < 0 or rent_idx >= rents.size():
		return -1
	return rents[rent_idx]

func _on_day_end() -> void:
	if is_rent_due():
		deduct_rent()

func _on_day_start() -> void:
	if Game.player_money < 0:
		Game.trigger_game_over(false)
	elif rent_idx >= rents.size():
		Game.trigger_game_over(true)
