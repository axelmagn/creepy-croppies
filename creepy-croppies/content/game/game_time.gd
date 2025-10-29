class_name GameTime extends Node

enum DayNameAbbr {Mon, Tue, Wed, Thu, Fri, Sat, Sun}

signal day_start
signal day_end
signal minute_tick

@export var start_hour: int = 6
@export var end_hour: int = 2
@export var minute_tick_rate: float = 1

@export var minute_timer: Timer

var day: int = 0
var raw_minute: int = 1

func _ready() -> void:
	assert(minute_timer)
	minute_timer.timeout.connect(advance_minute)
	minute_timer.wait_time = minute_tick_rate
	advance_day()
	day -= 1

func advance_minute() -> void:
	raw_minute += 1
	minute_tick.emit()
	if hour() == end_hour:
		day_end.emit()
		# TODO: end of day screen - until then, just advance the day
		advance_day()


func advance_day() -> void:
	raw_minute = start_hour * 60
	day += 1
	day_start.emit()

## used for debugging when we want to scroll through days
func debug_advance_day():
	day_end.emit()
	advance_day()


func minute() -> int:
	return raw_minute % 60

func hour() -> int:
	return int(raw_minute / 60) % 24

func day_of_week() -> int:
	return day % 7

func day_of_month() -> int:
	return day % 30

func day_of_week_name() -> String:
	var d = day_of_week()
	return DayNameAbbr.keys()[d]

func stop() -> void:
	minute_timer.stop()

func start() -> void:
	minute_timer.start()
