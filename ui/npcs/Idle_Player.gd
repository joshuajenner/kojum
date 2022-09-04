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

enum state {MOVE, ATTACK, HIT, STUN, BLOCK, GRAB, PAUSE}
var isFacingRight = true
export var action = state.MOVE

var player_no = 0
var footstep_type = 0

var speed_max = 120
var speed_min = 55
var speed_current = 55
var speed_action = 0
var already_hit = false
var canRotateHands = false
var speed_reset = 1
export (Vector2) var velocity = Vector2()
export (Vector2) var direction = Vector2()
var deadZoneVelocity = 0.2 
var deadZoneDirection = 0.08
var stun = 0
var stunCurrent = 80
var stunMax = 80
# var team = 0

enum bodies { small, big }
export(bodies) var Body_Type = bodies.small

enum skinz { light, medium, dark }
export(skinz) var Shade = skinz.light

enum faces { main_sm, fem_sm, glasses, scar, closed, fem_lg, main_lg, fold }
export(faces) var Face = faces.main_sm

export (int) var Hair = 0

enum colours { white,grey,black,blonde,orange,red,l_brown,m_brown,d_brown }
export(colours) var Colour = colours.white

export (int) var Clothes = 0

enum handz { blank,white,colour }
export(handz) var Hand = handz.blank

export (int) var Team = 0


enum side { left,right }
export(side) var Facing = side.left

var rng = RandomNumberGenerator.new()

	
func _ready():
	set_customs()
#	device = Global.allControllers[player_no]
#	team = Global.allTeams[player_no]
#	hitBox.team = team
	anim.play("default")
	action = state.PAUSE
	rng.randomize()
	var rand = rng.randf_range(0.1, 1.0)
	$Timer.start(rand)
	if Facing == side.left:
		isFacingRight = false
	else:
		isFacingRight = true
	
#	Input.connect("joy_connection_changed",self,"joy_con_changed")

func _on_Timer_timeout():
	action = state.MOVE


func set_customs():
	$Sprite.texture = Asset.BODIES[Body_Type]
	if Body_Type == bodies.small:
		$Sprite/Clothes.texture = Asset.CLOTHES_SMALL[Clothes]
		$Sprite/Face.texture = Asset.FACE_SMALL[Face]
		$Sprite/Hair.texture = Asset.HAIR_SMALL[Hair]
		$Sprite/Hands/PivotLeft.position.x = 1
	else:
		$Sprite/Clothes.texture = Asset.CLOTHES_BIG[Clothes]
		$Sprite/Face.texture = Asset.FACE_BIG[Face]
		$Sprite/Hair.texture = Asset.HAIR_BIG[Hair]
		$Sprite/Hands/PivotLeft.position.x = 0
		
	$Sprite.material.set_shader_param("NEW1", Asset.ALL_SKIN[Shade][0])
	$Sprite.material.set_shader_param("NEW2", Asset.ALL_SKIN[Shade][1])
	
	# Set clothes colours
	$Sprite/Clothes.material.set_shader_param("NEW1", Asset.CLOTHES_COLOUR[Team][0])
	$Sprite/Clothes.material.set_shader_param("NEW2", Asset.CLOTHES_COLOUR[Team][1])
	$Sprite/Clothes.material.set_shader_param("NEW3", Asset.CLOTHES_WHITE)
	
	# Set hair colour
	$Sprite/Hair.material.set_shader_param("NEW1", Asset.HAIR_COLOURS[Colour])
	$Sprite/Hair.material.set_shader_param("NEW3", Asset.CLOTHES_COLOUR[Team][0])
	
	# Set hands, and colours
	$Sprite/Hands/PivotLeft/Left.texture = Asset.HANDS[Hand]
	$Sprite/Hands/PivotRight/Right.texture = Asset.HANDS[Hand]
	$Sprite/Hands/PivotLeft/Left.material.set_shader_param("NEW3", Asset.CLOTHES_COLOUR[Team][0])
	$Sprite/Hands/PivotRight/Right.material.set_shader_param("NEW3", Asset.CLOTHES_COLOUR[Team][0])
	

func freeze():
	pass
	
func unfreeze():
	pass

func show_crown():
	pass

func get_input():
#	if action == state.MOVE:
#		velocity = Vector2()
#		if device == -1:
#			if Input.is_action_pressed('right'):
#				isFacingRight = true
#				velocity.x += 1
#				direction.x = 1
#				direction.y = 0
#			if Input.is_action_pressed('left'):
#				isFacingRight = false
#				velocity.x -= 1
#				direction.x = -1
#				direction.y = 0
#			if Input.is_action_pressed('down'):
#				velocity.y += 1
#				direction.x = 0
#				direction.y = 1
#			if Input.is_action_pressed('up'):
#				velocity.y -= 1
#				direction.x = 0
#				direction.y = -1
#			if Input.is_action_pressed('right') && Input.is_action_pressed('down'):
#				direction.x = 1
#				direction.y = 1
#			if Input.is_action_pressed('right') && Input.is_action_pressed('up'):
#				direction.x = 1
#				direction.y = -1
#			if Input.is_action_pressed('left') && Input.is_action_pressed('down'):
#				direction.x = -1
#				direction.y = 1
#			if Input.is_action_pressed('left') && Input.is_action_pressed('up'):
#				direction.x = -1
#				direction.y = -1
#		else: 
##			if Input.get_connected_joypads().size() > 0:
#			var xAxis = Input.get_joy_axis(device, JOY_AXIS_0)
#			var yAxis = Input.get_joy_axis(device, JOY_AXIS_1)
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
	
#		if device == -1:
#			# j,k,l
#			if Input.is_key_pressed(74):
#				action = state.ATTACK
#			if Input.is_key_pressed(75):
#				action = state.BLOCK
#				canRotateHands = true
#			if Input.is_key_pressed(76):
#				action = state.GRAB
#				canRotateHands = true
#		else:
#			if Input.is_joy_button_pressed(device, 2):
#				action = state.ATTACK
#			if Input.is_joy_button_pressed(device, 1):
#				action = state.BLOCK
#				canRotateHands = true
#			if Input.is_joy_button_pressed(device, 3):
#				action = state.GRAB
#				canRotateHands = true

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

func isBallRightOfSelf():
	var ball = get_parent().get_node("Ball")
	if ball.global_position.x > global_position.x:
		return true
	else:
		return false

func set_anim():
	arrow.rotation = direction.angle()
	if action != state.STUN:
		stunUI.frame = stun
		
	isFacingRight = isBallRightOfSelf()
	
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
#	get_input()
	handle_state()
	set_velocity(delta)
	set_anim()
	velocity = move_and_slide(velocity)


func _on_HurtBox_area_entered(area):
	pass
	# Make sure my own first doesnt hit me
#	if area.name == "HitBox" && area != hitBox:
	# No friendly fire
#		if area.team != team:
#		if area.hitCheck == 0:
#			if action != state.STUN:
#				action = state.HIT
#				if stun < 3 && !already_hit:
#					already_hit = true
#					stun += 1
#				stunCurrent = stunMax
#				if area.get_parent().global_position.x > self.global_position.x:
#					anim.play("hit_right")
#					direction.x = 1
#				else:
#					anim.play("hit_left")
#					direction.x = -1
	
#	Temp disabling ball bonking, didnt seem good after 1st playtest

#	if area.name == "Ball":
#		if area.speed > area.BONK_SPEED and area.canBonk:
#			if action != state.STUN:
#				action = state.HIT
#				if stun < 3 && !already_hit:
#					already_hit = true
#					stun += 1
#				stunCurrent = stunMax
#				if area.get_parent().global_position.x < self.global_position.x:
#					anim.play("hit_right")
#					direction.x = 1
#				else:
#					anim.play("hit_left")
#					direction.x = -1


func _on_DashCheck_area_entered(area):
	if (area.name == "HurtBox" && area.get_parent().get_node("Sprite") != $Sprite) or area.name == "Ball":
		speed_reset = 0.15


func _on_DashCheck_area_exited(area):
	if (area.name == "HurtBox" && area.get_parent().get_node("Sprite") != $Sprite) or area.name == "Ball":
		speed_reset = 1


func _on_HitBox_hitBlocked():
	pass
#	action = state.HIT
#	if stun < 3:
#		stun += 1
#	if direction.x > 1:
#		anim.play("hit_right")
#	else:
#		anim.play("hit_left")


func checkGrab():
	pass
	

func setWhiteOutlineHands():
	$Sprite.material.set_shader_param("NEW4", Color8(255,255,255))
	$Sprite/Hair.material.set_shader_param("NEW2", Color8(255,255,255))

func setBlackOutlineHands():
	$Sprite.material.set_shader_param("NEW4", Color8(0,0,0))
	$Sprite/Hair.material.set_shader_param("NEW2", Color8(0,0,0))

func hitFlash():
	$Sprite/Hair.material.set_shader_param("NEW1", Color8(255,255,255))
	$Sprite/Hair.material.set_shader_param("NEW3", Color8(255,255,255))
	$Sprite/Clothes.material.set_shader_param("NEW1", Color8(255,255,255))
	$Sprite/Clothes.material.set_shader_param("NEW2", Color8(255,255,255))
	$Sprite/Clothes.material.set_shader_param("NEW3", Color8(255,255,255))
#	$Sprite/Clothes.material.set_shader_param("NEW4", Color8(255,255,255))
	$Sprite.material.set_shader_param("NEW1", Color8(255,255,255))
	$Sprite.material.set_shader_param("NEW2", Color8(255,255,255))
	$Sprite.material.set_shader_param("NEW4", Color8(255,255,255))
	$Sprite/Hands/PivotLeft/Left.material.set_shader_param("NEW3", Color8(255,255,255))
	$Sprite/Hands/PivotRight/Right.material.set_shader_param("NEW3", Color8(255,255,255))


func resetFlash():
	$Sprite/Hair.material.set_shader_param("NEW1", Asset.HAIR_COLOURS[Global.allHairColour[player_no]])
	$Sprite/Hair.material.set_shader_param("NEW3", Asset.CLOTHES_COLOUR[Global.allTeams[player_no]][0])
	$Sprite/Clothes.material.set_shader_param("NEW1", Asset.CLOTHES_COLOUR[Global.allTeams[player_no]][0])
	$Sprite/Clothes.material.set_shader_param("NEW2", Asset.CLOTHES_COLOUR[Global.allTeams[player_no]][1])
	$Sprite/Clothes.material.set_shader_param("NEW3", Asset.CLOTHES_WHITE)
#	$Sprite/Clothes.material.set_shader_param("NEW4", Color8(0,0,0))
	$Sprite.material.set_shader_param("NEW1", Asset.ALL_SKIN[Global.allSkin[player_no]][0])
	$Sprite.material.set_shader_param("NEW2", Asset.ALL_SKIN[Global.allSkin[player_no]][1])
#	$Sprite.material.set_shader_param("NEW4", Color8(0,0,0))
	$Sprite/Hands/PivotLeft/Left.material.set_shader_param("NEW3", Asset.CLOTHES_COLOUR[Global.allTeams[player_no]][0])
	$Sprite/Hands/PivotRight/Right.material.set_shader_param("NEW3", Asset.CLOTHES_COLOUR[Global.allTeams[player_no]][0])




