class_name DayStatsContent extends Control

@export var grid: GridContainer

func _ready() -> void:
	assert(grid)
	assert(grid.columns == 4)
	Game.day.stats.changed.connect(update_internals)

func update_internals() -> void:
	assert(grid)
	Game.day.stats.validate_balance()
	for child in grid.get_children():
		child.queue_free()
	write_line("Assets", "", Game.day.stats.start_money)
	if Game.day.stats.income != 0:
		write_line("Income", "", Game.day.stats.income)
	if Game.day.stats.expenses != 0:
		write_line("Expenses", "", Game.day.stats.expenses)
	if Game.day.stats.rent != 0:
		write_line("Rent", "", Game.day.stats.rent)
	write_hlines()
	write_line("Balance", "", Game.player_money)



func write_line(text: String, amt_sign: String, amount: int) -> void:
	# printt("writing line:", text, amt_sign, amount)
	var text_label = Label.new()
	text_label.text = text
	text_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	grid.add_child(text_label)

	var sign_label = Label.new()
	sign_label.text = amt_sign
	sign_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	grid.add_child(sign_label)

	var dollar_label = Label.new()
	dollar_label.text = "$"
	dollar_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	grid.add_child(dollar_label)

	var amount_label = Label.new()
	amount_label.text = str(amount)
	amount_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	grid.add_child(amount_label)

func write_hlines() -> void:
	for i in grid.columns:
		var hline = HSeparator.new()
		grid.add_child(hline)
