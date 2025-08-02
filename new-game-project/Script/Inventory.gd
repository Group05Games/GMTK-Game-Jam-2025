extends Resource
class_name Inventory

# signal item_changed(indexes)

var inventory : Dictionary

func _ready():
	initInv()

func initInv():
	for type in GlobalSettings.ResourceType.values():
		inventory.set(type, 0)

func initInvFromArray(values : Array):
	if (!validateArraySizes(GlobalSettings.ResourceType.size(), values.size())):
		return false
	
	for type in GlobalSettings.ResourceType.values():
		inventory.set(type, 0)

func convertToGold():
	var gold : int = 0
	
	for key in inventory:
		gold += inventory[key] * GlobalSettings.ResourceGoldValues[key]
	
	emptyInventory()
	inventory[GlobalSettings.ResourceType.GOLD] = gold

# Provide an Inventory dictionary, every item in the provided inventory will be added to this inventory.
# @param inv -> Inventory
func addInventory(inv : Dictionary):
	for key in inv:
		if (!validateNonNegative(key, inv[key])):
			return false
	
	for key in inv:
		inventory[key] += inv[key]

# Provide an array containing the dictionary keys and a separate array containing the values you wish to modify the key's value by.
# Example assuming enum ResourceType = {WOOD, GOLD} 
# keys[0] = ResourceType.WOOD, counts[0] = 4 will add 4 wood to this inventory and 
# keys[1] = ResourceType.GOLD, counts[1] = -2 will subtract 2 gold.
# @param keys -> Int[] (An array of ResourceTypes matching the dictonary resources you wish to modify.)
# @param counts -> Int[] (An array of integers representing the value you wish to add/remove.)
func addArray(keys : Array[int], counts : Array[int]):
	if (!validateArraySizes(keys.size(), counts.size())):
		return false
	
	for i in keys.size():
		if (!validateNonNegative(keys[i], counts[i])):
			return false
	
	for i in keys.size():
		inventory[keys[i]] += counts[i]

func setItems(keys, counts):
	if (!validateArraySizes(keys.size(), counts.size())):
		return false
	
	for i in keys.size():
		inventory[keys[i]] = counts[i]

func emptyInventory():
	for key in inventory:
		inventory[key] = 0

func validateArraySizes(items : int, counts : int):
	if (items == counts):
		return true
	elif items > counts:
		print("Fewer counts provided than items")
		return false
	else:
		print("Fewer items provided than counts")
		return false

func validateNonNegative(key : int, change : int):
	if inventory[key] + change < 0:
		print("Cannot afford transation. Not enough " + str(GlobalSettings.ResourceType.keys()[key]))
		print("Current " + str(GlobalSettings.ResourceType.keys()[key]) + ": " + str(inventory[key]))
		print("Cost: " + str(change))
		return false
	else:
		return true
