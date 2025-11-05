class_name StaminaWarning extends PanelContainer

@export var label: Label
@export var low_stamina_text: String = "Low Stamina"
@export var empty_stamina_text: String = "Stamina Depleted"
@export var threshold: float = 20

func _ready() -> void:
	assert(label)

func _process(_delta: float) -> void:
	if not Game.active_player or Game.active_player.stamina > threshold:
		visible = false
		return
	visible = true
	if Game.active_player.stamina > 0:
		label.text = low_stamina_text
		label.modulate = Color.WHITE
	else:
		label.text = empty_stamina_text
		label.modulate = Color.RED


	
