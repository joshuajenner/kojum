extends AudioStreamPlayer


var whistle_1 = preload("res://assets/sfx/ui/whistle/whistle_01v2.wav")
var whistle_2 = preload("res://assets/sfx/ui/whistle/whistle_02.wav")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func play_start():
	self.set_stream(whistle_2)
	self.play()
	
func play_end():
	self.set_stream(whistle_1)
	self.play()
