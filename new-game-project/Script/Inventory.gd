extends Resource
class_name Inventory

# signal item_changed(indexes)

var inventory : Dictionary = {
	"Population" : 0,
	"Gold" : 0,
	"Wood" : 0,
	"Metal" : 0,
	"Food" : 0,
}

# Provide an Inventory dictionary, every item in the provided inventory will be added to this inventory.
# @param inv -> Inventory
func addInventory(inv : Dictionary):
	for key in inv:
		if (!validateNonNegative(key, inv[key])):
			return false
	
	for key in inv:
		inventory[key] += inv[key]

# Provide an array containing the keys and a separate array containing the values you wish to modify the key's value by.
# Example items[0] = "Wood", counts[0] = 4 will add 4 wood to this inventory and 
# items[1] = "Gold", counts[1] = -2 will subtract 2 gold.
# @param items -> Sting[] (An array of strings matching the dictonary names you wish to modify.)
# @param counts -> Int[] (An array of integers representing the value you wish to add/remove.)
func addArray(items : Array[String], counts : Array[int]):
	if (!validateArraySizes(items.size(), counts.size())):
		return false
	
	for i in items.size():
		if (!validateNonNegative(items[i], counts[i])):
			return false
	
	for i in items.size():
		inventory[items[i]] += counts[i]

func setItems(items, counts):
	if (!validateArraySizes(items.size(), counts.size())):
		return false
	
	for i in items.size():
		inventory[items[i]] = counts[i]

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

func validateNonNegative(key : String, change : int):
	if inventory[key] + change < 0:
		print("Cannot afford transation. Not enough " + str(key))
		print("Current " + str(key) + ": " + str(inventory[key]))
		print("Cost: " + str(change))
		return false
	else:
		return true
