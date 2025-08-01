extends Node2D
class_name EventMarker

signal marker_clicked(event_data, tile_ref)

@export var event_data : GameEvent   # GameEvent resource
var tile_ref                         # tile object or (tilemap, cell) struct

func setup(ev, tile, world_pos: Vector2):
	event_data = ev
	tile_ref = tile
	global_position = world_pos

func _ready():
	$TextureButton.pressed.connect(func ():
		marker_clicked.emit(event_data, tile_ref)
		queue_free())  # remove the marker after opening the popup
