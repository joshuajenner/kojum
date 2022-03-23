extends CanvasLayer

var map_select = "res://ui/map_select/MapSelect.tscn"

var active = false
onready var bg = $Fill
onready var ui = $UI
onready var anim = $Anim
onready var resume = $UI/Resume
onready var label = $UI/Label


func _ready():
	anim.play("close")
	Render.connect("window_resized", self, "on_Window_Resized")
	Render.connect("scale_changed", self, "on_Scale_Changed")
	on_Scale_Changed(Render.currentScale)
	on_Window_Resized(Render.vp.size, Render.currentScale)



func on_Window_Resized(ws, sc):
	ui.rect_position = ws/2 / sc
	
	bg.rect_position.x = -(bg.rect_size.x*sc/2 - ws.x/2)
	bg.rect_position.y = -(bg.rect_size.y*sc/2 - ws.y/2)
	bg.rect_size = Vector2(ws.x + 4, ws.y + 4)

func on_Scale_Changed(sc):
	scale = Vector2(sc, sc)



func _input(event):
	# For some reason I was getting 0 when using the keyboard which should be -1
	# This ensures that that the kb is always recognized as -1
	if event.is_action_pressed("kb_cancel", false):
		if active:
			close()
		else:
			open(-1)
	elif event.is_action_pressed("ui_option", false):
		if active:
			close()
		else:
			open(event.device)
	elif event.is_action_pressed("ui_cancel", false):
		if active:
			close()



func open(device):
	anim.play("open")
	active = true
	resume.grab_focus()
	set_pause_player(device)
	get_tree().paused = true

func close():
	anim.play("close")
	active = false
	get_tree().paused = false

func set_pause_player(device):
	var index = Global.allControllers.find(device)
	var player = Global.allNames[index]
	label.set_text("Paused by " + player[0] + player[1] + player[2])



func _on_Resume_button_down():
	close()

func _on_Quit_button_down():
	get_tree().paused = false
	MenuSwitcher.switch_menu(map_select)
