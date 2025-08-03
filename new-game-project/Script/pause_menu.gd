extends Control

@export var Main_Menu : PackedScene = preload("res://Scenes/main_menu.tscn")
@onready var pause_menu_container: MarginContainer = $PauseMenuContainer
@onready var sound_menu_container: MarginContainer = $SoundMenuContainer

func _on_main_menu_pressed() -> void:
	GlobalEventBusController.PauseMenu()
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")


func _on_options_pressed() -> void:
	pause_menu_container.visible = false
	sound_menu_container.visible = true


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_resume_pressed() -> void:
	GlobalEventBusController.PauseMenu()


func _on_go_back_pressed() -> void:
	pause_menu_container.visible = true
	sound_menu_container.visible = false
