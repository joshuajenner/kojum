extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func slow_fadein():
	$Anim.play("fade_in_slow")

func fadein():
	$Anim.play("fade_in")
	
func fadeout():
	$Anim.play("fade_out")

func play():
	$MenuMusic.play()
	
func stop():
	$MenuMusic.stop()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
