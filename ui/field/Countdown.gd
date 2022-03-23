extends Node2D

signal finished
signal started
signal almost_finished

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func send_started():
	emit_signal("started")

func send_finished():
	emit_signal("finished")

func send_almost_finished():
	emit_signal("almost_finished")

func display():
	$Anim.play("display")
	
func start():
	$Anim.play("match_start")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
