class_name MoneyIndicator extends PanelContainer

@export var label: Label

func _ready() -> void:
	assert(label)

func _process(_delta: float) -> void:
	label.text = "$%d" % Game.player_money
