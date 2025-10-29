class_name MainUI extends CanvasLayer

@export var main_menu: MainMenu
@export var player_hud: PlayerHUD
@export var day_summary: DaySummary

func _ready() -> void:
	assert(main_menu)
	assert(player_hud)
	assert(day_summary)
