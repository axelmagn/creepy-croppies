class_name PlayerHUD extends Control


@export var action_state_label: Label
@export var facing_dir_label: Label
@export var time_label: Label
@export var tool_label: Label
@export var focus_cell_label: Label
@export var can_use_label: Label
@export var custom_label: Label


var player: PlayerController = null

func _ready() -> void:
	assert(action_state_label)
	assert(facing_dir_label)
	assert(time_label)
	assert(tool_label)
	assert(focus_cell_label)
	assert(can_use_label)
	assert(custom_label)

func _process(_delta: float) -> void:
	update_view()

func update_view() -> void:
	custom_label.text = "this is custom"
	time_label.text = "[%03d] %02d:%02d" % [Game.time.day, Game.time.hour(), Game.time.minute()]
	if player and player.character:
		var character = player.character
		var action_state = character.get_action_state()
		action_state_label.text = Character.ActionState.keys()[action_state]
		facing_dir_label.text = str(character.facing_dir)

		var tool_idx = character.get_active_tool_idx()
		var tool = character.get_active_tool()
		var tool_name = "NONE"
		if tool:
			tool_name = tool.display_name
		tool_label.text = "%d: %s" % [tool_idx, tool_name]
		can_use_label.text = "can use: %s" % str(tool.can_use(character))


		var interact_pt = character.get_interact_point()
		var tcoord = Game.active_level.terrain.get_showing_cell(interact_pt)
		if tcoord:
			focus_cell_label.text = "%s %s" % [tcoord.layer.name, str(tcoord.coord)]
		else:
			focus_cell_label.text = "NONE"
	else:
		action_state_label.text = "N/A"
		facing_dir_label.text = "N/A"
		tool_label.text = "N/A"
		focus_cell_label.text = "N/A"
		return


func register_player(player: PlayerController) -> void:
	self.player = player
