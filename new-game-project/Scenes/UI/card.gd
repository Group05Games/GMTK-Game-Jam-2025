extends Control

@export var card_type = "0"
const card_animations = [
	"card_grassland",
	"card_forest",
	"card_bog",
	"card_water",
	"card_mountain",
	"card_mine",
	"card_volcano",
	"card_city",
	"",
	"card_city",
	"",
	"card_farm",
	""
]

func _ready():
	pass
	
func set_type(type: String) -> void:
	self.card_type = type;
	name = GlobalSettings.TileDictionary[type]["Name"]
	var label = get_child(0).get_child(2) as Label
	label.text = name
	
	var card_type_display = get_child(0).get_child(1) as AnimatedSprite2D
	var anim_index = int(type)
	if anim_index > card_animations.size() || card_animations[anim_index] == "":
		card_type_display.visible = false
		return
	card_type_display.visible = true
	card_type_display.play(card_animations[anim_index])
