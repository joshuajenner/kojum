extends KinematicBody2D

#signal debug(speed)

var dust_big = load("res://players/Dust_Big.tscn")
var dust_dash = load("res://players/Dust_Dash.tscn")

onready var anim = $AnimationPlayer
onready var arrow = $Arrow
onready var rightPivot = $Sprite/Hands/PivotRight
onready var leftPivot = $Sprite/Hands/PivotLeft
onready var hitBox = $Sprite/Hands/PivotRight/HitBox
onready var blockBox = $Sprite/Hands/PivotRight/Block/BlockBox
onready var grabBox = $Sprite/Hands/PivotRight/GrabBox
onready var hurtBox = $HurtBox
onready var stunUI = $Sprite/Stun
onready var assist_area = $Assist
onready var input_line = $Assist/Input
onready var assisted_line = $Assist/Assisted

onready var sfx_hit = $Audio/Hit
onready var sfx_block = $Audio/Block
onready var sfx_blocked = $Audio/Blocked
onready var sfx_swipe = $Audio/Swipe

enum state {MOVE, ATTACK, HIT, STUN, BLOCK, GRAB, FROZEN, DASH}
export (bool) var isFacingRight = true
export var action = state.MOVE

export var player_no = 0
var device = -2
var team = 0
var footstep_type = 0

export (int) var speed_max = 120
export (int) var speed_min = 55
export (int) var speed_current = 55
export (int) var speed_action = 0
export (bool) var already_hit = false
export (bool) var canRotateHands = false
var speed_reset = 1
var velocity = Vector2()
var raw_direction = Vector2()
var assisted_direction = Vector2()
var deadZoneVelocity = 0.2 
var deadZoneDirection = 0.08
var stun = 0
var stunCurrent = 100
var stunMax = 100

var mask_num = -1
var mask_size = ""


func _ready():
	device = Global.allControllers[player_no]
	team = Global.allTeams[player_no]
	hitBox.team = team
	blockBox.team = team
	grabBox.team = team
	hitBox.player_no = player_no
	mask_num = Global.allMasks[player_no]
	set_customs()
	action = state.MOVE
	anim.play("default")
	assisted_direction = Vector2(0, 0)
#	Input.connect("joy_connection_changed",self,"joy_con_changed")

func set_customs():
	$Name.set_text(Global.allNames[player_no][0] + Global.allNames[player_no][1] + Global.allNames[player_no][2])
	# Set body, clothes, skin, hair, and face
	if ("S" in Global.availBodies[Global.allBodies[player_no]]):
		$Sprite.texture = Asset.BODIES[0]
		$Sprite/Clothes.texture = Asset.CLOTHES_SMALL[Global.allClothes[player_no]]
		$Sprite/Hands/PivotLeft.position.x = 1
		$Sprite/Face.texture = Asset.FACE_SMALL[Global.allFaces[player_no]]
		$Sprite/Hair.texture = Asset.HAIR_SMALL[Global.allHair[player_no]]
		$Crown.frame = 1
		mask_size = "small"
	elif ("B" in Global.availBodies[Global.allBodies[player_no]]):
		$Sprite.texture = Asset.BODIES[1]
		$Sprite/Clothes.texture = Asset.CLOTHES_BIG[Global.allClothes[player_no]]
		$Sprite/Hands/PivotLeft.position.x = 0
		$Sprite/Face.texture = Asset.FACE_BIG[Global.allFaces[player_no]]
		$Sprite/Hair.texture = Asset.HAIR_BIG[Global.allHair[player_no]]
		$Crown.frame = 2
		mask_size = "big"
	
	if team == 9:
		$Sprite.material.set_shader_param("NEW1", Asset.DEMON_SKIN)
		$Sprite.material.set_shader_param("NEW2", Asset.DEMON_SKIN)
		$Sprite/Clothes.texture = Asset.demon_clothes
		$Sprite/Hair.texture = Asset.demon_hair
		$Sprite/Smoke.emitting = true
		$Sprite/Smoke.visible = true
		if mask_num == -1:
			mask_num = Asset.request_mask(player_no)
			$Sprite/Face.texture = load("res://assets/textures/players/faces/demon_" + str(mask_num) + "_" + str(mask_size) + ".png")
			$Sprite/Face.material.set_shader_param("NEW1", Asset.DEMON_COLOUR[mask_num][0])
			$Sprite/Face.material.set_shader_param("NEW2", Asset.DEMON_COLOUR[mask_num][1])
			$Sprite/Face.material.set_shader_param("NEW3", Asset.DEMON_COLOUR[mask_num][2])
		else:
			$Sprite/Face.texture = load("res://assets/textures/players/faces/demon_" + str(mask_num) + "_" + str(mask_size) + ".png")
			$Sprite/Face.material.set_shader_param("NEW1", Asset.DEMON_COLOUR[mask_num][0])
			$Sprite/Face.material.set_shader_param("NEW2", Asset.DEMON_COLOUR[mask_num][1])
			$Sprite/Face.material.set_shader_param("NEW3", Asset.DEMON_COLOUR[mask_num][2])
			
	else:
		$Sprite.material.set_shader_param("NEW1", Asset.ALL_SKIN[Global.allSkin[player_no]][0])
		$Sprite.material.set_shader_param("NEW2", Asset.ALL_SKIN[Global.allSkin[player_no]][1])
		$Sprite/Smoke.emitting = false
		$Sprite/Smoke.visible = false
		if mask_num != -1:
			Asset.return_mask(mask_num, player_no)
			mask_num = -1
	
	# Set clothes colours
	$Sprite/Clothes.material.set_shader_param("NEW1", Asset.CLOTHES_COLOUR[Global.allTeams[player_no]][0])
	$Sprite/Clothes.material.set_shader_param("NEW2", Asset.CLOTHES_COLOUR[Global.allTeams[player_no]][1])
	$Sprite/Clothes.material.set_shader_param("NEW3", Asset.CLOTHES_WHITE)
	
	# Set hair colour
	$Sprite/Hair.material.set_shader_param("NEW1", Asset.HAIR_COLOURS[Global.allHairColour[player_no]])
	$Sprite/Hair.material.set_shader_param("NEW3", Asset.CLOTHES_COLOUR[Global.allTeams[player_no]][0])
	
	# Set hands, and colours
	$Sprite/Hands/PivotLeft/Left.texture = Asset.HANDS[Global.allHands[player_no]]
	$Sprite/Hands/PivotRight/Right.texture = Asset.HANDS[Global.allHands[player_no]]
	$Sprite/Hands/PivotLeft/Left.material.set_shader_param("NEW3", Asset.CLOTHES_COLOUR[Global.allTeams[player_no]][0])
	$Sprite/Hands/PivotRight/Right.material.set_shader_param("NEW3", Asset.CLOTHES_COLOUR[Global.allTeams[player_no]][0])

func get_input():
	if action == state.MOVE:
		velocity = Vector2(0,0)
		if device == -1:
			if Input.is_action_pressed('right'):
				isFacingRight = true
				velocity.x = 1
				raw_direction.x = 1
				raw_direction.y = 0
			if Input.is_action_pressed('left'):
				isFacingRight = false
				velocity.x = 1
				raw_direction.x = -1
				raw_direction.y = 0
			if Input.is_action_pressed('down'):
				velocity.y += 1
				raw_direction.x = 0
				raw_direction.y = 1
			if Input.is_action_pressed('up'):
				velocity.y += 1
				raw_direction.x = 0
				raw_direction.y = -1
			if Input.is_action_pressed('right') && Input.is_action_pressed('down'):
				raw_direction.x = 1
				raw_direction.y = 1
			if Input.is_action_pressed('right') && Input.is_action_pressed('up'):
				raw_direction.x = 1
				raw_direction.y = -1
			if Input.is_action_pressed('left') && Input.is_action_pressed('down'):
				raw_direction.x = -1
				raw_direction.y = 1
			if Input.is_action_pressed('left') && Input.is_action_pressed('up'):
				raw_direction.x = -1
				raw_direction.y = -1
		else: 
#			if Input.get_connected_joypads().size() > 0:
			var xAxis = Input.get_joy_axis(device, JOY_AXIS_0)
			var yAxis = Input.get_joy_axis(device, JOY_AXIS_1)
			
			if abs(xAxis) > deadZoneVelocity or abs(yAxis) > deadZoneVelocity:
				if xAxis > 0:
					isFacingRight = true
					velocity.x = 1
				elif xAxis < 0:
					isFacingRight = false
					velocity.x = 1
				if abs(xAxis) > deadZoneDirection:
					raw_direction.x = xAxis
				else:
					raw_direction.x = 0
				if yAxis > 0:
					velocity.y = 1
				if yAxis < 0:
					velocity.y = 1
				if abs(yAxis) > deadZoneDirection:
					raw_direction.y = yAxis
				else:
					raw_direction.y = 0
			
#			if abs(xAxis) > deadZoneVelocity:
#				if xAxis > 0:
#					isFacingRight = true
#					velocity.x = 1
#				if xAxis < 0:
#					isFacingRight = false
#					velocity.x = 1
#			if abs(xAxis) > deadZoneDirection:
#				raw_direction.x = xAxis
#			else:
#				raw_direction.x = 0
#			if abs(yAxis) > deadZoneVelocity:
#				if yAxis > 0:
#					velocity.y = 1
#				if yAxis < 0:
#					velocity.y = 1
#			if abs(yAxis) > deadZoneDirection:
#				raw_direction.y = yAxis
#			else:
#				raw_direction.y = 0
		
		if device == -1:
			# j,k,l
			if Input.is_key_pressed(74):
				action = state.ATTACK
			if Input.is_key_pressed(75):
				action = state.BLOCK
				canRotateHands = true
			if Input.is_key_pressed(76):
				action = state.GRAB
				canRotateHands = true
			if Input.is_key_pressed(77):
				if stun < 2:
					action = state.DASH
					stun += 1
					stunCurrent = stunMax
		else:
			if Input.is_joy_button_pressed(device, 2):
				action = state.ATTACK
			if Input.is_joy_button_pressed(device, 1):
				action = state.BLOCK
				canRotateHands = true
			if Input.is_joy_button_pressed(device, 3):
				action = state.GRAB
				canRotateHands = true
			if Input.is_joy_button_pressed(device, 0):
				if stun < 2:
					action = state.DASH
					stun += 1
					stunCurrent = stunMax


func set_assist():
	var targets = assist_area.get_overlapping_areas()
	var check_vector = null
	var aim_target = null
	var target_vector = null
#	var target_type = "none"
	var difference = 0
	var check_difference = 0
	var prev_difference = null
	var THRESH = 0.85
	var assist_amount = 0
	var assist_multiplier = 1.4
	
	for target in targets:
		if target != hurtBox:
			check_vector = null
			if target.name == "DummyBox" or target.name == "HurtBox":
				check_vector = target.global_position - hurtBox.global_position
			elif  target.name == "Ball" and target.inPlay:
				check_vector = target.center.global_position - hurtBox.global_position
			if check_vector != null:
				check_difference = raw_direction.normalized().dot(check_vector.normalized())
				if check_difference > THRESH:
					if prev_difference == null or difference > prev_difference:
						aim_target = target
						if target.name == "DummyBox" or target.name == "HurtBox":
							target_vector = target.global_position - hurtBox.global_position
						elif  target.name == "Ball":
							target_vector = target.center.global_position - hurtBox.global_position
						difference = raw_direction.normalized().dot(target_vector.normalized())
						prev_difference = difference
	
	if aim_target != null:
		$Assist/Target.visible = true
		$Assist/Target.rotation = target_vector.angle()
		assist_amount = clamp(((1-(((1/difference)-1)*10)) * assist_multiplier), 0, 1)
		assisted_direction = raw_direction.rotated(raw_direction.angle_to(target_vector)*assist_amount)
		$Assist/Assisted.rotation = assisted_direction.angle()
	else:
		$Assist/Target.visible = false
		assisted_direction = raw_direction
		$Assist/Assisted.rotation = assisted_direction.angle()
		
#		if target.name == "Ball":
#			aim_target = target
#			target_type = "Ball"
#		if aim_target == null and target.name == "HurtBox" and target != hurtBox:
#			aim_target = target
#			target_type = "Player"
#	if not aim_target == null:
#		if target_type == "Player":
#			target_vector = aim_target.global_position - hurtBox.global_position
#		elif target_type == "Ball":
#			target_vector = aim_target.center.global_position - hurtBox.global_position
#
#		difference = raw_direction.normalized().dot(target_vector.normalized())
#		if difference > THRESH:
#			$Assist/Target.visible = true
#			$Assist/Target.rotation = target_vector.angle()
#			assisted_direction = raw_direction.rotated(raw_direction.angle_to(target_vector)/ASSIST_AMOUNT)
#			$Assist/Assisted.rotation = assisted_direction.angle()
#		else:
#			$Assist/Target.visible = false
#			assisted_direction = raw_direction

func handle_state():
	if action == state.ATTACK:
		hitBox.direction = assisted_direction
		rightPivot.rotation = assisted_direction.angle()
		
	if action == state.GRAB:
		grabBox.direction = assisted_direction
		
	if action == state.BLOCK:
		blockBox.direction = assisted_direction
		
	if stun == 3:
		action = state.STUN
		stun = 0
	elif stun > 0:
		stunCurrent -= 1
		if stunCurrent <= 0:
			stun -= 1
			stunCurrent = stunMax
	# Debug
	input_line.rotation = assisted_direction.angle()

func set_velocity(delta):
	if action == state.MOVE:
		speed_current += (speed_current * 0.2)
		velocity = assisted_direction.normalized() * velocity * clamp(speed_current, speed_min, speed_max) * delta * 60
		
	if action == state.ATTACK:
		velocity = assisted_direction.normalized() * speed_action * speed_reset * delta * 60
		
	if action == state.HIT:
		velocity = -assisted_direction.normalized() * speed_action * delta * 60
		
	if action == state.STUN:
		velocity = -assisted_direction.normalized() * speed_action * delta * 60
		
	if action == state.DASH:
		velocity = assisted_direction.normalized() * speed_action * delta * 60
		
	if action == state.GRAB:
		velocity = assisted_direction.normalized() * speed_action * speed_reset * delta * 60
		
	if action == state.FROZEN:
		speed_current = 0
		velocity = Vector2(0,0)
#	emit_signal("debug", velocity)

func set_anim():
	$Assist/Input.rotation = raw_direction.angle()
	arrow.rotation = raw_direction.angle()
	if action != state.STUN:
		stunUI.frame = stun
		
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
			leftPivot.rotation = assisted_direction.angle()
			rightPivot.rotation = assisted_direction.angle()
	
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
			leftPivot.rotation = assisted_direction.angle()
			rightPivot.rotation = assisted_direction.angle()
	
	if action == state.DASH:
		if isFacingRight:
			anim.play("dash_right")
		else: 
			anim.play("dash_left")
	
	if action == state.FROZEN:
		speed_current = speed_min
		if isFacingRight:
			anim.play("idle_right")
		else: 
			anim.play("idle_left")

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
	set_assist()
	handle_state()
	set_velocity(delta)
	set_anim()
	velocity = move_and_slide(velocity)

func freeze():
	action = state.FROZEN

func unfreeze():
	action = state.MOVE

func _on_HurtBox_area_entered(area):
	# Make sure my own fist doesnt hit me
	if area.name == "HitBox" && area != hitBox:
	# No friendly fire
		if area.team != team:
			if action != state.BLOCK:
				if area.hitCheck == 0:
					if action != state.STUN:
						action = state.HIT
						if stun < 3 && !already_hit:
							already_hit = true
							stun += 1
						stunCurrent = stunMax
						if area.get_parent().global_position.x > self.global_position.x:
							anim.play("hit_right")
						else:
							anim.play("hit_left")
						raw_direction = -area.direction
						sfx_hit.play()

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
	if (area.name == "HurtBox" && area.get_parent().get_node("Sprite") != $Sprite) or area.name == "Ball" or area.name == "DummyBox":
		speed_reset = 0.15


func _on_DashCheck_area_exited(area):
	if (area.name == "HurtBox" && area.get_parent().get_node("Sprite") != $Sprite) or area.name == "Ball" or area.name == "DummyBox":
		speed_reset = 1


func _on_HitBox_hitBlocked():
	# Strike is blocked
	action = state.HIT
	if stun < 3:
		stun += 1
	if assisted_direction.x > 1:
		anim.play("hit_right")
	else:
		anim.play("hit_left")
	sfx_blocked.play()

func _on_BlockBox_area_entered(area):
	# If Block gets Grabbed
	if action == state.BLOCK:
		if area.name == "GrabBox":
			if area.team != team:
				action = state.HIT
				if stun < 3:
					stun += 1
				if assisted_direction.x > 1:
					anim.play("hit_right")
				else:
					anim.play("hit_left")
				$Audio/Block_Broken.play()
				sfx_block.stop()


func spawn_dust(dir):
	var d = dust_big.instance()
	d.position = $Dust.global_position
	d.direction = dir
	d.rotation_degrees = rad2deg(assisted_direction.angle())
	get_parent().add_child(d)

func spawn_dust_dash(dir):
	var d = dust_dash.instance()
	d.position = $Dust.global_position
	d.direction = dir
	d.rotation_degrees = rad2deg(assisted_direction.angle())
	get_parent().add_child(d)

func show_crown():
	$AnimationPlayerCrown.play("show_crown")

func setWhiteOutlineHands():
	$Sprite.material.set_shader_param("NEW4", Color8(255,255,255))
	$Sprite/Hair.material.set_shader_param("NEW2", Color8(255,255,255))
	$Sprite/Face.material.set_shader_param("NEW4", Color8(255,255,255))

func setBlackOutlineHands():
	$Sprite.material.set_shader_param("NEW4", Color8(0,0,0))
	$Sprite/Hair.material.set_shader_param("NEW2", Color8(0,0,0))
	$Sprite/Face.material.set_shader_param("NEW4", Color8(0,0,0))

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
	if team == 9:
		$Sprite/Face.material.set_shader_param("NEW1", Color8(255,255,255))
		$Sprite/Face.material.set_shader_param("NEW2", Color8(255,255,255))
		$Sprite/Face.material.set_shader_param("NEW3", Color8(255,255,255))
		$Sprite/Face.material.set_shader_param("NEW4", Color8(255,255,255))
		
	


func resetFlash():
	$Sprite/Hair.material.set_shader_param("NEW1", Asset.HAIR_COLOURS[Global.allHairColour[player_no]])
	$Sprite/Hair.material.set_shader_param("NEW3", Asset.CLOTHES_COLOUR[Global.allTeams[player_no]][0])
	$Sprite/Clothes.material.set_shader_param("NEW1", Asset.CLOTHES_COLOUR[Global.allTeams[player_no]][0])
	$Sprite/Clothes.material.set_shader_param("NEW2", Asset.CLOTHES_COLOUR[Global.allTeams[player_no]][1])
	$Sprite/Clothes.material.set_shader_param("NEW3", Asset.CLOTHES_WHITE)
#	$Sprite/Clothes.material.set_shader_param("NEW4", Color8(0,0,0))
	if team == 9:
		$Sprite.material.set_shader_param("NEW1", Asset.DEMON_SKIN)
		$Sprite.material.set_shader_param("NEW2", Asset.DEMON_SKIN)
		$Sprite/Face.material.set_shader_param("NEW1", Asset.DEMON_COLOUR[mask_num][0])
		$Sprite/Face.material.set_shader_param("NEW2", Asset.DEMON_COLOUR[mask_num][1])
		$Sprite/Face.material.set_shader_param("NEW3", Asset.DEMON_COLOUR[mask_num][2])
	else:
		$Sprite.material.set_shader_param("NEW1", Asset.ALL_SKIN[Global.allSkin[player_no]][0])
		$Sprite.material.set_shader_param("NEW2", Asset.ALL_SKIN[Global.allSkin[player_no]][1])
#	$Sprite.material.set_shader_param("NEW4", Color8(0,0,0))
	$Sprite/Hands/PivotLeft/Left.material.set_shader_param("NEW3", Asset.CLOTHES_COLOUR[Global.allTeams[player_no]][0])
	$Sprite/Hands/PivotRight/Right.material.set_shader_param("NEW3", Asset.CLOTHES_COLOUR[Global.allTeams[player_no]][0])
