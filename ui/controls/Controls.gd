extends Node2D


onready var fill = $Fill
onready var canvas = $UICanvas
onready var anim = $Anim
onready var title_display = $UICanvas/UI/Title

var title = "res://ui/title/Title.tscn"

func _ready():
	Render.connect("window_resized", self, "on_Window_Resized")
	Render.connect("scale_changed", self, "on_Scale_Changed")
	on_Window_Resized(Render.vp.size, Render.currentScale)
	on_Scale_Changed(Render.currentScale)
	title_display.text = "Controls - How To Play"


func on_Window_Resized(ws, sc):
	canvas.offset.x = max(0, (ws.x/2 - 512*sc/2))
	fill.set_polygon([
		Vector2(0, 0),
		Vector2(ws.x, 0),
		Vector2(ws.x, ws.y),
		Vector2(0, ws.y)
	])
	fill.offset = Vector2((-ws.x/2), (-ws.y/2))
#	if sc >= 4:
#		players.rect_size.x = 436
#	else:
#		players.rect_size.x = 468


func on_Scale_Changed(sc):
	canvas.scale = Vector2(sc, sc)


func _on_Back_clicked():
	MenuSwitcher.switch_menu(title)


func _on_Main_change_title(new):
	title_display.text = new
