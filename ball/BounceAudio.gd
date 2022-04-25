extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var rng = RandomNumberGenerator.new()
var num = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func speed_to_db(speed):
	if speed < 150:
		var new_db = (speed - 150)/5
		return new_db
	else:
		return 0

func play(speed):
	rng.randomize()
	num = rng.randi_range(0, (get_child_count()-1))
	get_child(num).set_volume_db(speed_to_db(speed))
	get_child(num).play()
	
