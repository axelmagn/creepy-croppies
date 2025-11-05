class_name StaminaIndicator extends Control

@export var progress_bar: ProgressBar
@export var warning_panel: Control

var character: Character

func _ready() -> void:
	assert(progress_bar)
	assert(warning_panel)

func set_character(character: Character) -> void:
	self.character = character
	character.stamina_changed.connect(update_internals)
	update_internals()

func update_internals() -> void:
	assert(character)
	self.progress_bar.max_value = character.max_stamina
	self.progress_bar.value = character.stamina
	self.progress_bar.min_value = 0
	# warning_panel.visible = character.stamina / float(character.max_stamina) < 0.2
	warning_panel.visible = false
