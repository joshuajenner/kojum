extends Control


signal finished_setup

onready var connect = $Connect
onready var tag = $Name
onready var setup = $Setup

onready var p_no = $Name/Number
onready var p_name = $Setup/Name
onready var body = $Setup/Body
onready var face = $Setup/Face
onready var hair = $Setup/Hair
onready var colour = $Setup/Hair_Colour
onready var clothes = $Setup/Clothes
onready var controls = [body, face, hair, colour, clothes]
enum customize {BODY, FACE, HAIR, COLOUR, CLOTHES}

onready var prompt = $Connect/Prompt
var kb_or_c = load("res://assets/textures/ui/kb_or_c.png")
var only_c = load("res://assets/textures/ui/only_c.png")

export(int) var player_no
var focus_index = 0
var active = false
var menu = 0
var selected_letter = 0
var letters_index = [0,0,0]
var letters = ["A", "A", "A"]
onready var display_letters = [$Name/Panel/Letter0, $Name/Panel/Letter1, $Name/Panel/Letter2]

# Preview Assets
var bdy_b = load("res://assets/textures/ui/prvw_body_big.png")
var bdy_s = load("res://assets/textures/ui/prvw_body_small.png")
var l = Asset.LIGHT_SKIN
var m = Asset.MED_SKIN
var d = Asset.DARK_SKIN

var body_tex = [bdy_s, bdy_s, bdy_s, bdy_b, bdy_b, bdy_b]
var skin_col = [l,m,d,l,m,d]
var line_coords = [Vector2(-11,-14), Vector2(-2,-14), Vector2(7,-14)]
var alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"

func _ready():
	setup.visible = false
	connect.visible = true
	tag.visible = false
	active = false
	p_name.set_text(Global.allNames[player_no][0] + Global.allNames[player_no][1] + Global.allNames[player_no][2])
	set_focus_style(body)

func turn_invisible():
	modulate = Color(0,0,0,0)

func turn_visible():
	modulate = Color(1,1,1,1)
	if Global.kb_taken:
		prompt.set_texture(only_c)
	else:
		prompt.set_texture(kb_or_c)

func set_focus_style(node):
	for c in controls:
		if c == node:
			c.get_node("Top_Frame").set_visible(true)
			c.get_node("Bot_Frame").set_visible(true)
			c.get_node("Left").set_visible(true)
			c.get_node("Right").set_visible(true)
			c.modulate = Color(1,1,1,1)
		else:
			c.get_node("Top_Frame").set_visible(false)
			c.get_node("Bot_Frame").set_visible(false)
			c.get_node("Left").set_visible(false)
			c.get_node("Right").set_visible(false)
			c.modulate = Color(1,1,1,0.3)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func ui_move(dir):
	if focus_index + dir >= controls.size():
		focus_index = 0
	elif focus_index + dir <= -1:
		focus_index = controls.size() - 1
	else:
		 focus_index = focus_index + dir
	set_focus_style(controls[focus_index])

func change_value(dir):
	var section = ""
	if (focus_index == customize.BODY):
		section = "body"
	elif (focus_index == customize.FACE):
		section = "face"
	elif (focus_index == customize.HAIR):
		section = "hair"
	elif (focus_index == customize.COLOUR):
		section = "hair_colour"
	elif (focus_index == customize.CLOTHES):
		section = "clothes"
	
	controls[focus_index].get_node("Value").text = Global.customize_attr(player_no, section, dir)
	update_preview()
	
	$AnimLeft.stop(true)
	$AnimRight.stop(true)
	if (dir == 1):
		$AnimRight.play(section)
	elif (dir == -1):
		$AnimLeft.play(section)

func init_options():
	body.get_node("Value").text = Global.availBodies[Global.allBodies[player_no]]
	face.get_node("Value").text = str(Global.availFaces[Global.allFaces[player_no]])
	hair.get_node("Value").text = str(Global.availHair[Global.allHair[player_no]])
	colour.get_node("Value").text = str(Global.availHairColour[Global.allHairColour[player_no]])
	clothes.get_node("Value").text = str(Global.availClothes[Global.allClothes[player_no]])
	$Setup/Sprite/Clothes.material.set_shader_param("NEW1", Asset.CLOTHES_COLOUR[0][0])
	$Setup/Sprite/Clothes.material.set_shader_param("NEW2", Asset.CLOTHES_COLOUR[0][1])

func update_preview():
	$Setup/Sprite/Body.texture = body_tex[Global.allBodies[player_no]]
	$Setup/Sprite/Body.material.set_shader_param("NEW1", skin_col[Global.allSkin[player_no]][0])
	$Setup/Sprite/Body.material.set_shader_param("NEW2", skin_col[Global.allSkin[player_no]][1])
	
	$Setup/Sprite/Left.texture = Asset.HANDS[Global.allHands[player_no]]
	$Setup/Sprite/Left.material.set_shader_param("NEW1", skin_col[Global.allSkin[player_no]][0])
	$Setup/Sprite/Left.material.set_shader_param("NEW2", skin_col[Global.allSkin[player_no]][1])
	$Setup/Sprite/Left.material.set_shader_param("NEW3", Asset.CLOTHES_COLOUR[Global.allTeams[player_no]][0])
	$Setup/Sprite/Right.texture = Asset.HANDS[Global.allHands[player_no]]
	$Setup/Sprite/Right.material.set_shader_param("NEW1", skin_col[Global.allSkin[player_no]][0])
	$Setup/Sprite/Right.material.set_shader_param("NEW2", skin_col[Global.allSkin[player_no]][1])
	$Setup/Sprite/Right.material.set_shader_param("NEW3", Asset.CLOTHES_COLOUR[Global.allTeams[player_no]][0])
	
	if ("S" in Global.availBodies[Global.allBodies[player_no]]):
		$Setup/Sprite/Hair.texture = Asset.HAIR_SMALL[Global.allHair[player_no]]
		$Setup/Sprite/Face.texture = Asset.FACE_SMALL[Global.allFaces[player_no]]
		$Setup/Sprite/Clothes.texture = Asset.CLOTHES_SMALL[Global.allClothes[player_no]]
		$Setup/Sprite/Left.position.x = 12
	elif ("B" in Global.availBodies[Global.allBodies[player_no]]):
		$Setup/Sprite/Hair.texture = Asset.HAIR_BIG[Global.allHair[player_no]]
		$Setup/Sprite/Face.texture = Asset.FACE_BIG[Global.allFaces[player_no]]
		$Setup/Sprite/Clothes.texture = Asset.CLOTHES_BIG[Global.allClothes[player_no]]
		$Setup/Sprite/Left.position.x = 11

	$Setup/Sprite/Hair.material.set_shader_param("NEW1", Asset.HAIR_COLOURS[Global.allHairColour[player_no]])
	$Setup/Sprite/Hair.material.set_shader_param("NEW3", Asset.CLOTHES_COLOUR[0][0])

func connect_to_device(event, device):
	if event.is_action_pressed("ui_cancel"):
		MenuSwitcher.switch_menu("res://ui/title/Title.tscn")
		$Back.play()
	if event.is_action_pressed("ui_accept"):
		if device == -1:
			Global.kb_taken = true
		# IMPORTANT // sets device after connection
		Global.allControllers[player_no] = device
		print(Global.allControllers)
		active = true
		display_name_select()

func display_name_select():
	p_no.set_text(("P" + str(player_no + 1)))
	active = true
	connect.visible = false
	tag.visible = true
	setup.visible = false
	menu = 1
	display_letters[0].text = Global.allNames[player_no][0]
	display_letters[1].text = Global.allNames[player_no][1]
	display_letters[2].text = Global.allNames[player_no][2]
	if Global.allControllers[player_no] == -1:
		$Name/Ready_Img.texture = load("res://assets/textures/ui/press_space_small.png")
	else:
		$Name/Ready_Img.texture = load("res://assets/textures/ui/press_a_small.png")

func select_letter(dir):
	var next_spot = selected_letter + dir
	if next_spot >= 3:
		selected_letter = 0
	elif next_spot <= -1:
		selected_letter = 2
	else:
		selected_letter += dir
	$Name/Panel/Line.rect_position = line_coords[selected_letter]

func change_letter(dir):
	var next_spot = alphabet.findn(display_letters[selected_letter].text) + dir
	if next_spot >= 26:
		display_letters[selected_letter].text = alphabet[0]
	elif next_spot <= -1:
		display_letters[selected_letter].text = alphabet[25]
	else:
		display_letters[selected_letter].text = alphabet[next_spot]
	Global.allNames[player_no][selected_letter] = display_letters[selected_letter].text
	
	$AnimUp.stop(true)
	$AnimDown.stop(true)
	if dir == -1:
		$AnimUp.play("arrow_up_" + str(selected_letter))
	elif dir == 1:
		$AnimDown.play("arrow_down_" + str(selected_letter))

func display_customizers():
	var nameArray = Global.allNames[player_no]
	p_name.set_text(nameArray[0] + nameArray[1] + nameArray[2])
	active = true
	connect.visible = false
	tag.visible = false
	setup.visible = true
	init_options()
	update_preview()
	if Global.allControllers[player_no] == -1:
		$Setup/Ready_Img.texture = load("res://assets/textures/ui/press_space_small.png")
	else:
		$Setup/Ready_Img.texture = load("res://assets/textures/ui/press_a_small.png")

func receive_input(event):
	if menu == 2:
		if event.is_action_pressed("ui_accept"):
			# Accept input
			if active:
				active = false
				modulate = Color(0,0,0,0)
				# Ready up
				emit_signal("finished_setup")
		if active:
			if event.is_action_pressed("ui_down"):
				ui_move(1)
			elif event.is_action_pressed("ui_up"):
				ui_move(-1)
			elif event.is_action_pressed("ui_right"):
				change_value(1)
			elif event.is_action_pressed("ui_left"):
				change_value(-1)
	#		if event.is_action_pressed("ui_cancel"):
	#			MenuSwitcher.switch_menu("res://ui/title/Title.tscn")
	#			$Back.play()
	if menu == 1:
		if event.is_action_pressed("ui_accept"):
			display_customizers()
			menu = 2
		if active:
			if event.is_action_pressed("ui_down"):
				change_letter(1)
			elif event.is_action_pressed("ui_up"):
				change_letter(-1)
			elif event.is_action_pressed("ui_right"):
				select_letter(1)
			elif event.is_action_pressed("ui_left"):
				select_letter(-1)
	


#func _on_Body_mouse_entered():
#	set_focus_style(body)
#	focus_index = 0
#
#func _on_Face_mouse_entered():
#	set_focus_style(face)
#	focus_index = 1
#
#func _on_Hair_mouse_entered():
#	set_focus_style(hair)
#	focus_index = 2
#
#func _on_Hair_Colour_mouse_entered():
#	set_focus_style(colour)
#	focus_index = 3
#
#func _on_Clothes_mouse_entered():
#	set_focus_style(clothes)
#	focus_index = 4
