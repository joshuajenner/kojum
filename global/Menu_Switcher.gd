extends CanvasLayer


#signal menu_switched()

onready var anim = $Anim
onready var fill = $Control/Fill

func _ready():
	pass # Replace with function body.


func switch_menu(path):
	anim.play("fade")
	yield(anim, "animation_finished")
	assert(get_tree().change_scene(path) == OK)
	anim.play_backwards("fade")
	
