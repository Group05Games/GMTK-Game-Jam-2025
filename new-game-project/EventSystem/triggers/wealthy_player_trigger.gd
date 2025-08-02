extends Script

func evaluate(tile, caravan):
	return EventManager.player_money >= 300
	# return GlobalSettings.CityInventory.inventory[ResourceType.GOLD] >= 300
