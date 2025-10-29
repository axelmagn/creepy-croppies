class_name ToolPanel extends PanelContainer

@export var texture_rect: TextureRect
@export var active_theme_variation: StringName = "ActivePanelContainer"
@export var inactive_theme_variation: StringName = ""


func _ready() -> void:
	assert(texture_rect)

func set_tool(tool: Tool) -> void:
	texture_rect.texture = tool.texture

func activate() -> void:
	theme_type_variation = active_theme_variation

func deactivate() -> void:
	theme_type_variation = inactive_theme_variation
