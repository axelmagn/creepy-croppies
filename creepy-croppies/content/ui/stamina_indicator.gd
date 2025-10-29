class_name StaminaIndicator extends PanelContainer

@export var progress_bar: ProgressBar

var character: Character

func _ready() -> void:
	assert(progress_bar)

func set_character(character: Character) -> void:
	self.character = character
	character.stamina_changed.connect(update_internals)
	update_internals()

func update_internals() -> void:
	assert(character)
	self.progress_bar.max_value = character.max_stamina
	self.progress_bar.value = character.stamina
	self.progress_bar.min_value = 0
