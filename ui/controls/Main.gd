extends Control

signal change_title(new)

var title = "res://ui/title/Title.tscn"

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var sfx = $UIAudio
onready var tab_display = $Tabs
onready var tabs = [$Overall, $Movement, $Strike, $Block, $Grab]
var tab = 0

var device = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	tab = 0
	tabs[0].visible = true
	tabs[1].visible = false
	tabs[2].visible = false
	tabs[3].visible = false
	tabs[4].visible = false
	freeze_all()


func _input(event):
	if event is InputEventJoypadButton:
		device = event.get_device()
	# Shitty fix for xbox controllers sending double inputs and controllers over bluetooth
	if (("Bluetooth" in Input.get_joy_name(device)) or ("Series" in Input.get_joy_name(device))):
		pass
	else:
		if event.is_action_pressed("ui_left"):
			change_tab(-1)
		elif event.is_action_pressed("ui_right"):
			change_tab(1)
	
	if event.is_action_pressed("ui_cancel"):
		MenuSwitcher.switch_menu(title)
		$UIAudio.play_back()


func change_tab(dir):
	var temp = 0
	temp = tab + dir
	if temp < 0:
		temp = 0
	if temp > 4:
		temp = 4
	tab = temp
	for t in range(0,5):
		if t == tab:
			tabs[t].visible = true
		else:
			tabs[t].visible = false
	change_title(tab)
	tab_display.frame = tab
	sfx.play_move()

func freeze_all():
	$Movement/AnimationPlayer.play("reset")
	$Strike/AnimationPlayer.play("stop")
	$Block/AnimationPlayer.play("stop")
	$Grab/AnimationPlayer.play("stop")

func change_title(index):
	match index:
		0:
			emit_signal("change_title", "Controls - How To Play")
			$Movement/AnimationPlayer.play("reset")
		1:
			emit_signal("change_title", "Controls - Movement")
			$Movement/AnimationPlayer.play("move")
			$Strike/AnimationPlayer.play("stop")
		2:
			emit_signal("change_title", "Controls - Strike")
			$Movement/AnimationPlayer.play("reset")
			$Strike/AnimationPlayer.play("strike")
			$Block/AnimationPlayer.play("stop")
		3:
			emit_signal("change_title", "Controls - Block")
			$Strike/AnimationPlayer.play("stop")
			$Block/AnimationPlayer.play("block")
			$Grab/AnimationPlayer.play("stop")
		4:
			emit_signal("change_title", "Controls - Grab")
			$Block/AnimationPlayer.play("stop")
			$Grab/AnimationPlayer.play("grab")


func _on_Left_gui_input(event):
	if event.is_action_pressed("mouse_left_click"):
		change_tab(-1)
		$Arrows.stop()
		$Arrows.play("left_click")
		sfx.play_move()

func _on_Right_gui_input(event):
	if event.is_action_pressed("mouse_left_click"):
		change_tab(1)
		$Arrows.stop()
		$Arrows.play("right_click")
		sfx.play_move()
