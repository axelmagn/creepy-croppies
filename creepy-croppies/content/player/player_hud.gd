class_name PlayerHUD extends Control


@export var action_state_label: Label
@export var facing_dir_label: Label
@export var time_label: Label

var player: PlayerController = null

func _ready() -> void:
	assert(action_state_label)
	assert(facing_dir_label)
	assert(time_label)

func _process(_delta: float) -> void:
	update_view()

func update_view() -> void:
	time_label.text = "[%03d] %02d:%02d" % [Game.time.day, Game.time.hour(), Game.time.minute()]
	if player == null or player.character == null:
		action_state_label.text = "N/A"
		facing_dir_label.text = "N/A"
		return

	var character = player.character
	var action_state = character.get_action_state()
	action_state_label.text = Character.ActionState.keys()[action_state]
	facing_dir_label.text = str(character.facing_dir)


func register_player(player: PlayerController) -> void:
	self.player = player
