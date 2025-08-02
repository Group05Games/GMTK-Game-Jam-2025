extends Control

@onready var gold: Label = $Panel/VBoxContainer/Gold
@onready var wheat: Label = $Panel/VBoxContainer/Wheat
@onready var metal: Label = $Panel/VBoxContainer/Metal
@onready var wood: Label = $Panel/VBoxContainer/Wood
@onready var caravan_total: Label = $Panel/VBoxContainer/CaravanTotal

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	gold.text = "Gold " + str(GlobalSettings.CityInventory.inventory[GlobalSettings.ResourceType.GOLD])
	wheat.text = "Wheat " + str(GlobalSettings.CityInventory.inventory[GlobalSettings.ResourceType.WHEAT])
	metal.text = "Metal " + str(GlobalSettings.CityInventory.inventory[GlobalSettings.ResourceType.METAL])
	wood.text = "Wood " + str(GlobalSettings.CityInventory.inventory[GlobalSettings.ResourceType.WOOD])
