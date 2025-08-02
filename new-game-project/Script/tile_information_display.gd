extends Control

@onready var map = get_tree().get_first_node_in_group("TileMap")
@onready var spawnContainer: VBoxContainer = $VBoxContainer
@export var pack : PackedScene = preload("res://Prefabs/stats_panel.tscn")
@onready var kill_timer: Timer = $KillTimer

var sender
var tile_ID

var active : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GlobalSignalBusController.SendMapInformation.connect(Callable(self, "GetMapInformation"))
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func GetMapInformation(sender, tile_ID):
	kill_timer.stop()
	self.global_position = get_global_mouse_position()
	if active == true:
		for e in spawnContainer.get_children():
			print(e)
			e.queue_free()
			active = false
	
	await get_tree().create_timer(.1).timeout
	
	active = true
	print("Get Map Info Starting")
	#print("Found Information for " , GlobalSettings.TileDictionary[tile_ID])
	var spawn = pack.instantiate()
	spawnContainer.add_child(spawn)
	spawnContainer.get_child(0).get_child(0).get_child(0).text = str(GlobalSettings.TileDictionary[tile_ID]["Name"])
	
	var spawn2 = pack.instantiate()
	spawnContainer.add_child(spawn2)
	spawnContainer.get_child(1).get_child(0).get_child(0).text = "Move Cost = " + str(GlobalSettings.TileDictionary[tile_ID]["Move Cost"])
	
	var spawn3 = pack.instantiate()
	spawnContainer.add_child(spawn3)
	var index = GlobalSettings.TileDictionary[tile_ID]["Resource"]
	spawnContainer.get_child(2).get_child(0).get_child(0).text = str(GlobalSettings.ResourceType.keys()[index])
	#print("Loop ", e, " done.")
	kill_timer.start()
	print("Kill Timer Started: ", kill_timer.time_left)


func killTimer():
	for e in spawnContainer.get_children():
			print(e)
			e.queue_free()
			active = false
