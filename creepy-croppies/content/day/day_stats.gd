class_name DayStats extends RefCounted

signal changed

var start_money: int = 0
var income: int = 0
var expenses: int = 0
var rent: int = 0

func reset():
	start_money = Game.player_money
	income = 0
	expenses = 0
	rent = 0
	changed.emit()

func validate_balance():
	var balance = start_money + income - expenses - rent
	assert(balance == Game.player_money)

func add_rent(amt: int) -> void:
	rent += amt
	changed.emit()

func add_expense(amt: int) -> void:
	expenses += amt
	changed.emit()

func add_income(amt: int) -> void:
	income += amt
	changed.emit()
