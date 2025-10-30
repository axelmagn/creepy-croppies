class_name DayStats extends RefCounted

var start_money: int = 0
var income: int = 0
var expenses: int = 0
var rent: int = 0

func reset():
	start_money = 0
	income = 0
	expenses = 0
	rent = 0