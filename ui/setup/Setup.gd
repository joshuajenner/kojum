extends Node2D

var title = "res://ui/title/Title.tscn"
var player = "res://players/Player.tscn"

onready var fill = $Fill
onready var players = $UICanvas/UI/Players
onready var canvas = $UICanvas
onready var anim = $Anim

onready var back = $Back


const RESOLUTION = Vector2(512, 288)
var vp
var scaling = 1
var scaling_factor = 1


func _ready():
	Render.connect("window_resized", self, "on_Window_Resized")
	Render.connect("scale_changed", self, "on_Scale_Changed")
	on_Window_Resized(Render.vp.size, Render.currentScale)
	on_Scale_Changed(Render.currentScale)
	anim.play("enter")

func on_Window_Resized(ws, sc):
	canvas.offset.x = max(0, (ws.x/2 - 512*sc/2))
	fill.set_polygon([
		Vector2(0, 0),
		Vector2(ws.x, 0),
		Vector2(ws.x, ws.y),
		Vector2(0, ws.y)
	])
	fill.offset = Vector2((-ws.x/2), (-ws.y/2))
	if sc >= 4:
		players.rect_size.x = 436
	else:
		players.rect_size.x = 468

func on_Scale_Changed(sc):
	canvas.scale = Vector2(sc, sc)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
	

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		MenuSwitcher.switch_menu(title)
		back.play()

