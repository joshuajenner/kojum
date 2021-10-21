extends Control


onready var buttons = $Buttons
onready var play = $Buttons/Play
onready var controls = $Buttons/Controls
onready var settings = $Buttons/Settings
onready var quit = $Buttons/Quit
onready var title = $Title
onready var bg = $Background
onready var fill = $Fill
onready var anim = $Anim

onready var press = $Press
onready var move = $Move

var setup = "res://ui/setup/Setup.tscn"


var firstFocus = true


func _ready():
	Render.connect("window_resized", self, "on_Window_Resized")
	Render.connect("scale_changed", self, "on_Scale_Changed")
	on_Scale_Changed(Render.currentScale)
	on_Window_Resized(Render.vp.size, Render.currentScale)
	play.grab_focus()
	anim.play("enter")

func on_Window_Resized(ws, sc):
	title.rect_position.y = ws.y * 0.2
	title.rect_position.x = ws.x / 2 - title.rect_size.x / 2

	buttons.rect_position.x = ws.x / 2
	buttons.rect_position.y = ws.y * 0.55

	bg.rect_position.x = -(bg.rect_size.x*sc/2 - ws.x/2)
	bg.rect_position.y = -(bg.rect_size.y*sc/2 - ws.y/2)

	fill.rect_size.x = ws.x
	fill.rect_size.y = ws.y

func on_Scale_Changed(sc):
	title.rect_size = Vector2(140 * sc, 35 * sc)
	buttons.rect_scale = Vector2(sc, sc)
	title.rect_scale = Vector2(sc, sc)
	bg.rect_scale = Vector2(sc, sc)


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
	anim.play("exit")
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
