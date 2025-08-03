extends Node

enum ResourceType { NONE, WHEAT, METAL, WOOD, GOLD }

var CityInventory : Inventory = Inventory.new()

var CityState =  0

var ResourceGoldValues : Dictionary = {
	ResourceType.NONE : 0,
	ResourceType.WHEAT : 3,
	ResourceType.METAL : 25,
	ResourceType.WOOD : 5,
	ResourceType.GOLD : 1,
}

## Make sure the ID number of the Tile Dictionary matches the ID number of the TileSet.
var TileDictionary : Dictionary = {
	"0" : {"Name" : "Grasslands", "Move Cost" : 1, "Resource" : ResourceType.WHEAT},
	"1" : {"Name" : "Forest", "Move Cost" : 2, "Resource" : ResourceType.WOOD},
	"2" : {"Name" : "Bog", "Move Cost" : 3, "Resource" : ResourceType.NONE},
	"3" : {"Name" : "Water", "Move Cost" : 5, "Resource" : ResourceType.NONE},
	"4" : {"Name" : "Mountain", "Move Cost" : 10, "Resource" : ResourceType.METAL},
	"5" : {"Name" : "Mine", "Move Cost" : 1, "Resource" : ResourceType.METAL, "NeighborBonuses": {"4": 1, "6": 4, "3": -1}},
	"6" : {"Name" : "Volcano", "Move Cost" : 10, "Resource" : ResourceType.NONE},
	"7" : {"Name" : "City", "Move Cost" : 1, "Resource" : ResourceType.NONE},
	"8" : {"Name" : "Barren", "Move Cost" : 1, "Resource" : ResourceType.NONE},
	"9" : {"Name" : "Town", "Move Cost" : 1, "Resource" : ResourceType.NONE},
	"10" : {"Name" : "Sawmill", "Move Cost" : 1, "Resource" : ResourceType.WOOD, "NeighborBonuses": {"1": 1}},
	"11": {"Name" : "Farm", "Move Cost": 1, "Resource": ResourceType.WHEAT, "NeighborBonuses": {"0": 1}}
}

var ScrollSpeed : float = 0.2
var MoveSpeed : float = 1000
var ShiftMoveSpeed : float = 2.0
var MaxZoom : float = 2.0
var MinZoom : float = 0.1
var InMenu : bool = false
var InPathPlacementMode = false
var bus_index: int
var day : int

func _ready():
	CityInventory.initInv()
	var temp : Inventory = Inventory.new()
	temp.setItems([ResourceType.WOOD, ResourceType.GOLD, ResourceType.METAL], [1, -1, 3])
	
	print("Wood " + str(CityInventory.inventory[ResourceType.WOOD]))
	print("Gold " + str(CityInventory.inventory[ResourceType.GOLD]))
	CityInventory.addArray([ResourceType.WOOD, ResourceType.GOLD], [2, 1])
	CityInventory.addArray([ResourceType.WHEAT, ResourceType.GOLD], [100, 1])
	print()
	print("Wood " + str(CityInventory.inventory[ResourceType.WOOD]))
	print("Gold " + str(CityInventory.inventory[ResourceType.GOLD]))
	CityInventory.addArray([ResourceType.WOOD], [-2])
	print()
	print("Wood " + str(CityInventory.inventory[ResourceType.WOOD]))
	print("Gold " + str(CityInventory.inventory[ResourceType.GOLD]))
	#CityInventory.emptyInventory()
	#print("Wood " + str(CityInventory.inventory[ResourceType.WOOD]))
	#print("Gold " + str(CityInventory.inventory[ResourceType.GOLD]))
	CityInventory.addInventory(temp.inventory)
	print()
	print("Wood " + str(CityInventory.inventory[ResourceType.WOOD]))
	print("Gold " + str(CityInventory.inventory[ResourceType.GOLD]))
	print("Metal " + str(CityInventory.inventory[ResourceType.METAL]))
	print()
	print("Wheat: " + str(CityInventory.inventory[ResourceType.WHEAT]))
	#CityInventory.convertToGold()
