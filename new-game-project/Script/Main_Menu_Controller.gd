extends Control

@export var Map1 : PackedScene = preload("res://Scenes/Main.tscn")
@onready var MainButtons: MarginContainer = $MarginContainer

@onready var SoundMenu: MarginContainer = $SoundMenuContainer
@onready var Credits: Panel = $Credits

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _on_start_pressed() -> void:
	get_tree().change_scene_to_packed(Map1)


func _on_options_pressed() -> void:
	MainButtons.visible = !MainButtons.visible
	SoundMenu.visible = !SoundMenu.visible


func _on_credits_pressed() -> void:
	Credits.visible = !Credits.visible


func _on_go_back_pressed() -> void:
	MainButtons.visible = !MainButtons.visible
	SoundMenu.visible = !SoundMenu.visible
