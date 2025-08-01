extends Control

var event_data
var tile_ref

func setup(event, tile):
	event_data = event
	tile_ref = tile
	$Panel/VBoxContainer/Title.text = event.name
	$Panel/VBoxContainer/Description.text = event.description

	# Clear old options if re-used
	$Panel/VBoxContainer/OptionContainer.queue_free_children()

	for option in event.options:
		var btn = Button.new()
		btn.text = option["text"]
		btn.tooltip_text = option.get("tooltip", "")
		btn.pressed.connect(_on_option_selected.bind(option))
		$Panel/VBoxContainer/OptionContainer.add_child(btn)

func _on_option_selected(option):
	var effect = option["effect_script"].new()
	effect.apply(tile_ref)
	queue_free()
