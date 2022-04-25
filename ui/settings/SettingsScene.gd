extends Node2D

var title = "res://ui/title/Title.tscn"

onready var fill = $Fill
onready var canvas = $UICanvas


func _ready():
	Render.connect("window_resized", self, "on_Window_Resized")
	Render.connect("scale_changed", self, "on_Scale_Changed")
	on_Window_Resized(Render.vp.size, Render.currentScale)
	on_Scale_Changed(Render.currentScale)

func on_Window_Resized(ws, sc):
	canvas.offset.x = max(0, (ws.x/2 - 512*sc/2))
	fill.set_polygon([
		Vector2(0, 0),
		Vector2(ws.x, 0),
		Vector2(ws.x, ws.y),
		Vector2(0, ws.y)
	])
	fill.offset = Vector2((-ws.x/2), (-ws.y/2))

func on_Scale_Changed(sc):
	canvas.scale = Vector2(sc, sc)


func _on_Back_clicked():
	MenuSwitcher.switch_menu(title)
	
func _input(event):
	if event.is_action_pressed("ui_cancel"):
		MenuSwitcher.switch_menu(title)
		$UIAudio.play_back()
