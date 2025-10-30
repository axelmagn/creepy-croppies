class_name RentIndicator extends PanelContainer

@export var amount_label: Label
@export var date_label: Label

func _ready() -> void:
	assert(amount_label)
	assert(date_label)
	Game.rent.rent_changed.connect(update_internals)

func update_internals() -> void:
	var rent_day = Game.rent.rent_date
	var dname = Game.time.to_day_of_week_name(rent_day)
	var dnum = Game.time.to_day_of_month(rent_day) + 1
	date_label.text = "%s %d" % [dname, dnum]
	amount_label.text = "$%d" % Game.rent.get_next_rent_amount()
