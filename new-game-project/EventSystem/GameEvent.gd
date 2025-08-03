extends Resource
class_name GameEvent

@export var name: String
@export var description: String
@export var category: String # "global" or "tile"
@export var valid_tile_types: Array[String]
@export var trigger_script: Script
@export var art: Texture
@export var marker_icon: Texture2D = null
@export var options: Array[OptionData]
