extends Node

var all_events: Array[GameEvent] = []
var player_money = 500 # This should later be tied to real game state

func _ready():
	load_events()

func load_events():
	var base_dir = DirAccess.open("res://EventSystem/events")
	if base_dir:
		base_dir.list_dir_begin()
		var dir_name = base_dir.get_next()
		while dir_name != "":
			if base_dir.current_is_dir():
				var sub_dir = DirAccess.open("res://EventSystem/events/" + dir_name)
				if sub_dir:
					sub_dir.list_dir_begin()
					var file_name = sub_dir.get_next()
					while file_name != "":
						if file_name.ends_with(".tres"):
							var event = load("res://EventSystem/events/" + dir_name + "/" + file_name)
							if event:
								all_events.append(event)
						file_name = sub_dir.get_next()
			dir_name = base_dir.get_next()

func process_tile_entry(tile, caravan):
	for ev in all_events:
		if ev.category == "tile" and tile.type in ev.valid_tile_types:
			var trigger = ev.trigger_script.new()
			if trigger.evaluate(tile, caravan):
				show_event_popup(ev, tile)
				break

func check_global_events():
	for ev in all_events:
		if ev.category == "global":
			var trigger = ev.trigger_script.new()
			if trigger.evaluate(null, null):
				show_event_popup(ev, null)

func show_event_popup(event: GameEvent, tile):
	var popup_scene = preload("res://EventSystem/ui/EventPopup.tscn")
	var popup = popup_scene.instantiate()
	popup.setup(event, tile)
	get_tree().root.add_child(popup)
