extends TextureButton
class_name SkillNode

@onready var panel: Panel = $Panel
@onready var label: Label = $MarginContainer/Label
@export var maxLevel : int = 3
@onready var line_2d: Line2D = $Line2D
@export var ID : int
@export var cost : int


func _ready():
	if get_parent() is SkillNode:
		line_2d.add_point(self.global_position + size/2)
		line_2d.add_point(self.get_parent().global_position + size/2)
		print(line_2d.points)
	label.text = str(level) + "/" + str(maxLevel)

var level : int = 0:
	set(value):
		level = value
		label.text = str(level) + "/" + str(maxLevel)

func _on_pressed() -> void:
	level = min(level+1, maxLevel)
	panel.show_behind_parent = true
	
	line_2d.default_color = Color(Color.html('e2e300'))
	
	var skills = get_children()
	for skill in skills:
		if skill is SkillNode and level == maxLevel:
			skill.disabled = false
