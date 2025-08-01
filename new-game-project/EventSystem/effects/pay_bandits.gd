extends Script

func apply(tile):
	EventManager.player_money -= 100
	print("Paid off the bandits!")
