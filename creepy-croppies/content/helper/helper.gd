class_name Helper extends Character

enum Behavior {NONE, FOLLOW, ROUTINE}

@export var config: HelperConfig
@export var attention_label: Label
@export var attention_timer: Timer

var follow_tgt: Character = null
var behavior: Behavior = Behavior.NONE

func _ready() -> void:
	super._ready()
	assert(config)
	assert(attention_label)
	assert(attention_timer)
	attention_timer.wait_time = config.attention_span
	attention_timer.timeout.connect(cleanup)
	Game.time.day_end.connect(cleanup)

func _process(delta: float) -> void:
	update_attention_label()
	if behavior == Behavior.FOLLOW:
		follow_tick(delta)

func follow_tick(_delta: float) -> void:
	assert(config)
	if not follow_tgt:
		velocity = Vector2.ZERO
		return
	var follow_delta = follow_tgt.global_position - global_position
	if follow_delta.length() < config.follow_dist:
		velocity = Vector2.ZERO
		return
	velocity = follow_delta.normalized() * config.follow_speed
	move_and_slide()

func start_follow(target: Character) -> void:
	follow_tgt = target

func update_attention_label() -> void:
	if attention_timer.paused:
		attention_label.visible = false
	else:
		attention_label.visible = true
		var hrs = int(attention_timer.time_left) / 60
		var mins = int(attention_timer.time_left) % 60
		attention_label.text = "%d:%02d" % [hrs, mins]

func cleanup() -> void:
	# for now just delete
	queue_free()