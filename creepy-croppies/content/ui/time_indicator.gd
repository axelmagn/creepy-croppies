class_name TimeIndicator extends PanelContainer

@export var date_label: Label
@export var time_label: Label

func _ready() -> void:
	assert(date_label)
	assert(time_label)
	Game.time.day_start.connect(update_internals)
	Game.time.minute_tick.connect(update_internals)
	update_internals()


func update_internals():
	date_label.text = "%s %d" % [Game.time.day_of_week_name(), Game.time.day_of_month() + 1]
	time_label.text = "%02d:%02d" % [Game.time.hour(), Game.time.minute()]
