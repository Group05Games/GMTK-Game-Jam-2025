extends Control

var event_data
var tile_ref

func setup(event, tile):
	event_data = event
	tile_ref = tile
	$Panel/VBoxContainer/Title.text = event.name
	$Panel/VBoxContainer/Description.text = event.description

	# Clear and rebuild options
	for child in $Panel/VBoxContainer/OptionContainer.get_children():
		child.queue_free()

	for option in event.options:
		var btn := Button.new()
		btn.text = option.get("text")
		btn.tooltip_text = option.get("tooltip")
		btn.pressed.connect(_on_option_selected.bind(option))
		$Panel/VBoxContainer/OptionContainer.add_child(btn)

# --- POSITIONING --------------------------------------------------------------

func place_on_screen(screen_pos: Vector2) -> void:
	# Ensure we have a size after being added to the tree
	await get_tree().process_frame
	var size := get_combined_minimum_size()
	global_position = screen_pos - size * 0.5
	_clamp_to_viewport()

func _clamp_to_viewport() -> void:
	var vp := get_viewport_rect().size
	var size := get_combined_minimum_size()
	global_position.x = clamp(global_position.x, 8.0, vp.x - size.x - 8.0)
	global_position.y = clamp(global_position.y, 8.0, vp.y - size.y - 8.0)

# --- OPTION HANDLERS ----------------------------------------------------------

func _on_option_selected(option: Dictionary) -> void:
	var eff_res = option.get("effect_script")
	var eff = (eff_res.new() if eff_res is Script else eff_res)
	if eff and eff.has_method("apply"):
		eff.apply(tile_ref, EventManager)  # pass EventManager for game state access
	queue_free()
