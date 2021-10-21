extends Control

onready var body = $Body
onready var skin = $Skin
onready var controls = [body, skin]

var player_no = -1


func _ready():
	set_focus_mode(Control.FOCUS_ALL)
	for c in controls:
		c.set_focus_mode(Control.FOCUS_ALL)
	set_focus_style()
	grab_focus()


func set_focus_style():
	for c in controls:
		if c.has_focus():
			c.get_node("Top_Frame").set_visible(true)
			c.get_node("Bot_Frame").set_visible(true)
			c.modulate = Color(1,1,1,1)
		else:
			c.get_node("Top_Frame").set_visible(false)
			c.get_node("Bot_Frame").set_visible(false)
			c.modulate = Color(1,1,1,0.7)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_Player_gui_input(event):
	print("Player ", event)


func _on_Body_mouse_entered():
	body.grab_focus()
	set_focus_style()


func _on_Skin_mouse_entered():
	skin.grab_focus()
	set_focus_style()






func _on_Body_gui_input(event):
	print("Body ", event)
