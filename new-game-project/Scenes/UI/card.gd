extends Control

@export var card_type = "0"

func _ready():
	pass
	
func set_type(type: String) -> void:
	self.card_type = type;
	name = GlobalSettings.TileDictionary[type]["Name"]
	var label = get_child(0).get_child(1) as Label
	label.text = name
