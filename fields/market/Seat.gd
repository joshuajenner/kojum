extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var broken = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$Anim.play("ready")


func _on_Seat_area_entered(area):
	if area.name == "Ball" or area.name == "HitBox":
		if not broken:
			broken = true
			if area.global_position.x > global_position.x:
				$Anim.play("break_left")
			else:
				$Anim.play("break_right")
			$BreakSFX.play()
