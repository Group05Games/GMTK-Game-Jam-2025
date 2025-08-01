extends Node

@onready var timer = Timer.new()
var count = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_child(timer)
	timer.start(1)
	timer.connect("timeout", on_global_timer_timeout)


func on_global_timer_timeout():
	count += 1
	print(count)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
