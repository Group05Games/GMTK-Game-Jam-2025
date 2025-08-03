extends Node

var CaravanInventory : Inventory = Inventory.new()

func _ready():
	CaravanInventory.initInv()

func deposit():
	GlobalSettings.CityInventory.addInventory(CaravanInventory.inventory)
	CaravanInventory.emptyInventory()

func depositAsGold():
	CaravanInventory.convertToGold()
	GlobalSettings.CityInventory.addInventory(CaravanInventory.inventory)
	CaravanInventory.emptyInventory()
