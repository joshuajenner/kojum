extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var rng = RandomNumberGenerator.new()
var num = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func get_random_child():
	rng.randomize()
	return rng.randi_range(0, (get_child_count()-1))

func play():
	num = get_random_child()
	get_child(num).pitch_scale = 1
	get_child(num).play()

func stop():
	get_child(num).stop()

func play_lower():
	num = get_random_child()
	get_child(num).pitch_scale = 0.7
	get_child(num).play()
	
func play_higher():
	num = get_random_child()
	get_child(num).pitch_scale = 1.3
	get_child(num).play()
