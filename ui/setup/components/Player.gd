extends Control


onready var body = $Body

# Called when the node enters the scene tree for the first time.
func _ready():
	body.grab_focus()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
