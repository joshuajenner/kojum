extends Node2D


onready var fill = $Fill
var splashScreen = "res://ui/splash/Splash.tscn"


func _ready():
	var _ws = Render.connect("window_resized", self, "on_Window_Resized")
	on_Window_Resized(Render.vp.size, Render.currentScale)
	$Anim.play("playthrough")


func on_Window_Resized(ws, _sc):
	fill.set_polygon([
		Vector2(0, 0),
		Vector2(ws.x, 0),
		Vector2(ws.x, ws.y),
		Vector2(0, ws.y)
	])
	fill.offset = Vector2((-ws.x/2), (-ws.y/2))


func _input(event):
	if event.is_action_pressed("ui_accept"):
		MenuSwitcher.switch_menu(splashScreen)

func switch_to_splash():
	MenuSwitcher.switch_menu(splashScreen)
