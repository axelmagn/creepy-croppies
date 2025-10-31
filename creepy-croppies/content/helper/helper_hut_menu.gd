class_name HelperHutMenu extends Control


@export var fix_button: Button
@export var record_button: Button
@export var activate_button: Button
@export var close_button: Button
@export var price_grid: GridContainer

var hut: HelperHut

func _ready() -> void:
	assert(fix_button)
	assert(record_button)
	assert(activate_button)
	assert(close_button)
	assert(price_grid)

	fix_button.pressed.connect(_on_fix)
	record_button.pressed.connect(_on_record)
	activate_button.pressed.connect(_on_activate)
	close_button.pressed.connect(_on_close)

func update_internals() -> void:
	assert(hut)

	fix_button.visible = not hut.is_fixed
	fix_button.disabled = not hut.can_fix()
	fix_button.text = "Fix: $%d" % hut.fix_price

	record_button.visible = hut.is_fixed
	record_button.disabled = not hut.can_record_routine()

	activate_button.visible = hut.is_fixed
	activate_button.disabled = not hut.can_activate_routine()
	# TODO: disable activate if no recording exists

	for child in price_grid.get_children():
		child.queue_free()
	for item in hut.helper_config.price.items:
		var icon = TextureRect.new()
		icon.texture = item.texture
		icon.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST_WITH_MIPMAPS
		icon.custom_minimum_size = Vector2(32, 32)
		price_grid.add_child(icon)
		var label = Label.new()
		label.text = "%d" % hut.helper_config.price.items[item]
		price_grid.add_child(label)

func reset_focus() -> void:
	for button in [fix_button, record_button, activate_button, close_button]:
		if button.visible and not button.disabled:
			button.grab_focus()
			return

func enable(helper_hut: HelperHut) -> void:
	visible = true
	hut = helper_hut
	process_mode = Node.PROCESS_MODE_ALWAYS
	get_tree().paused = true
	update_internals()
	reset_focus()


func disable():
	visible = false
	process_mode = Node.PROCESS_MODE_DISABLED
	get_tree().paused = false
	hut = null

func _on_close():
	disable()
	Game.audio.play_click()

func _on_fix():
	if hut.can_fix():
		hut.fix()
		update_internals()
		# reset_focus()
		record_button.grab_focus()
		Game.audio.play_click()

func _on_record():
	hut.record_routine()
	disable()
	Game.audio.play_click()

func _on_activate():
	if hut.can_activate_routine():
		hut.activate_routine()
		disable()
		Game.audio.play_click()
