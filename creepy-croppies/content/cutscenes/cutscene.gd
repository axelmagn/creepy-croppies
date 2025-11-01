class_name Cutscene extends Control

signal input_proceed
signal finished

@export var hero: TextureRect
@export var animation_player: AnimationPlayer
@export var lines_label: Label

@export var enter_anim: StringName = "enter"
@export var exit_anim: StringName = "exit"


func _ready() -> void:
	assert(hero)
	assert(animation_player)
	assert(lines_label)


func _process(_delta: float) -> void:
	if (
		Input.is_action_just_pressed("ui_accept")
		or Input.is_action_just_pressed("interact")
		or Input.is_action_just_pressed("tool_use_primary")
	):
		input_proceed.emit()

func play(config: CutsceneConfig):

	hero.texture = config.hero_texture
	lines_label.text = ""

	visible = true
	process_mode = Node.PROCESS_MODE_ALWAYS
	# hack
	var timer = get_tree().create_timer(.1)
	await timer.timeout
	get_tree().paused = true


	lines_label.visible = false
	animation_player.play(enter_anim)
	await animation_player.animation_finished

	lines_label.visible = true
	for line in config.lines:
		lines_label.text = line
		var t = get_tree().create_timer(0.1)
		await t.timeout
		await input_proceed
		# printt("finished line:", line)
	lines_label.visible = true
	animation_player.play(exit_anim)
	await animation_player.animation_finished

	visible = false
	process_mode = Node.PROCESS_MODE_DISABLED
	get_tree().paused = false
	finished.emit()
