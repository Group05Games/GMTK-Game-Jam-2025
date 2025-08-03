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
	# Center the sprite visually on (0,0)
	var spr := $Sprite2D
	if spr:
		spr.centered = true  # ensures icon is centered at node origin
		# Auto-size the collision to match the sprite texture (optional)
		var tex = spr.texture
		if tex and $CollisionShape2D.shape is RectangleShape2D:
			var size = tex.get_size() * spr.scale
			$CollisionShape2D.shape.extents = size * 0.5
		elif tex and $CollisionShape2D.shape is CircleShape2D:
			$CollisionShape2D.shape.radius = max(tex.get_size().x, tex.get_size().y) * 0.5 * max(spr.scale.x, spr.scale.y)

	input_event.connect(_on_input_event)

func _on_input_event(_vp, event, _shape_idx) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		marker_clicked.emit(event_data, tile_ref)
		queue_free()
