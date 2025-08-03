extends TextureButton
class_name SkillNode

@onready var panel: Panel = $Panel
@onready var upgrade_number: Label = $"MarginContainer/Upgrade Number"
@export var maxLevel : int = 3
@onready var line_2d: Line2D = $Line2D
@export var ID : int
@export var GoldCost : int
@export var image : CompressedTexture2D
@onready var cost: Label = $MarginContainer/Cost
@onready var hover_highlight: Panel = $HoverHighlight
@onready var purchase_high_light: Panel = $PurchaseHighLight


func _ready():
	if get_parent() is SkillNode:
		line_2d.add_point(self.global_position + size/2)
		line_2d.add_point(self.get_parent().global_position + size/2)
		print(line_2d.points)
	upgrade_number.text = str(level) + "/" + str(maxLevel)
	if image != null:
		texture_normal = image
	cost.text = "%sg" % [GoldCost]

var level : int = 0:
	set(value):
		level = value
		upgrade_number.text = str(level) + "/" + str(maxLevel)

func _on_pressed() -> void:
	if GlobalSettings.CityInventory.inventory[GlobalSettings.ResourceType.GOLD] >= GoldCost:
		GlobalSettings.CityInventory.inventory[GlobalSettings.ResourceType.GOLD] -= GoldCost
		level = min(level+1, maxLevel)
		panel.show_behind_parent = true
		
		line_2d.default_color = Color(Color.html('e2e300'))
		purchase_high_light.visible = true
		if ID == 0:
			GlobalSettings.caravanCapacity += 1
		elif ID == 1:
			GlobalSettings.caravanMoveLimit += 5
		else:
			print("Index out of scope")
		var skills = get_children()
		for skill in skills:
			if skill is SkillNode and level == maxLevel:
				skill.disabled = false
	else:
		hover_highlight.scale += Vector2(.3, .3)
		await get_tree().create_timer(1).timeout
		hover_highlight.scale -= Vector2(.3, .3)


func _on_mouse_entered() -> void:
	hover_highlight.visible = !hover_highlight.visible


func _on_mouse_exited() -> void:
	hover_highlight.visible = !hover_highlight.visible
