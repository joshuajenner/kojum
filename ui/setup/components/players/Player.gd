extends Control

signal player_connected

onready var connect = $Connect
onready var setup = $Setup

onready var p_no = $Setup/Number
onready var body = $Setup/Body
onready var face = $Setup/Face
onready var hair = $Setup/Hair
onready var colour = $Setup/Hair_Colour
onready var clothes = $Setup/Clothes
onready var controls = [body, face, hair, colour, clothes]

onready var prompt = $Connect/Prompt
var kb_or_c = load("res://assets/textures/ui/kb_or_c.png")
var only_c = load("res://assets/textures/ui/only_c.png")

var player_no = 0
var controller = -1
var focus_index = 0
var active = false


func _ready():
	if Global.kb_taken:
		prompt.set_texture(only_c)
	else:
		prompt.set_texture(kb_or_c)
	player_no = 0
	setup.visible = false
	connect.visible = true
	active = false
	set_focus_mode(Control.FOCUS_ALL)
	set_focus_style(body)
	grab_focus()


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


func activate_connecter():
	active = true
	connect.visible = false
	setup.visible = true
	player_no = 1
	p_no.set_text(("P" + str(player_no)))
	emit_signal("player_connected")

func _input(event):
#	if event is InputEventKey and 
	if event.is_action_pressed("ui_accept"):
		# First time
		if player_no == 0:
			if event is InputEventJoypadButton:
				activate_connecter()
			else:
				if !Global.kb_taken:
					Global.kb_taken = true
					activate_connecter()
					
		# Accept input
		elif active:
			active = false
			set_visible(false)
	
	if active:
		if event.is_action_pressed("ui_down"):
			ui_move(1)
		elif event.is_action_pressed("ui_up"):
			ui_move(-1)


func _on_Body_mouse_entered():
	set_focus_style(body)
	focus_index = 0

func _on_Face_mouse_entered():
	set_focus_style(face)
	focus_index = 1

func _on_Hair_mouse_entered():
	set_focus_style(hair)
	focus_index = 2

func _on_Hair_Colour_mouse_entered():
	set_focus_style(colour)
	focus_index = 3

func _on_Clothes_mouse_entered():
	set_focus_style(clothes)
	focus_index = 4
