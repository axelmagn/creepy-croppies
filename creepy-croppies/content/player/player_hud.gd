class_name PlayerHUD extends Control


@export var action_state_label: Label
@export var facing_dir_label: Label
@export var time_label: Label
@export var tool_label: Label
@export var focus_cell_label: Label
@export var can_use_label: Label
@export var custom_label: Label

@export var interact_notifier: Control
@export var tools_indicator: ToolsIndicator
@export var stamina_indicator: StaminaIndicator

var player: Character = null

func _ready() -> void:
	assert(action_state_label)
	assert(facing_dir_label)
	assert(time_label)
	assert(tool_label)
	assert(focus_cell_label)
	assert(can_use_label)
	assert(custom_label)
	assert(interact_notifier)

	assert(tools_indicator)
	assert(stamina_indicator)

	# Game.player_items.items_changed.connect(update_item_grid)
	# update_item_grid()


func _process(_delta: float) -> void:
	update_view()

func update_view() -> void:
	custom_label.text = "this is custom"
	time_label.text = "[%03d] %02d:%02d" % [Game.time.day, Game.time.hour(), Game.time.minute()]

	if player:
		var action_state = player.get_action_state()
		action_state_label.text = Character.ActionState.keys()[action_state]
		facing_dir_label.text = str(player.facing_dir)

		var tool_idx = player.get_active_tool_idx()
		var tool = player.get_active_tool()
		var tool_name = "NONE"
		if tool:
			tool_name = tool.display_name
		tool_label.text = "%d: %s" % [tool_idx, tool_name]
		can_use_label.text = "can use: %s" % str(tool.can_use(player))


		var interact_pt = player.get_interact_point()
		var tcoord = Game.active_level.terrain.get_showing_cell(interact_pt)
		if tcoord:
			focus_cell_label.text = "%s %s" % [tcoord.layer.name, str(tcoord.coord)]
		else:
			focus_cell_label.text = "NONE"

		interact_notifier.visible = player.can_interact()

	else:
		action_state_label.text = "N/A"
		facing_dir_label.text = "N/A"
		tool_label.text = "N/A"
		focus_cell_label.text = "N/A"
		return




func register_player(player: Character) -> void:
	self.player = player
	tools_indicator.set_character(player)
	stamina_indicator.set_character(player)
