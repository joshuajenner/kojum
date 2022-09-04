extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var resetTimer = 0
const RESETMAX = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite.modulate = Color(1,1,1,1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var noMovables = true
	for body in get_overlapping_areas():
		if body.name == "HurtBox" or body.name == "Ball":
			noMovables = false
	if noMovables:
		if resetTimer > 0:
			resetTimer -= 1
			if resetTimer == 0:
				$Anim.play("fadein")


func _on_Mid_Stall_Cover_area_entered(area):
	pass

func _on_Mid_Stall_Cover_body_entered(body):
	if body.name == "Player" or body.name == "Ball":
		if resetTimer == 0:
			$Anim.play("fadeout")
		resetTimer = RESETMAX
