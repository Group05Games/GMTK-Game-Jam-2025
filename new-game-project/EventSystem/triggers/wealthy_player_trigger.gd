extends Resource
class_name WealthyPlayerTrigger

func evaluate(tile_ref, caravan, em) -> bool:
	return em.player_money >= 300
