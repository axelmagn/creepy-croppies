class_name PlayerHUD extends Control


@export var action_state_label: Label

var player: PlayerController = null

func _ready() -> void:
	assert(action_state_label)

func _process(_delta: float) -> void:
	update_view()

func update_view() -> void:
	if player == null or player.character == null:
		action_state_label.text = "N/A"
		return

	var character = player.character
	var action_state = character.get_action_state()
	action_state_label.text = Character.ActionState.keys()[action_state]

func register_player(player: PlayerController) -> void:
	self.player = player
