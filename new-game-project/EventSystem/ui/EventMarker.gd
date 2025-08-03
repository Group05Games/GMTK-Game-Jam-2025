extends Area2D
class_name EventMarker

signal marker_clicked(event_data, tile_ref)

@export var event_data : GameEvent
var tile_ref: Dictionary

func setup(ev, tile_ref_in: Dictionary, world_pos: Vector2) -> void:
	event_data = ev
	tile_ref = tile_ref_in
	global_position = world_pos

func _ready() -> void:
	input_event.connect(_on_input_event)

func _on_input_event(_vp, event, _shape_idx) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		marker_clicked.emit(event_data, tile_ref)
		queue_free()
		
func set_icon_texture(tex: Texture2D) -> void:
	if $Sprite2D and tex:
		$Sprite2D.texture = tex
		$Sprite2D.centered = true
		# Resize click shape to icon (rectangle example)
		if $CollisionShape2D.shape is RectangleShape2D:
			var size = tex.get_size() * $Sprite2D.scale
			$CollisionShape2D.shape.extents = size * 0.5
