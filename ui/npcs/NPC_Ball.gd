extends Area2D

signal friction(friction)

onready var anim = $AnimationPlayer
onready var center = $Center

const SPEED_MAX = 150
const BONK_SPEED = 60
export (Vector2) var direction = Vector2(0, 0)
export (bool) var friction_decay = false
export (int) var friction = 100
export (int) var speed = 0
var perfect
var canBonk = false
var rng = RandomNumberGenerator.new()

onready var initial_pos = self.position

func _ready():
	$Sprite.texture = load("res://assets/textures/balls/ball_0.png")

#func get_input():
#	if Input.is_action_just_pressed("reset"):
#		reset()
#	if Input.is_action_just_pressed("fire"):
#		fire_random()

#func set_speed(speedGiven):
#	speed = speedGiven

func reset():
	anim.play("spin_none")
	position = initial_pos
	direction = Vector2(0, 0)
	speed = 0

func fire_random():
	direction = Vector2(rand_range(1,-1), rand_range(1,-1)).normalized()
	speed = SPEED_MAX
	friction = 0
	friction_decay = true

func _process(delta):
	if friction_decay == true && friction < 100:
		friction += 2 * delta * 60
	elif friction_decay == true && friction >= 100:
		speed -= speed * 0.02 * delta * 60
	
	position += direction * speed * delta
	
	if speed < 5:
		speed = 0
		friction_decay = false
	
	handle_spin(delta)
#	get_input()
	emit_signal("friction", friction)
#	print(speed, " ", $Sprite.rotation)

# Handle Ball Hit
func _on_Ball_area_entered(area):
	if area.name == "HitBox":
		perfect = (center.global_position - area.get_parent().global_position).normalized()
		perfect = Vector2(perfect.x, perfect.y)
		
		var newDir = area.direction
		var angle = area.direction.angle()
		speed = SPEED_MAX
		friction = 0
		friction_decay = true
			
		if area.direction.dot(perfect) > 0.98:
			direction = newDir.normalized()
		else:
			rng.randomize()
			angle = (angle - rng.randf_range(-0.2, 0.2))
			direction = Vector2(cos(angle), sin(angle))
			
		
		
	if area.name == "BlockBox":
		if speed > 0:
			friction_decay = true
			direction.y = -direction.y
			direction.x = -direction.x
			friction = 100
			speed = 25
		
	if area.name == "HurtBox":
		if speed > BONK_SPEED and canBonk:
			friction_decay = true
			direction.y = -direction.y
			direction.x = -direction.x
			friction = 100
			speed = 25
	
	if area.name == "GrabBox":
		friction_decay = true
		canBonk = false
		direction = -area.direction
		friction = 100
		speed = 125
		

func handle_spin(delta):
	if speed > 5:
		if direction.x >= 0:
			$Sprite.rotate(clamp(speed, 0, 40) * 0.02 * delta * 6)
		elif direction.x < 0:
			$Sprite.rotate(clamp(speed, 0, 40) * -0.02 * delta * 6)
	else:
		$Sprite.rotate(0)

func _on_Top_area_entered(area):
	if area.get("type") == "ballWall":
		direction.y = -direction.y

func _on_Right_area_entered(area):
	if area.get("type") == "ballWall":
		direction.x = -direction.x

func _on_Bottom_area_entered(area):
	if area.get("type") == "ballWall":
		direction.y = -direction.y

func _on_Left_area_entered(area):
	if area.get("type") == "ballWall":
		direction.x = -direction.x


#func _on_Ball_area_exited(area):
#	if area.name == "HurtBox":
#		canBonk = true
