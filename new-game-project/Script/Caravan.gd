extends Node

@onready var map : HexagonTileMapLayer = get_tree().get_first_node_in_group("TileMap")
@onready var path = $Path2D2
@onready var path_follow = $Path2D2/PathFollow2D
@onready var caravan = $Path2D2/PathFollow2D/Caravan
@onready var timer = $Path2D2/PathFollow2D/Caravan/Timer

var CaravanInventory : Inventory = Inventory.new()

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
	#map.cube_neighbors()
	#While active should:
	#Take user left clicks on neighboring nodes
	#Add node to the path if it is not already part of the path
	#Continue from the last node selected
	#Left click on already selected node should deselect that node and all child nodes
	#If the head of the list and the tail of he list are the same node, we have completed the loop.
	#  #Save the path running between all points
	
	pass
