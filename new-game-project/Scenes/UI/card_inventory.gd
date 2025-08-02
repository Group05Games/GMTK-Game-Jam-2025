extends Control

# Card Type: Count
var cardsInventory: Dictionary

# A reference to your Card scene file. Preloading is efficient.
@onready var card_scene = preload("res://Scenes/UI/Card.tscn")

var selected_card_instance_id = 0

# Contains all the card objects
var container: HBoxContainer

func _ready():
	# Init card inventory
	for i in range(10):
		cardsInventory[str(i)] = 0
	
	container = self.get_child(0)
	self.get_child(1).gui_input.connect(on_deselect)

	for i in range(container.get_child_count()):
		print("Loop child " + str(i))
		container.get_child(i).gui_input.connect(on_mouse_pressed.bind(container.get_child(i).get_instance_id()))
		
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
		card.gui_input.connect(on_mouse_pressed.bind(card.get_instance_id()))
		container.add_child(card)
		container.move_child(card, insert)
		
func on_mouse_pressed(event: InputEvent, instance_id: int) -> void:
	if event is not InputEventMouseButton:
		return
		
	if event.button_index != MOUSE_BUTTON_LEFT or not event.pressed:
		return
	
	var card = instance_from_id(instance_id)
	print("CARD WAS PRESSED (TYPE): " + card.card_type)
	select_card(instance_id)
	#add_card(card.card_type, -1)
	
func on_deselect(event: InputEvent) -> void:
	if event is not InputEventMouseButton:
		return
		
	if event.button_index != MOUSE_BUTTON_LEFT or not event.pressed:
		return
	
	print("DESELECT CARD")
	select_card(0)
	
func select_card(instance_id: int) -> void:
	if self.selected_card_instance_id != 0:
		var previously_selected = instance_from_id(self.selected_card_instance_id) as Control
		previously_selected.modulate = Color("ffffffff")
	
	self.selected_card_instance_id = instance_id
	
	var selected = instance_from_id(self.selected_card_instance_id)
	if selected:
		selected.modulate = Color("999999ff")
