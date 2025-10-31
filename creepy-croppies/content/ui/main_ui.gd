class_name MainUI extends CanvasLayer

@export var main_menu: MainMenu
@export var game_over_menu: GameOverMenu
@export var player_hud: PlayerHUD
@export var day_summary: DaySummary
@export var shop_ui: ShopUi
@export var hut: HelperHutMenu
@export var pause_menu: PauseMenu
@export var cutscene: Cutscene
@export var bridge_menu: BridgeMenu

func _ready() -> void:
	assert(main_menu)
	assert(game_over_menu)
	assert(player_hud)
	assert(day_summary)
	assert(shop_ui)
	assert(hut)
	assert(pause_menu)
	assert(cutscene)
	assert(bridge_menu)
	day_summary.disable()
	shop_ui.disable()
	bridge_menu.disable()
