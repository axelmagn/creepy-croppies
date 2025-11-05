class_name ToolPanel extends PanelContainer

signal clicked

@export var texture_rect: TextureRect
@export var active_theme_variation: StringName = "ActivePanelContainer"
@export var inactive_theme_variation: StringName = ""
@export var count_label: Label

var tool: Tool

func _ready() -> void:
	assert(texture_rect)
	assert(count_label)

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MouseButton.MOUSE_BUTTON_LEFT:
		clicked.emit()

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
