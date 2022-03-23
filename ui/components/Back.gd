extends TextureRect

signal clicked

enum hover {NONE, BACK}
export var mouse = hover.NONE


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Back_mouse_entered():
	$Anim.play("back_hover")

func _on_Back_mouse_exited():
	$Anim.play("back_normal")

func _on_Back_gui_input(event):
	if event.is_action_pressed("mouse_left_click"):
		$Click.play()
		emit_signal("clicked")
