extends Node

var all_events: Array[GameEvent] = []
var events_by_name := {}  # String -> GameEvent
var player_money = 500 # This should later be tied to real game state

@onready var popup_parent: Control = _get_popup_parent()
@onready var camera: Camera2D = _get_camera()

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
								events_by_name[event.name] = event
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
				
func get_event_by_name(name: String) -> GameEvent:
	return events_by_name.get(name)

func _get_popup_parent() -> Control:
	# Adjust the path to match your scene (Main/UI/Popups)
	# Using absolute-from-root is reliable if Main is the root scene.
	return get_tree().root.get_node("Main/UI/Popups") as Control

func _get_camera() -> Camera2D:
	# If there is exactly one Camera2D:
	for cam in get_tree().get_nodes_in_group("cameras"):
		if cam is Camera2D and cam.is_current():
			return cam
	# Fallback: search the tree
	var node := get_tree().get_root().find_child("Camera2D", true, false)
	return node as Camera2D

func show_event_popup(event: GameEvent, tile):
	var popup_scene = preload("res://EventSystem/ui/EventPopup.tscn")
	var popup = popup_scene.instantiate()
	popup.setup(event, tile)
	get_tree().root.add_child(popup)
