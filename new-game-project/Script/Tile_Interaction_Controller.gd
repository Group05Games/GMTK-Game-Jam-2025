extends Node2D

@onready var map: HexagonTileMapLayer = $HexagonTileMapLayer
@onready var cardInventory = $Camera2D/CardSelectMenu
var MousePress

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	var result = map.local_to_cube(Vector2(0.0, -64.0))
	var tile = map.get_cell_source_id(map.cube_to_map(result))
	var tile_def = GlobalSettings.TileDictionary[str(tile)]
	
	var tile_info = {
		"tile_id": tile,
		"tile_type": tile_def.Name,
		"tile_def": tile_def
	}
	
	EventManager.request_tile_event_for_cube(map, result, tile_info, self)

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("Mouse_1") && GlobalSettings.InMenu != true:
		MousePress = get_global_mouse_position() #Where is mouse cursor
		var result = map.local_to_cube(MousePress)  #Converting cursor space into Hex Space
		var clicked_tile_position = map.cube_to_map(result)
		var tile = map.get_cell_source_id(clicked_tile_position) #Covert Hex Space into 2D TileMap Space
		
		var search = str(tile)
		if tile == -1 || GlobalSettings.TileDictionary[search] == null:
			print("invalid tile")
			return
		
		var tile_def = GlobalSettings.TileDictionary[search]
		print(tile_def)
		
		handle_tile_placements(search, clicked_tile_position)
		
	
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

# Handle tile placements
func handle_tile_placements(clicked_tile_id, clicked_tile_position) -> void:
		if !GlobalSettings.InTilePlacementMode || cardInventory.selected_card_instance_id == 0:
			return
		
		if cardInventory.get_rect().has_point(MousePress):
			return
		
		# Dont place cards on the tile if it is already that tile
		var selected_card = instance_from_id(cardInventory.selected_card_instance_id)
		if clicked_tile_id == selected_card.card_type:
			return
		
		# Dont destroy towns
		if GlobalSettings.ProtectedTiles.has(clicked_tile_id):
			return
		
		print("SETTING TILE (" + str(clicked_tile_position) + ") to " + selected_card.card_type)
		map.set_cell(clicked_tile_position, int(selected_card.card_type), Vector2i(0, 0))
		cardInventory.add_card(selected_card.card_type, -1)
		cardInventory.deselect()
