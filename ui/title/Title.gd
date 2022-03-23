extends Node2D


onready var buttons = $UICanvas/Buttons
onready var play = $UICanvas/Buttons/Play
onready var controls = $UICanvas/Buttons/Controls
onready var settings = $UICanvas/Buttons/Settings
onready var quit = $UICanvas/Buttons/Quit
onready var title = $UICanvas/Title
#onready var bg = $Background
onready var fill = $Fill
#onready var anim = $Anim

onready var press = $Press
onready var move = $Move

var setup = "res://ui/setup/Setup.tscn"
var settings_scene = "res://ui/settings/SettingsScene.tscn"


var firstFocus = true


func _ready():
	Render.connect("window_resized", self, "on_Window_Resized")
	Render.connect("scale_changed", self, "on_Scale_Changed")
	on_Scale_Changed(Render.currentScale)
	on_Window_Resized(Render.vp.size, Render.currentScale)
	play.grab_focus()
	$AnimMain.play("enter")
	if Global.titleFirstLoad:
		$AnimBalls.play("ball_anim")
		Global.titleFirstLoad = false
	else:
		$AnimBalls.play("ball_stay")

func ball():
	print($YSort/Ball.position)
	print($YSort/Ball2.position)


func on_Window_Resized(ws, _sc):
	title.rect_position.y = ws.y * 0.2
	title.rect_position.x = ws.x / 2 - title.rect_size.x / 2

	buttons.rect_position.x = ws.x / 2
	buttons.rect_position.y = ws.y * 0.55

#	bg.rect_position.x = -(bg.rect_size.x*sc/2 - ws.x/2)
#	bg.rect_position.y = -(bg.rect_size.y*sc/2 - ws.y/2)

	fill.set_polygon([
		Vector2(0, 0),
		Vector2(ws.x, 0),
		Vector2(ws.x, ws.y),
		Vector2(0, ws.y)
	])
	fill.offset = Vector2((-ws.x/2), (-ws.y/2))

func on_Scale_Changed(sc):
	title.rect_size = Vector2(140 * sc, 35 * sc)
	buttons.rect_scale = Vector2(sc, sc)
	title.rect_scale = Vector2(sc, sc)
#	bg.rect_scale = Vector2(sc, sc)


func _on_Play_mouse_entered():
	play.grab_focus()

func _on_Controls_mouse_entered():
	controls.grab_focus()

func _on_Settings_mouse_entered():
	settings.grab_focus()

func _on_Quit_mouse_entered():
	quit.grab_focus()


func _on_Play_button_down():
	press.play()
	$AnimMain.play("exit")
	MenuSwitcher.switch_menu(setup)


func _on_Play_focus_entered():
	if firstFocus:
		firstFocus = false
	else:
		move.play()
		

func _on_Controls_focus_entered():
	move.play()

func _on_Settings_focus_entered():
	move.play()

func _on_Quit_focus_entered():
	move.play()


func _on_Quit_button_down():
	get_tree().quit()


func _on_Settings_button_down():
	press.play()
	$AnimMain.play("exit")
	MenuSwitcher.switch_menu(settings_scene)
