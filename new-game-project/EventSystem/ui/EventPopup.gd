extends Control

var event_data
var tile_ref

func setup(event, tile):
	event_data = event
	tile_ref = tile
	$Panel/VBoxContainer/Title.text = event.name
	$Panel/VBoxContainer/Description.text = event.description

	# Clear old options if re-used
	for child in $Panel/VBoxContainer/OptionContainer.get_children():
		child.queue_free()

	for option in event.options:
		var btn = Button.new()
		btn.text = option["text"]
		btn.tooltip_text = option.get("tooltip")
		btn.pressed.connect(_on_option_selected.bind(option))
		$Panel/VBoxContainer/OptionContainer.add_child(btn)

func place_on_screen(screen_pos: Vector2):
	# Center the popup on the target point
	await ready
	var size := get_combined_minimum_size()
	global_position = screen_pos - size * 0.5
	_clamp_to_viewport()

func _clamp_to_viewport():
	var vp := get_viewport_rect().size
	var size := get_combined_minimum_size()
	global_position.x = clamp(global_position.x, 8.0, vp.x - size.x - 8.0)
	global_position.y = clamp(global_position.y, 8.0, vp.y - size.y - 8.0)

func _on_option_selected(option):
	var effect = option["effect_script"].new()
	effect.apply(tile_ref)
	queue_free()
