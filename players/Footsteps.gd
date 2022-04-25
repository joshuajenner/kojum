extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


#var rng = RandomNumberGenerator.new()


# dirt = 0, wood = 1, stone = 2
func play():
#	rng.randomize()
#	var random_pitch = get_pitch(randf())
	var type = get_parent().get_parent().footstep_type
	var choice = null
	if type == 0:
		choice = randi()%$Grass.get_child_count()
		$Grass.get_child(choice).play()
	elif type == 1:
		choice = randi()%$Wood.get_child_count()
		$Wood.get_child(choice).play()

#func get_pitch(num):
#	if num != 0:
#		num = num/5

