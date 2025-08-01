extends Node

var CityStats : Dictionary = {
	"Population" : 0,
	"Gold" : 0,
	"Wood" : 0,
	"Metal" : 0,
	"Food" : 0,
	"State" : 0,
}

var TileDictionary : Dictionary = {
	"0" : {"Name" : "Grasslands", "Move Cost" : 1, "Resource" : "Wheat"},
	"1" : {"Name" : "Forest", "Move Cost" : 1, "Resource" : "Wood"},
	"2" : {"Name" : "Bog", "Move Cost" : 1, "Resource" : "None"},
	"3" : {"Name" : "Water", "Move Cost" : 5, "Resource" : "None"},
	"4" : {"Name" : "Mountain", "Move Cost" : 1, "Resource" : "Metal"},
	"5" : {"Name" : "Mine", "Move Cost" : 1, "Resource" : "Metal"},
	"6" : {"Name" : "Volcano", "Move Cost" : 1, "Resource" : "Metal"},
	"7" : {"Name" : "City", "Move Cost" : 1},
	"8" : {"Name" : "Town", "Move Cost" : 1},
}


var ScrollSpeed : float = 0.2
