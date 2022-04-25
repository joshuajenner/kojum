extends CanvasLayer

var map_select = "res://ui/map_select/MapSelect.tscn"

var player_no = -1
var active = false
var settings_open = false
var stick_just_fired = false
onready var bg = $Fill
onready var ui = $UI
onready var anim = $Anim
onready var resume = $UI/Main/Resume
onready var label = $UI/Main/Label
onready var sfx = $UIAudio

func _ready():
	$UI.visible = false
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


func _physics_process(_delta):
	if active:
		var zone = 0.5
		var xAxis = Input.get_joy_axis(Global.allControllers[player_no], JOY_AXIS_0)
		var yAxis = Input.get_joy_axis(Global.allControllers[player_no], JOY_AXIS_1)
		if !stick_just_fired:
			var ev = InputEventAction.new()
			ev.set_device(Global.allControllers[player_no])
			if xAxis > zone:
				ev.action = "ui_right"
				fire_stick(ev)
			elif xAxis < -zone:
				ev.action = "ui_left"
				fire_stick(ev)
			if yAxis > zone:
				ev.action = "ui_down"
				fire_stick(ev)
			elif yAxis < -zone:
				ev.action = "ui_up"
				fire_stick(ev)

func fire_stick(ev):
	ev.pressed = true
	Input.parse_input_event(ev)
	ev.pressed = false
	Input.parse_input_event(ev)
	stick_just_fired = true
	$EchoStick.start()

func _on_EchoStick_timeout():
	stick_just_fired = false

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
			if settings_open:
				hide_settings()
			else:
				close()	
#	if event.is_action_pressed("ui_left"):
#		print("left")
#	elif event.is_action_pressed("ui_right"):
#		print("right")
#	elif event.is_action_pressed("ui_up"):
#		print("up")
#	elif event.is_action_pressed("ui_down"):
#		print("down")



func open(device):
	layer = 1
	$UI.visible = true
	anim.play("open")
	active = true
	resume.grab_focus()
	set_pause_player(device)
	get_tree().paused = true

func close():
	layer = -1
	$UI.visible = false
	anim.play("close")
	active = false
	get_tree().paused = false

func set_pause_player(device):
	var index = Global.allControllers.find(device)
	var player = Global.allNames[index]
	player_no = index
	label.set_text("Paused by " + player[0] + player[1] + player[2])

func show_settings():
	settings_open = true
	$UI/Main.visible = false
	$UI/Settings.visible = true
	$UI/Settings/SettingsForm/MenuMusic/MM_Slider.grab_focus()
func hide_settings():
	settings_open = false
	$UI/Main.visible = true
	$UI/Settings.visible = false
	$UI/Main/Resume.grab_focus()
	$UI/Settings/SettingsForm.reset_values()
	sfx.play_back()

func _on_Back_clicked():
	hide_settings()

func _on_Resume_button_down():
	close()
	sfx.play_press()

func _on_Quit_button_down():
	sfx.play_back()
	get_tree().paused = false
	MenuSwitcher.switch_menu(map_select)

func _on_Settings_button_down():
	show_settings()



func _on_Resume_mouse_entered():
	$UI/Main/Resume.grab_focus()
func _on_Settings_mouse_entered():
	$UI/Main/Settings.grab_focus()
func _on_Quit_mouse_entered():
	$UI/Main/Quit.grab_focus()

func _on_Settings_focus_entered():
	sfx.play_move()
func _on_Settings_focus_exited():
	sfx.play_move()
