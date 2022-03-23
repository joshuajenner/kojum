extends Node2D


onready var fill = $Fill
var titleScreen = "res://ui/title/Title.tscn"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"



func _ready():
	var _ws = Render.connect("window_resized", self, "on_Window_Resized")
	var _sc = Render.connect("scale_changed", self, "on_Scale_Changed")
	on_Window_Resized(Render.vp.size, Render.currentScale)
	on_Scale_Changed(Render.currentScale)
	$Anim.play("start")
	MenuMusic.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func on_Window_Resized(ws, _sc):
	fill.set_polygon([
		Vector2(0, 0),
		Vector2(ws.x, 0),
		Vector2(ws.x, ws.y),
		Vector2(0, ws.y)
	])
	fill.offset = Vector2((-ws.x/2), (-ws.y/2))
	
	
func on_Scale_Changed(_sc):
	pass
	

func _input(event):
	if event.is_action_pressed("ui_accept"):
		MenuSwitcher.switch_menu(titleScreen)

func switch_to_title():
	MenuSwitcher.switch_menu(titleScreen)
