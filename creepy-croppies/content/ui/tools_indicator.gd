class_name ToolsIndicator extends Control

@export var tool_panel_scn: PackedScene
@export var tool_panels_root: Container
@export var active_tool_label: Label

var character

func _ready() -> void:
	assert(tool_panel_scn)
	assert(tool_panels_root)
	assert(active_tool_label)

func set_character(character: Character) -> void:
	self.character = character
	character.active_tool_changed.connect(update_internals)
	update_internals()

func update_internals() -> void:
	for child in tool_panels_root.get_children():
		child.queue_free()
	if not Game.active_player:
		return
	var tools = character.tools
	var active_tool_idx = character.active_tool_idx
	for i in range(tools.size()):
		var player_tool = tools[i]
		var panel: ToolPanel = tool_panel_scn.instantiate()
		panel.set_tool(player_tool)
		if i == active_tool_idx:
			panel.activate()
		tool_panels_root.add_child(panel)
	active_tool_label.text = character.tools[active_tool_idx].display_name
