class_name ToolPanel extends PanelContainer

@export var texture_rect: TextureRect
@export var active_theme_variation: StringName = "ActivePanelContainer"
@export var inactive_theme_variation: StringName = ""

var tool: Tool

func _ready() -> void:
	assert(texture_rect)

func set_tool(tool: Tool) -> void:
	self.tool = tool
	texture_rect.texture = tool.texture

func activate() -> void:
	theme_type_variation = active_theme_variation

func deactivate() -> void:
	theme_type_variation = inactive_theme_variation

func disable() -> void:
	texture_rect.self_modulate = Color(0.7, 0.7, 0.7, 0.5)

func enable() -> void:
	texture_rect.self_modulate = Color(1, 1, 1, 1)
