extends Camera2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("Up"):
		self.global_position += Vector2(0, -10)
	if Input.is_action_pressed("Down"):
		self.global_position += Vector2(0, 10)
	if Input.is_action_pressed("Left"):
		self.global_position += Vector2(-10, 0)
	if Input.is_action_pressed("Right"):
		self.global_position += Vector2(10, 0)
		
	if Input.is_action_just_pressed("Scroll_Up"):
		if zoom.x < 2 && zoom.y < 2:
			zoom += Vector2(GlobalSettings.ScrollSpeed, GlobalSettings.ScrollSpeed)
		
	if Input.is_action_just_pressed("Scroll_Down"):
		if zoom.x > 0 && zoom.y > 0:
			zoom -= Vector2(GlobalSettings.ScrollSpeed, GlobalSettings.ScrollSpeed)
