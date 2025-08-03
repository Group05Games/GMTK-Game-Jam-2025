extends Node
class_name Caravan

@onready var map : HexagonTileMapLayer = get_tree().get_first_node_in_group("TileMap")
@onready var path_to_follow: Path2D = $PathToFollow
@onready var path_follow = $Path2D2/PathFollow2D
@onready var caravan = $Path2D2/PathFollow2D/Caravan
@onready var timer = $Path2D2/PathFollow2D/Caravan/Timer
@onready var line_2d: Line2D = $Line2D

var CaravanInventory : Inventory = Inventory.new()
var isActive : bool = false
var pathCurve : Curve2D = null
var pathHexArray : Array = []

func _ready():
	CaravanInventory.initInv()

func deposit():
	GlobalSettings.CityInventory.addInventory(CaravanInventory.inventory)
	CaravanInventory.emptyInventory()

func depositAsGold():
	CaravanInventory.convertToGold()
	GlobalSettings.CityInventory.addInventory(CaravanInventory.inventory)
	CaravanInventory.emptyInventory()

func definePath():
	#Tile_Interaction_Controller
	#map.cube_neighbors()
	#While active should:
	#Take user left clicks on neighboring nodes
	#Add node to the path if it is not already part of the path
	#Continue from the last node selected
	#Left click on already selected node should deselect that node and all child nodes
	#If the head of the list and the tail of he list are the same node, we have completed the loop.
	#  #Save the path running between all points
	print("Defining Path")
	path_to_follow = get_child(0)
	print(path_to_follow)
	print(path_to_follow.curve)
	print(pathCurve)
	path_to_follow.curve = pathCurve

func getItemsFromLoop():
	for i in pathHexArray:
		var tile = map.get_cell_source_id(map.cube_to_map(i))
		
		var search = str(tile)
		if tile == -1 || GlobalSettings.TileDictionary[search] == null:
			print("invalid tile")
			return
		
		var tile_def = GlobalSettings.TileDictionary[search]
		var resource = tile_def["Resource"]
		if resource != 0:
			CaravanInventory.addArray([resource], [1])
	print("Caravan Inv: " + str(CaravanInventory.inventory[1]))

func _on_tree_entered() -> void:
	await get_tree().create_timer(.1).timeout
	path_to_follow = get_child(0)
	line_2d = get_child(1)
