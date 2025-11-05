class_name ToolsIndicator extends Control

@export var tool_panel_scn: PackedScene
@export var tool_panels_root: Container
@export var active_tool_label: Label

var character

func _ready() -> void:
	assert(tool_panel_scn)
	assert(tool_panels_root)
	assert(active_tool_label)
	
func _process(_delta: float) -> void:
	for child in tool_panels_root.get_children():
		if child is ToolPanel:
			var panel: ToolPanel = child
			update_tool(panel)
				
func update_tool(panel: ToolPanel):
	if character == null:
		panel.disable()
		return

	var t := panel.tool

	if t is not Seed:
		panel.enable()
		panel.count_label.visible = false
		return

	panel.count_label.visible = true
	panel.count_label.text = str(t.item_count())
	
	if t.has_enough_resources_to_use():
		panel.enable()
	else:
		panel.disable()

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
		panel.clicked.connect(_on_tool_panel_clicked.bind(i))
		update_tool(panel)
	active_tool_label.text = character.tools[active_tool_idx].display_name

func _on_tool_panel_clicked(idx: int) -> void:
	Game.active_player.set_tool(idx)
