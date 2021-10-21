extends CanvasLayer


#signal menu_switched()

onready var control = $Control
onready var anim = $Anim
onready var fill = $Control/Fill

func _ready():
	layer = -1


func switch_menu(path):
	layer = 10
	anim.play("fade")
	yield(anim, "animation_finished")
	assert(get_tree().change_scene(path) == OK)
	anim.play_backwards("fade")
	layer = -1
	
