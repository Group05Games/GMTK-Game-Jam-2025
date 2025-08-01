extends Node2D

@onready var map: HexagonTileMapLayer = $HexagonTileMapLayer
var MousePress

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	map.debug_mode = HexagonTileMapLayer.DebugModeFlags.TILES_COORDS
	pass

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("Mouse_1"):
		MousePress = get_global_mouse_position()
		var result = map.local_to_cube(MousePress)
		#print("Clicked " , MousePress , " and found: " , result)
		
		var tile = map.get_cell_source_id(map.cube_to_map(result))
		print(tile)
		#print(GlobalSettings.TileDictionary.Bog.ID)
		
		var ev := EventManager.get_event_by_name("Bandit Ambush")
		EventManager.show_event_popup(ev, tile)
		
		var search = str(tile)
		if tile != -1 && GlobalSettings.TileDictionary[search] != null:
			print(GlobalSettings.TileDictionary[search])
		else:
			print("invalid tile")
