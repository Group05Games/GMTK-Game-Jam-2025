extends HSlider


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	value = GlobalSettings.MoveSpeed

func _on_drag_ended(value_changed: bool) -> void:
		GlobalSettings.MoveSpeed = value
