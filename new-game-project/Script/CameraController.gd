extends Camera2D

@onready var upgrades: Button = $MenuPanel/HBoxContainer/Upgrades
@onready var stats: Button = $MenuPanel/HBoxContainer/Stats
@onready var menu: Button = $MenuPanel/HBoxContainer/Menu
@onready var stats_panel: Control = $StatsPanel
@onready var upgrades_panel: Control = $UpgradesPanel
@onready var caravansToMove = get_tree().get_nodes_in_group("Caravan")
@onready var log_panel: Panel = $LogPanel
@onready var path_select_panel = $PathSelectPanel

var LogShow : bool = true
var upgrade_line 

func _ready():
	upgrade_line = get_tree().get_nodes_in_group("UpgradeLine")

func _physics_process(delta: float) -> void:
	handle_movement(delta)
	#handle_zoom()
	if Input.is_action_just_pressed("Escape"):
		GlobalEventBusController.PauseMenu()

func handle_movement(delta: float) -> void:
	var input_vector := Input.get_vector("Left", "Right", "Up", "Down")
	if input_vector != Vector2.ZERO && Input.is_action_pressed("Shift"):
		self.global_position += input_vector * GlobalSettings.MoveSpeed * 2 * delta
		for e in upgrade_line:
			e.global_position += input_vector * GlobalSettings.MoveSpeed * 2 * delta
		for e in caravansToMove:
			e.path_to_follow.global_position += input_vector * GlobalSettings.MoveSpeed * 2 * delta
	elif input_vector != Vector2.ZERO: 
		self.global_position += input_vector * GlobalSettings.MoveSpeed * delta
		for e in upgrade_line:
			e.global_position += input_vector * GlobalSettings.MoveSpeed * delta
		for e in caravansToMove:
			e.path_to_follow.global_position += input_vector * GlobalSettings.MoveSpeed * delta

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


func _on_give_me_random_resource_pressed() -> void:
	var rng = randi_range(1,4)
	
	GlobalSettings.CityInventory.addArray([GlobalSettings.ResourceType.values()[rng], GlobalSettings.ResourceType.values()[rng]], [2, 1])
	
func _on_log_pressed() -> void:
	if LogShow == true:
		log_panel.position = lerp(log_panel.position, log_panel.position - Vector2(0, 750), .8)
		log_panel.get_child(0).text = "Show"
	else:
		log_panel.position = lerp(log_panel.position, log_panel.position + Vector2(0, 750), .8)
		log_panel.get_child(0).text = "Hide"
	LogShow = !LogShow


func _on_place_paths_pressed():
	path_select_panel.visible = !path_select_panel.visible

func _on_path_1_pressed():
	GlobalSettings.caravanIndex = 1
	GlobalSettings.set_in_path_placement_mode(true)
	path_select_panel.visible = false

func _on_path_2_pressed():
	GlobalSettings.caravanIndex = 2
	GlobalSettings.set_in_path_placement_mode(true)
	path_select_panel.visible = false

func _on_path_3_pressed():
	GlobalSettings.caravanIndex = 3
	GlobalSettings.set_in_path_placement_mode(true)
	path_select_panel.visible = false
