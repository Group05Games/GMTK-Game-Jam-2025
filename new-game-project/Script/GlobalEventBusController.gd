extends Node

var paused = false
@onready var pause_menu = get_tree().get_first_node_in_group("PauseMenu")

func PauseMenu():
	pause_menu = get_tree().get_first_node_in_group("PauseMenu")
	if paused:
		GlobalSettings.InMenu = false
		pause_menu.pause_menu_container.visible = true
		pause_menu.sound_menu_container.visible = false
		pause_menu.hide()
		Engine.time_scale = 1
	else:
		GlobalSettings.InMenu = true
		pause_menu.show()
		Engine.time_scale = 0
		
	
	paused = !paused
