extends StaticBody2D

signal activated

export var label = ""
export var state = 0
enum STATE {IDLE, HIT}


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	state = STATE.IDLE
	$Anim.play("default")
	$Label.text = label
	$Label.rect_size = Vector2(78, 13)


func hide():
	self.modulate = Color( 1, 1, 1, 0)
	$Shape.disabled = true
	$DummyBox/Shape.disabled = true

func show():
	self.modulate = Color( 1, 1, 1, 1)
	$Shape.disabled = false
	$DummyBox/Shape.disabled = false
	

func _process(_delta):
	if state == STATE.IDLE:
		$Anim.play("idle")


func _on_DummyBox_area_entered(area):
	if area.name == "HitBox":
		state = STATE.HIT
		$Anim.play("hit")
		$Hit.play()
		emit_signal("activated", area.player_no)
		


func _on_ClickArea_gui_input(event):
	if event.is_action_pressed("mouse_left_click"):
		state = STATE.HIT
		$Anim.play("hit")
		$Hit.play()
		emit_signal("activated")
