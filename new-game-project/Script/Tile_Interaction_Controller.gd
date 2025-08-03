extends Node2D

@onready var map: HexagonTileMapLayer = $HexagonTileMapLayer
@onready var cardInventory = $Camera2D/CardSelectMenu
var Caravans
var MousePress
@onready var caravan_holder: Node2D = $CaravanHolder

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#var result = map.local_to_cube(Vector2(0.0, -64.0))
	#var tile = map.get_cell_source_id(map.cube_to_map(result))
	#var tile_def = GlobalSettings.TileDictionary[str(tile)]
	#
	#var tile_info = {
		#"tile_id": tile,
		#"tile_type": tile_def.Name,
		#"tile_def": tile_def
	#}
	#
	#EventManager.request_tile_event_for_cube(map, result, tile_info, self)
	caravan_holder.position = map.cube_to_local(Vector3(0,0,0))

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("Mouse_1") && GlobalSettings.InMenu != true && !GlobalSettings.InPathPlacementMode:
		MousePress = get_global_mouse_position() #Where is mouse cursor
		var result = map.local_to_cube(MousePress)  #Converting cursor space into Hex Space
		var clicked_tile_position = map.cube_to_map(result)
		var tile = map.get_cell_source_id(clicked_tile_position) #Covert Hex Space into 2D TileMap Space
		
		var search = str(tile)
		if tile == -1 || GlobalSettings.TileDictionary[search] == null:
			print("invalid tile")
			return
		
		var tile_def = GlobalSettings.TileDictionary[search]
		#print(tile_def)
		
		handle_tile_placements(search, clicked_tile_position)
		
	
	if Input.is_action_just_pressed("Mouse_2") && GlobalSettings.InMenu != true && !GlobalSettings.InPathPlacementMode:
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
		
	if Input.is_action_just_pressed("Mouse_1") && GlobalSettings.InMenu != true && GlobalSettings.InPathPlacementMode:
		MousePress = get_global_mouse_position() #Where is mouse cursor
		var result : Vector3i = map.local_to_cube(MousePress)  #Converting cursor space into Hex Space
		var initialPoint : Vector3i
		
		if GlobalSettings.caravanPathBuiler == []: 
			initialPoint = map.map_to_cube(Vector2i(0,0))
			print(GlobalSettings.Caravan1.line_2d)
			GlobalSettings.Caravan1.line_2d = GlobalSettings.Caravan1.get_child(1)
			for e in get_tree().get_nodes_in_group("Caravan"):
					if e.name == "Caravan1":
						e.line_2d.add_point(Vector2(128, 128))
					if e.name == "Caravan2":
						e.line_2d.add_point(Vector2(128, 128))
					if e.name == "Caravan3":
						e.line_2d.add_point(Vector2(128, 128))
			GlobalSettings.caravanPathBuiler.append(map.map_to_cube(Vector2i(0,0)))
		else:
			initialPoint = GlobalSettings.caravanPathBuiler[GlobalSettings.caravanPathBuiler.size() - 1]
		
		if result in map.cube_neighbors(initialPoint):
			if result == map.map_to_cube(Vector2i(0,0)):
				for e in get_tree().get_nodes_in_group("Caravan"):
					if e.name == "Caravan1":
						e.line_2d.add_point(Vector2(128, 128))
					if e.name == "Caravan2":
						e.line_2d.add_point(Vector2(128, 128))
					if e.name == "Caravan3":
						e.line_2d.add_point(Vector2(128, 128))
				print("Complete Loop")
				GlobalSettings.set_in_path_placement_mode(false)
				
				#Path builder array to curve2d points
				var curveBuilder = []
				for point in GlobalSettings.caravanPathBuiler:
					curveBuilder.append(map.cube_to_local(point))
				var curve : Curve2D = Curve2D.new()
				for point in curveBuilder:
					curve.add_point(point)
				
				if GlobalSettings.caravanIndex == 1:
					Caravans[0].pathCurve = curve
					Caravans[0].definePath()
					Caravans[0].pathHexArray = GlobalSettings.caravanPathBuiler
				if GlobalSettings.caravanIndex == 2:
					Caravans[1].pathCurve = curve
					Caravans[1].definePath()
					Caravans[1].pathHexArray = GlobalSettings.caravanPathBuiler
				if GlobalSettings.caravanIndex == 3:
					Caravans[2].pathCurve = curve
					Caravans[2].definePath()
					Caravans[2].pathHexArray = GlobalSettings.caravanPathBuiler
				#Caravans[0].getItemsFromLoop()
				GlobalSettings.caravanIndex = 0
				GlobalSettings.caravanPathBuiler = []
			else:
				#Not yet in our path, add it if we have enough moves
				if result not in GlobalSettings.caravanPathBuiler:
					if GlobalSettings.caravanPathBuiler.size() < GlobalSettings.caravanMoveLimit + 1:
						print("adding new space to path" + str(result))
						GlobalSettings.caravanPathBuiler.append(result)
						var c = get_tree().get_nodes_in_group("Caravan")
						c[0].line_2d.add_point(map.cube_to_local(result))
						print(str(GlobalSettings.caravanPathBuiler))
				#In our path, remove all nodes after this item
				else:
					#Find result in path builder
					var end : int = GlobalSettings.caravanPathBuiler.find(result)
					#Remove all elements after but excluding result
					var i = 0
					var temp = []
					while i < end + 1:
						temp.append(GlobalSettings.caravanPathBuiler[i])
						i += 1;
					
					if temp.is_empty():
						temp.append(map.map_to_cube(Vector2i(0,0)))
					GlobalSettings.caravanPathBuiler = temp
					
					var c = get_tree().get_nodes_in_group("Caravan")
					c[0].line_2d.clear_points()
					for item in temp:
						c[0].line_2d.add_point(map.cube_to_local(item))
					print("Removed elements. New Array: " + str(temp))
		#Not a neighbor but in our path, remove all nodes after this
		elif result in GlobalSettings.caravanPathBuiler:
			#Find result in path builder
			var end : int = GlobalSettings.caravanPathBuiler.find(result)
			#Remove all elements after but excluding result
			var i = 0
			var temp = []
			while i < end + 1:
				temp.append(GlobalSettings.caravanPathBuiler[i])
				i += 1;
			if temp.is_empty():
					temp.append(map.map_to_cube(Vector2i(0,0)))
			GlobalSettings.caravanPathBuiler = temp
			
			var c = get_tree().get_nodes_in_group("Caravan")
			c[0].line_2d.clear_points()
			for item in temp:
				c[0].line_2d.add_point(map.cube_to_local(item))
			print("Removed elements. New Array: " + str(temp))
	
	if Input.is_action_just_pressed("Mouse_2") && GlobalSettings.InMenu != true && GlobalSettings.InPathPlacementMode:
		GlobalSettings.set_in_path_placement_mode(false)
		GlobalSettings.caravanPathBuiler = []

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


func _on_ready() -> void:
	var spawner = GlobalSettings.CaravanToSpawn.instantiate()
	spawner.name = "Caravan1"
	get_tree().get_first_node_in_group("CaravanHolder").add_child(spawner)
	
	
	var spawner2 = GlobalSettings.CaravanToSpawn.instantiate()
	spawner2.hide()
	spawner2.name = "Caravan2"
	get_tree().get_first_node_in_group("CaravanHolder").add_child(spawner2)
	
	var spawner3 = GlobalSettings.CaravanToSpawn.instantiate()
	spawner3.hide()
	spawner3.name = "Caravan3"
	get_tree().get_first_node_in_group("CaravanHolder").add_child(spawner3)
	
	Caravans = get_tree().get_nodes_in_group("Caravan")
