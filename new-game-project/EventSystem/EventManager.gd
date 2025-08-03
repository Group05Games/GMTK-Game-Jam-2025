extends Node

# ─── Public event data ────────────────────────────────────────────────────────
var all_events: Array[GameEvent] = []
var events_by_name := {}  # String -> GameEvent

# Example game state (replace with real systems when ready)
var player_money: int = 500
# var player_money = GlobalSettings.CityInventory.inventory[GlobalSettings.ResourceType.GOLD]

# ─── Scene references (adjust paths if your scene differs) ────────────────────
var world_root: Node
var popup_parent: Control

# ─── Scenes ───────────────────────────────────────────────────────────────────
var _marker_scene := preload("res://EventSystem/ui/EventMarker.tscn")
var _popup_scene  := preload("res://EventSystem/ui/EventPopup.tscn")

func _ready() -> void:
	load_events()

# ─── Load events from res://EventSystem/events (top + one level deep) ────────
func load_events() -> void:
	all_events.clear()
	events_by_name.clear()

	var base_path := "res://EventSystem/events"
	var base_dir := DirAccess.open(base_path)
	if base_dir == null:
		push_warning("EventManager: events folder not found at %s" % base_path)
		return

	# list_dir_begin(skip_navigational=true, skip_hidden=true)
	base_dir.list_dir_begin()
	var entry := base_dir.get_next()
	while entry != "":
		if base_dir.current_is_dir():
			var sub := DirAccess.open(base_path + "/" + entry)
			if sub:
				sub.list_dir_begin()
				var f := sub.get_next()
				while f != "":
					if f.ends_with(".tres"):
						var ev := load(base_path + "/" + entry + "/" + f)
						if ev is GameEvent:
							all_events.append(ev)
							events_by_name[ev.name] = ev
					f = sub.get_next()
		elif entry.ends_with(".tres"):
			var ev2 := load(base_path + "/" + entry)
			if ev2 is GameEvent:
				all_events.append(ev2)
				events_by_name[ev2.name] = ev2
		entry = base_dir.get_next()
	base_dir.list_dir_end()

func get_event_by_name(name: String) -> GameEvent:
	return events_by_name.get(name)

# ─── MAIN ENTRY: call this when a caravan enters a cube ───────────────────────
# hex_layer: your single HexagonTileMapLayer node
# cube: Vector3i (x, y, z)
# tile_info: Dictionary that includes at least:
#   { "tile_id": String, "tile_type": String, "tile_def": Dictionary }
func request_tile_event_for_cube(hex_layer: Node, cube: Vector3i, tile_info: Dictionary, caravan: Node) -> void:
	# Build a canonical tile_ref the rest of the system understands
	# Since cube_to_local == world pos in your setup, use it directly.
	var world_pos: Vector2 = hex_layer.cube_to_local(cube)
	world_root = get_tree().root.get_node("TileMapController")
	popup_parent = get_tree().root.get_node("TileMapController/Popups")

	var tile_ref := {
		"cube": cube,
		"world_pos": world_pos,   # used for marker + popup placement
		"tile_id": tile_info.get("tile_id", ""),
		"tile_type": tile_info.get("tile_type", ""),   # e.g., "Forest"
		"tile_def": tile_info.get("tile_def", {}),     # full definition dict
	}

	# Filter candidate events that match this tile type and pass their trigger
	var candidates: Array[GameEvent] = []
	var ttype : String = tile_ref["tile_type"]
	for ev in all_events:
		if ev.category == "tile" and ttype in ev.valid_tile_types:
			if ev.trigger_script:
				print("trigger_script:", ev.trigger_script, " type:", typeof(ev.trigger_script))
				var trig = ev.trigger_script.new()
				# Convention: evaluate(tile_ref, caravan, event_manager) -> bool
				if trig.has_method("evaluate") and trig.evaluate(tile_ref, caravan, self):
					candidates.append(ev)

	if candidates.is_empty():
		return

	var chosen := _random_pick(candidates)
	_spawn_marker_for_event(chosen, tile_ref)

func _random_pick(events: Array[GameEvent]) -> GameEvent:
	if events.is_empty():
		return null
	var idx := randi_range(0, events.size() - 1)
	return events[idx]

# ─── Marker & Popup handling ──────────────────────────────────────────────────
func _spawn_marker_for_event(ev: GameEvent, tile_ref: Dictionary) -> void:
	var marker := _marker_scene.instantiate()
	marker.setup(ev, tile_ref, tile_ref["world_pos"])
	marker.marker_clicked.connect(_open_event_popup)
	world_root.add_child(marker)

func _world_to_screen(p: Vector2) -> Vector2:
	var xf: Transform2D = get_viewport().get_canvas_transform()
	return xf * p

func _open_event_popup(ev: GameEvent, tile_ref: Dictionary) -> void:
	var popup := _popup_scene.instantiate()
	popup.setup(ev, tile_ref)
	popup_parent.add_child(popup)
	popup.visible = true
	
	   # Give it the tile’s world anchor so it can follow the camera
	if popup.has_method("set_world_anchor"):
		popup.set_world_anchor(tile_ref["world_pos"])

	## Center the popup near the tile on screen
	#if popup.has_method("place_on_screen"):
		#var screen_pos = _world_to_screen(tile_ref["world_pos"])
		#popup.place_on_screen(screen_pos)
		
