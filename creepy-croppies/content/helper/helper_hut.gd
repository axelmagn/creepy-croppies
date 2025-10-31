class_name HelperHut extends Area2D

@export var helper_scn: PackedScene
@export var helper_config: HelperConfig
@export var fixed_tex: Texture
@export var sprite: Sprite2D

@export var fix_price: int
@export var is_fixed: bool = false

var is_recording: bool = false
var is_playing: bool = false
var routine: HelperTrack = null
var tween: Tween = null

func _ready() -> void:
	assert(helper_scn)
	assert(helper_config)
	assert(fixed_tex)
	assert(sprite)

func interact() -> void:
	Game.ui.hut.enable(self)

func can_fix() -> bool:
	return Game.player_money >= fix_price

func fix() -> void:
	Game.player_money -= fix_price
	Game.day.stats.expenses += fix_price
	sprite.texture = fixed_tex
	is_fixed = true

func can_record_routine() -> bool:
	# cannot record if player is already recording
	return Game.active_player.recording_track == null

func record_routine() -> void:
	# TODO: replace with actual routine recording
	routine = HelperTrack.new()
	Game.active_player.start_recording_track(routine)
	is_recording = true

	var helper: Helper = helper_scn.instantiate()
	helper.config = helper_config
	helper.behavior = Helper.Behavior.FOLLOW
	helper.global_position = global_position
	helper.follow_tgt = Game.active_player
	helper.tree_exited.connect(_on_helper_exited)
	Game.active_level.add_child(helper)

func finish_recording_routine() -> void:
	assert(Game.active_player.recording_track == routine)
	Game.active_player.stop_recording_track()
	is_recording = false

func can_activate_routine() -> bool:
	if not routine:
		return false
	if is_recording:
		return false
	for item in helper_config.price.items.keys():
		var amt = helper_config.price.items[item]
		if not Game.player_items.has_enough(item, amt):
			return false
	return true

func activate_routine() -> void:
	assert(can_activate_routine())
	for item in helper_config.price.items.keys():
		var amt = helper_config.price.items[item]
		Game.player_items.add_item(item, -amt)
	# TODO: activate recording
	var helper: Helper = helper_scn.instantiate()
	helper.config = helper_config
	helper.behavior = Helper.Behavior.ROUTINE
	helper.global_position = global_position
	helper.tree_exited.connect(_on_helper_exited)
	assert(routine)
	tween = get_tree().create_tween()
	routine.build_tween(tween, helper)
	tween.play()
	is_playing = true
	Game.active_level.add_child(helper)

func finish_playing_routine():
	if tween:
		tween.stop()
		tween = null
	is_playing = false

func _on_helper_exited() -> void:
	if is_recording:
		finish_recording_routine()
	if is_playing:
		finish_playing_routine()
