extends KinematicBody2D

signal debug(speed)

onready var anim = $AnimationPlayer
onready var arrow = $Arrow
onready var rightPivot = $Sprite/Hands/PivotRight
onready var leftPivot = $Sprite/Hands/PivotLeft
onready var hitBox = $Sprite/Hands/PivotRight/HitBox
onready var blockBox = $Sprite/Hands/PivotRight/HitBox
onready var grabBox = $Sprite/Hands/PivotRight/GrabBox
onready var stunUI = $Sprite/Stun

enum state {MOVE, ATTACK, HIT, STUN, BLOCK, GRAB}
var isFacingRight = true
export var action = state.MOVE

var index = -1
var device = -2

export (int) var speed_max = 120
export (int) var speed_min = 55
export (int) var speed_current = 55
export (int) var speed_action = 0
export (bool) var already_hit = false
export (bool) var canRotateHands = false
var speed_reset = 1
var velocity = Vector2()
var direction = Vector2()
var deadZoneVelocity = 0.2 
var deadZoneDirection = 0.08
var stun = 0
var stunCurrent = 80
var stunMax = 80



func _ready():
	anim.play("default")
	direction = Vector2(1, 0)
#	Input.connect("joy_connection_changed",self,"joy_con_changed")


func get_input():
	if action == state.MOVE:
		velocity = Vector2()
		if Input.is_action_pressed('right'):
			isFacingRight = true
			velocity.x += 1
			direction.x = 1
			direction.y = 0
		if Input.is_action_pressed('left'):
			isFacingRight = false
			velocity.x -= 1
			direction.x = -1
			direction.y = 0
		if Input.is_action_pressed('down'):
			velocity.y += 1
			direction.x = 0
			direction.y = 1
		if Input.is_action_pressed('up'):
			velocity.y -= 1
			direction.x = 0
			direction.y = -1
		if Input.is_action_pressed('right') && Input.is_action_pressed('down'):
			direction.x = 1
			direction.y = 1
		if Input.is_action_pressed('right') && Input.is_action_pressed('up'):
			direction.x = 1
			direction.y = -1
		if Input.is_action_pressed('left') && Input.is_action_pressed('down'):
			direction.x = -1
			direction.y = 1
		if Input.is_action_pressed('left') && Input.is_action_pressed('up'):
			direction.x = -1
			direction.y = -1
	
#		if Input.get_connected_joypads().size() > 0:
#			var xAxis = Input.get_joy_axis(0, JOY_AXIS_0)
#			var yAxis = Input.get_joy_axis(0, JOY_AXIS_1)
#			if abs(xAxis) > deadZoneVelocity:
#				if xAxis > 0:
#					isFacingRight = true
#					velocity.x += 1
#				if xAxis < 0:
#					isFacingRight = false
#					velocity.x -= 1
#			if abs(xAxis) > deadZoneDirection:
#				direction.x = xAxis
#			if abs(yAxis) > deadZoneVelocity:
#				if yAxis > 0:
#					velocity.y += 1
#				if yAxis < 0:
#					velocity.y -= 1
#			if abs(yAxis) > deadZoneDirection:
#				direction.y = yAxis
	
		hitBox.direction = direction
	
		if Input.is_action_just_pressed('attack'):
			action = state.ATTACK
	
		if Input.is_action_just_pressed('block'):
			print("Yes")
			action = state.BLOCK
			canRotateHands = true
	
		if Input.is_action_just_pressed('grab'):
			action = state.GRAB
			canRotateHands = true


func handle_state():
	if action == state.ATTACK:
		hitBox.direction = direction
		rightPivot.rotation = direction.angle()
		
	if action == state.GRAB:
		grabBox.direction = direction
		
	if stun == 3:
		action = state.STUN
		stun = 0
	elif stun > 0:
		stunCurrent -= 1
		if stunCurrent <= 0:
			stun -= 1
			stunCurrent = stunMax


func set_velocity(delta):
	if action == state.MOVE:
		speed_current += (speed_current * 0.2)
		velocity = velocity.normalized() * clamp(speed_current, speed_min, speed_max) * delta * 60

	if action == state.ATTACK:
		velocity = direction.normalized() * speed_action * speed_reset * delta * 60
		
	if action == state.HIT:
		velocity = -direction.normalized() * speed_action * delta * 60
	
	if action == state.GRAB:
		velocity = direction.normalized() * speed_action * speed_reset * delta * 60
	
	emit_signal("debug", velocity)


func set_anim():
	arrow.rotation = direction.angle()
	if action != state.STUN:
		stunUI.frame = stun
	
	if direction.x > 0:
		stunUI.flip_h = false
	else:
		stunUI.flip_h = true
	
	if action == state.MOVE:
		if velocity.x != 0 || velocity.y != 0:
			if isFacingRight:
				anim.play("move_right")
			else:
				anim.play("move_left")
		
		if velocity == Vector2(0, 0):
			speed_current = speed_min
			if isFacingRight:
				anim.play("idle_right")
			else: 
				anim.play("idle_left")
	
	if action == state.ATTACK:
		if isFacingRight:
			anim.play("attack_right")
		else: 
			anim.play("attack_left")
	
	if action == state.BLOCK:
		if isFacingRight:
			anim.play("block_right")
		else: 
			anim.play("block_left")
		if canRotateHands:
			leftPivot.rotation = direction.angle()
			rightPivot.rotation = direction.angle()
	
	if action == state.STUN:
		if isFacingRight:
			anim.play("stun_right")
		else: 
			anim.play("stun_left")
	
	if action == state.GRAB:
		if isFacingRight:
			anim.play("grab_right")
		else: 
			anim.play("grab_left")
		if canRotateHands:
			leftPivot.rotation = direction.angle()
			rightPivot.rotation = direction.angle()


#func joy_con_changed(deviceid,isConnected):
#	if isConnected:
#		print("Joystick " + str(deviceid) + " connected")
#	if Input.is_joy_known(0):
#	  print("Recognized and compatible joystick")
#	  print(Input.get_joy_name(0) + " device connected")
#	else:
#		print("Joystick " + str(deviceid) + " disconnected")


func _physics_process(delta):
	get_input()
	handle_state()
	set_velocity(delta)
	set_anim()
	velocity = move_and_slide(velocity)


func _on_HurtBox_area_entered(area):
	if area.name == "HitBox" && area != hitBox:
		if area.hitCheck == 0:
			if action != state.STUN:
				action = state.HIT
				if stun < 3 && !already_hit:
					already_hit = true
					stun += 1
				stunCurrent = stunMax
				if area.get_parent().global_position.x > self.global_position.x:
					anim.play("hit_right")
					direction.x = 1
				else:
					anim.play("hit_left")
					direction.x = -1
	
	if area.name == "Ball":
		if area.speed > area.BONK_SPEED and area.canBonk:
			if action != state.STUN:
				action = state.HIT
				if stun < 3 && !already_hit:
					already_hit = true
					stun += 1
				stunCurrent = stunMax
				if area.get_parent().global_position.x < self.global_position.x:
					anim.play("hit_right")
					direction.x = 1
				else:
					anim.play("hit_left")
					direction.x = -1


func _on_DashCheck_area_entered(area):
	if (area.name == "HurtBox" && area.get_parent().get_node("Sprite") != $Sprite) or area.name == "Ball":
		speed_reset = 0.15


func _on_DashCheck_area_exited(area):
	if (area.name == "HurtBox" && area.get_parent().get_node("Sprite") != $Sprite) or area.name == "Ball":
		speed_reset = 1


func _on_HitBox_hitBlocked():
	action = state.HIT
	if stun < 3:
		stun += 1
	if direction.x > 1:
		anim.play("hit_right")
	else:
		anim.play("hit_left")


func checkGrab():
	pass
