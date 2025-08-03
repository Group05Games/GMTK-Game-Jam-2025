extends Resource
class_name PayBanditsEffect

func apply(tile_ref, em) -> void:
	em.player_money -= 100
