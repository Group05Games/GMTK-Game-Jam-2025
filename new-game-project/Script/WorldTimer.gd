extends ProgressBar

@onready var day_tracker: Timer = $DayTracker
@onready var date: RichTextLabel = $"../Date"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	max_value = day_tracker.wait_time


func _physics_process(delta: float) -> void:
	value = (day_tracker.wait_time - day_tracker.time_left)
	#print(value)


func _on_day_tracker_timeout() -> void:
	GlobalSettings.day += 1
	date.text = "Day: %s" % [GlobalSettings.day]
	
	GlobalSettings.CityInventory.inventory[GlobalSettings.ResourceType.GOLD] -= GlobalSettings.UpkeepCost
