extends Control

var event_data
var tile_ref
var _world_anchor := Vector2.ZERO

var WindowLbl
var PaddingLbl
var ColumnLbl
var TitleLbl
var ContentLbl
var ArtLbl
var DescriptionLbl
var OptionContainerLbl

func _ready() -> void:
	WindowLbl = $Window
	PaddingLbl = $Window/Padding
	ColumnLbl = $Window/Padding/Column
	TitleLbl = $Window/Padding/Column/Title
	ContentLbl = $Window/Padding/Column/Content
	ArtLbl = $Window/Padding/Column/Content/Art
	DescriptionLbl = $Window/Padding/Column/Content/Description
	OptionContainerLbl = $Window/Padding/Column/OptionContainer
	
	mouse_filter = Control.MOUSE_FILTER_STOP
	$Window.mouse_filter = Control.MOUSE_FILTER_STOP

func setup(event, tile):
	await ready
	
	event_data = event
	tile_ref = tile
	
	TitleLbl.text = event.name
	
	var tex: Texture2D = null
	if event.has_method("get"): # if it's a Resource with exported fields
		tex = event.get("icon") if event.get("icon") is Texture2D else null
	else:
		tex = event.icon if event.icon is Texture2D else null
		
	ArtLbl.texture = tex
	ArtLbl.visible = tex != null
	if ArtLbl.visible and ArtLbl.custom_minimum_size == Vector2.ZERO:
		ArtLbl.custom_minimum_size = Vector2(96, 96) # tweak to taste	

	# Rebuild options row (buttons laid out horizontally)
	for c in OptionContainerLbl.get_children():
		c.queue_free()

	for option in event.options:
		var btn := Button.new()
		btn.text = option.get("text")
		btn.tooltip_text = option.get("tooltip")
		btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		btn.pressed.connect(_on_option_selected.bind(option))
		OptionContainerLbl.add_child(btn)

# --- POSITIONING --------------------------------------------------------------

func place_on_screen(screen_pos: Vector2) -> void:
	# Ensure we have a size after being added to the tree
	await get_tree().process_frame
	
	var panel : Panel = WindowLbl
	
	# Give the panel a min size for stable centering (tweak to taste)
	if panel.custom_minimum_size == Vector2.ZERO:
		panel.custom_minimum_size = Vector2(420, 260)
	
	panel.size = panel.get_combined_minimum_size()
	
	panel.position = screen_pos - panel.size * 0.5
	_clamp_panel_to_viewport(panel)

func _clamp_panel_to_viewport(panel: Panel) -> void:
	var vp := get_viewport_rect().size
	var size := panel.size
	global_position.x = clamp(global_position.x, 8.0, vp.x - size.x - 8.0)
	global_position.y = clamp(global_position.y, 8.0, vp.y - size.y - 8.0)

func set_world_anchor(p: Vector2) -> void:
	_world_anchor = p

# --- OPTION HANDLERS ----------------------------------------------------------

func _on_option_selected(option: OptionData) -> void:
	var eff_res = option.get("effect_script")
	var eff = (eff_res.new() if eff_res is Script else eff_res)
	if eff and eff.has_method("apply"):
		eff.apply(tile_ref, EventManager)  # pass EventManager for game state access
	queue_free()
	
func _process(_dt: float) -> void:
	if _world_anchor != Vector2.ZERO:
		var screen_pos := get_viewport().get_canvas_transform() * _world_anchor
		_place_panel_at(screen_pos)
		
func _place_panel_at(screen_pos: Vector2) -> void:
	# If your root is Full Rect, position the inner Panel:
	var panel = WindowLbl
	if panel.custom_minimum_size == Vector2.ZERO:
		panel.custom_minimum_size = Vector2(420, 260) # tweak
	if panel.size == Vector2.ZERO:
		panel.size = panel.get_combined_minimum_size()
	panel.position = screen_pos - panel.size * 0.5
	_clamp_panel_to_viewport(panel)
