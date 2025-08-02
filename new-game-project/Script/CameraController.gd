extends Camera2D

@onready var upgrades: Button = $MenuPanel/HBoxContainer/Upgrades
@onready var stats: Button = $MenuPanel/HBoxContainer/Stats
@onready var menu: Button = $MenuPanel/HBoxContainer/Menu
@onready var stats_panel: Control = $StatsPanel
@onready var upgrades_panel: Control = $UpgradesPanel


func _physics_process(delta: float) -> void:
	handle_movement(delta)
	#handle_zoom()
	if Input.is_action_just_pressed("Escape"):
		GlobalEventBusController.PauseMenu()
		

func handle_movement(delta: float) -> void:
	var input_vector := Input.get_vector("Left", "Right", "Up", "Down")
	if input_vector != Vector2.ZERO:
		self.global_position += input_vector * GlobalSettings.MoveSpeed * delta

func handle_zoom() -> void:
	var scroll_delta := Vector2(GlobalSettings.ScrollSpeed, GlobalSettings.ScrollSpeed)

	if Input.is_action_just_pressed("Scroll_Up"):
		zoom = clamp_vector2(zoom + scroll_delta, GlobalSettings.MinZoom, GlobalSettings.MaxZoom)
		scale = clamp_vector2(scale - scroll_delta, GlobalSettings.MinZoom, GlobalSettings.MaxZoom)
		#for e in get_children():
			#e.scale = clamp_vector2(e.scale + scroll_delta, GlobalSettings.MinZoom, GlobalSettings.MaxZoom)

	if Input.is_action_just_pressed("Scroll_Down"):
		zoom = clamp_vector2(zoom - scroll_delta, GlobalSettings.MinZoom, GlobalSettings.MaxZoom)
		scale = clamp_vector2(scale + scroll_delta, GlobalSettings.MinZoom, GlobalSettings.MaxZoom)
		#for e in get_children():
			#e.scale = clamp_vector2(e.scale - scroll_delta, GlobalSettings.MinZoom, GlobalSettings.MaxZoom)
			
func clamp_vector2(vec: Vector2, min_val: float, max_val: float) -> Vector2:
	return Vector2(
		clamp(vec.x, min_val, max_val),
		clamp(vec.y, min_val, max_val)
	)


func _on_menu_pressed() -> void:
	GlobalEventBusController.PauseMenu()


func _on_stats_pressed() -> void:
	stats_panel.visible = !stats_panel.visible


func _on_upgrades_pressed() -> void:
	upgrades_panel.visible = !upgrades_panel.visible
