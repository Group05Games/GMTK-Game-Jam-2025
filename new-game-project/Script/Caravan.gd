extends Node

var CaravanInventory : Inventory = Inventory.new()

func _ready():
	CaravanInventory.initInv()

func deposit():
	CaravanInventory.convertToGold()
	GlobalSettings.CityInventory.addInventory(CaravanInventory.inventory)
	CaravanInventory.emptyInventory()
