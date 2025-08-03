extends Control

# Card Type: Count
var cardsInventory: Dictionary

# A reference to your Card scene file. Preloading is efficient.
@onready var card_scene = preload("res://Scenes/UI/Card.tscn")

var selected_card_instance_id = 0
var is_open = true
var tween: Tween
var menu_panel_original_position: Vector2
const LIFT_AMOUNT = 192

@onready var menu_panel = $MenuPanel
@onready var container = $MenuPanel/CardContainer
@onready var deselect_card_button = $MenuPanel/DeselectButton
@onready var open_menu_hover = $OpenMenuHover

func _ready():
	# Init card inventory
	for i in range(10):
		cardsInventory[str(i)] = 0
	
	open_menu_hover.mouse_entered.connect(on_open_mouse_entered)
	menu_panel.mouse_exited.connect(on_hold_open_mouse_exited)
	
	deselect_card_button.gui_input.connect(on_deselect_button)
	
	menu_panel_original_position = menu_panel.position
	
	is_open = false
	menu_panel.position += Vector2(0, LIFT_AMOUNT)
	

	for i in range(container.get_child_count()):
		print("Loop child " + str(i))
		container.get_child(i).gui_input.connect(on_card_clicked.bind(container.get_child(i).get_instance_id()))
		
	add_card("1", 1)
	add_card("0", 2)
	add_card("1", 1)
	add_card("3", 1)
	add_card("1", 1)

# Add or remove cards to the inventory
func add_card(type: String, amount: int) -> void:
	cardsInventory[type] += amount
	
	# Remove up to #amount cards
	if amount < 0:
		var to_remove = [];
		for card in container.get_children():
			if card.card_type == type:
				to_remove.append(card)
		for i in range(min(-1 * amount, to_remove.size())):
			container.remove_child(to_remove[i])
		return
		
	# Add #amount cards
	# Find an alike card (if any) to insert similar cards next to
	var insert = 0
	for i in range(container.get_child_count()):
		if container.get_child(i).card_type == type:
			insert = i
			break
	
	# Insert the cards
	for i in range(amount):
		var card = card_scene.instantiate()
		card.set_type(type)
		card.gui_input.connect(on_card_clicked.bind(card.get_instance_id()))
		container.add_child(card)
		container.move_child(card, insert)
		
func select_card(instance_id: int) -> void:
	if self.selected_card_instance_id != 0:
		var previously_selected = instance_from_id(self.selected_card_instance_id) as Control
		previously_selected.modulate = Color("ffffffff")
	
	self.selected_card_instance_id = instance_id
	
	var selected = instance_from_id(self.selected_card_instance_id)
	if selected:
		selected.modulate = Color("999999ff")



############
# HANDLERS #
############
func on_card_clicked(event: InputEvent, instance_id: int) -> void:
	if event is not InputEventMouseButton:
		return
		
	if event.button_index != MOUSE_BUTTON_LEFT or not event.pressed:
		return
	
	var card = instance_from_id(instance_id)
	print("CARD WAS PRESSED (TYPE): " + card.card_type)
	select_card(instance_id)
	#add_card(card.card_type, -1)
	
func on_deselect_button(event: InputEvent) -> void:
	if event is not InputEventMouseButton:
		return
		
	if event.button_index != MOUSE_BUTTON_LEFT or not event.pressed:
		return
	
	print("DESELECT CARD")
	select_card(0)
	
func on_open_mouse_entered() -> void:
	# Nothing to do
	if(self.is_open):
		return
	self.is_open = true
	
	if tween and tween.is_running():
		tween.kill()
	tween = create_tween()
	tween.tween_property(menu_panel, "position", menu_panel_original_position, 0.2)
	print("MOUSE ENTER")
	#menu_panel.position = menu_panel_original_position
	
func on_hold_open_mouse_exited() -> void:
	# Nothing to do
	if(!self.is_open):
		return
	self.is_open = false
	
	if tween and tween.is_running():
		tween.kill()
	tween = create_tween()
	tween.tween_property(menu_panel, "position", menu_panel_original_position + Vector2(0, LIFT_AMOUNT), 0.2)
	print("MOUSE EXIT")
	#menu_panel.position = menu_panel_original_position + Vector2(0, LIFT_AMOUNT)
	
