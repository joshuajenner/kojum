extends Sprite

# left = 0, right = 1
var direction = 0

func _ready():
	if direction == 1:
		flip_v = false
	else:
		flip_v = true
	$AnimationPlayer.play("fire")

func _on_AnimationPlayer_animation_finished(_anim_name):
	queue_free()
