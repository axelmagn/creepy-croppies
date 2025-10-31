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
@export var house_menu: HouseMenu

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
	assert(house_menu)
	day_summary.disable()
	shop_ui.disable()
	bridge_menu.disable()
	house_menu.disable()

func close_active_menu() -> void:
	if shop_ui.visible:
		shop_ui._on_close_button_pressed()
		return
	if hut.visible:
		hut._on_close()
		return
	if pause_menu.visible:
		pause_menu._on_continue()
		return
	if house_menu.visible:
		house_menu._on_close_button_pressed()
		return
	if bridge_menu.visible:
		bridge_menu._on_close_button_pressed()
		return
	if day_summary.visible:
		day_summary._on_continue_pressed()
		return

	
