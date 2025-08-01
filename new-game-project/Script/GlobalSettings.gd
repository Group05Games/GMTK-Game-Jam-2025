extends Node

var CityStats : Dictionary = {
	"Population" : 0,
	"Gold" : 0,
	"Wood" : 0,
	"Metal" : 0,
	"Food" : 0,
	"State" : 0,
}

enum ResourceType { NONE, WHEAT, METAL, WOOD, GOLD }

## Make sure the ID number of the Tile Dictionary matches the ID number of the TileSet.
var TileDictionary : Dictionary = {
	"0" : {"Name" : "Grasslands", "Move Cost" : 1, "Resource" : ResourceType.WHEAT},
	"1" : {"Name" : "Forest", "Move Cost" : 1, "Resource" : ResourceType.WOOD},
	"2" : {"Name" : "Bog", "Move Cost" : 1, "Resource" : ResourceType.NONE},
	"3" : {"Name" : "Water", "Move Cost" : 5, "Resource" : ResourceType.NONE},
	"4" : {"Name" : "Mountain", "Move Cost" : 10, "Resource" : ResourceType.METAL},
	"5" : {"Name" : "Mine", "Move Cost" : 1, "Resource" : ResourceType.METAL, "NeighborBonuses": {"4": 1, "6": 4, "3": -1}},
	"6" : {"Name" : "Volcano", "Move Cost" : 1, "Resource" : ResourceType.NONE},
	"7" : {"Name" : "City", "Move Cost" : 1, "Resource" : ResourceType.NONE},
	"8" : {"Name" : "Town", "Move Cost" : 1, "Resource" : ResourceType.NONE},
	"9" : {"Name" : "Sawmill", "Move Cost" : 1, "Resource" : ResourceType.WOOD, "NeighborBonuses": {"1": 1}},
	"10": {"Name" : "Farm", "Move Cost": 1, "Resource": ResourceType.WHEAT, "NeighborBonuses": {"0": 1}}
}

var ScrollSpeed : float = 0.2
var MoveSpeed : float = 600
var MaxZoom : float = 2.0
var MinZoom : float = 0.1
