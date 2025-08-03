extends HSlider


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	value = GlobalSettings.ShiftMoveSpeed

func _on_drag_ended(value_changed: bool) -> void:
	GlobalSettings.ShiftMoveSpeed = value
