extends AudioStreamPlayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	self.volume_db = -60

func fade_out():
	$Anim.play("fade_out")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
