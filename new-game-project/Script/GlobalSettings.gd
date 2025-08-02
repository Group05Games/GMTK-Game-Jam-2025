extends Node


var CityInventory : Inventory = Inventory.new()
var temp : Inventory = Inventory.new()

var CityState =  0

enum ResourceType { NONE, WHEAT, METAL, WOOD, GOLD }

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
	"8" : {"Name" : "Town", "Move Cost" : 1, "Resource" : ResourceType.NONE},
	"9" : {"Name" : "Sawmill", "Move Cost" : 1, "Resource" : ResourceType.WOOD, "NeighborBonuses": {"1": 1}},
	"10": {"Name" : "Farm", "Move Cost": 1, "Resource": ResourceType.WHEAT, "NeighborBonuses": {"0": 1}}
}

var ScrollSpeed : float = 0.2
var MoveSpeed : float = 1000
var MaxZoom : float = 2.0
var MinZoom : float = 0.1

func _ready():
	temp.setItems(["Wood", "Gold", "Population"], [1, -1, 3])
	
	print("Wood " + str(CityInventory.inventory["Wood"]))
	print("Gold " + str(CityInventory.inventory["Gold"]))
	CityInventory.addArray(["Wood", "Gold"], [2, 1])
	print()
	print("Wood " + str(CityInventory.inventory["Wood"]))
	print("Gold " + str(CityInventory.inventory["Gold"]))
	CityInventory.addArray(["Wood"], [-2])
	print()
	print("Wood " + str(CityInventory.inventory["Wood"]))
	print("Gold " + str(CityInventory.inventory["Gold"]))
	#CityInventory.emptyInventory()
	#print("Wood " + str(CityInventory.inventory["Wood"]))
	#print("Gold " + str(CityInventory.inventory["Gold"]))
	CityInventory.addInventory(temp.inventory)
	print()
	print("Wood " + str(CityInventory.inventory["Wood"]))
	print("Gold " + str(CityInventory.inventory["Gold"]))
	print("Pop " + str(CityInventory.inventory["Population"]))
