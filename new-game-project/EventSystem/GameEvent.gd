extends Resource
class_name GameEvent

@export var name: String
@export var description: String
@export var category: String # "global" or "tile"
@export var valid_tile_types: Array[String]
@export var trigger_script: Script
@export var icon: Texture
@export var options: Array[OptionData]
