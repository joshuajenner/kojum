extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var rng = RandomNumberGenerator.new()
var num = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func play():
	rng.randomize()
	num = rng.randi_range(0, (get_child_count()-1))
	get_child(num).play()
	
