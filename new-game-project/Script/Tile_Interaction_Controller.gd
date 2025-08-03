extends Node2D

@onready var map: HexagonTileMapLayer = $HexagonTileMapLayer
var MousePress

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#map.debug_mode = HexagonTileMapLayer.DebugModeFlags.TILES_COORDS
	pass

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("Mouse_1") && GlobalSettings.InMenu != true:
		MousePress = get_global_mouse_position() #Where is mouse cursor
		var result = map.local_to_cube(MousePress)  #Converting cursor space into Hex Space
		#print("Clicked " , MousePress , " and found: " , result)
		
		var tile = map.get_cell_source_id(map.cube_to_map(result)) #Covert Hex Space into 2D TileMap Space
		#print(tile)
		#print(GlobalSettings.TileDictionary.Bog.ID)
		
		var search = str(tile)
		if tile != -1 && GlobalSettings.TileDictionary[search] != null:
			var tile_def = GlobalSettings.TileDictionary[search]
			print(tile_def)
			
			var tile_info = {
				"tile_id": tile,
				"tile_type": tile_def.Name,
				"tile_def": tile_def
			}
			
			EventManager.request_tile_event_for_cube(map, result, tile_info, self)
		
		else:
			print("invalid tile")
	
	if Input.is_action_just_pressed("Mouse_2") && GlobalSettings.InMenu != true:
		MousePress = get_global_mouse_position()
		var result = map.local_to_cube(MousePress)
		#print("Clicked " , MousePress , " and found: " , result)
		
		var tile = map.get_cell_source_id(map.cube_to_map(result))
		#print(tile)
		#print(GlobalSettings.TileDictionary.Bog.ID)
		
		var search = str(tile)
		if tile != -1 && GlobalSettings.TileDictionary[search] != null:
			#print(GlobalSettings.TileDictionary[search])
			GlobalSignalBusController.SendMapInformation.emit(self, search)
		else:
			print("invalid tile")
