extends Node

@onready var timer = Timer.new()
var count = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_child(timer)
	timer.start(5)
	timer.connect("timeout", on_global_timer_timeout)


# Called every time the global timer times out
func on_global_timer_timeout():
	# Randomly pick a relevant tile
	
	# Randomly pick a number that must match with that tile
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
