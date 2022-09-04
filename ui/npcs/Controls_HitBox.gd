extends Area2D

export var direction = Vector2()
enum hitState {CLEAR, BLOCKED}
export var hitCheck = hitState.CLEAR
var parentPosition = Vector2()
export var justHitBall = false

var team = 0
var control_sync = 0
signal hitBlocked


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	parentPosition = get_parent().global_position

#func updateDirection(dir):
#	direction = dir

func _on_HitBox_area_entered(area):
		if area.name == "BlockBox":
			print(area.control_sync)
			print(control_sync)
			if area.control_sync == control_sync:
				hitCheck = hitState.BLOCKED
				emit_signal("hitBlocked")
