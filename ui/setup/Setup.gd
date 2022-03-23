extends Node2D

var title = "res://ui/title/Title.tscn"
var teams = "res://ui/team_select/TeamSelect.tscn"
var player = preload("res://players/Player.tscn")

onready var fill = $Fill
onready var players = $UICanvas/UI/Players
onready var canvas = $UICanvas
onready var anim = $Anim

func _ready():
	var _w = Render.connect("window_resized", self, "on_Window_Resized")
	var _s = Render.connect("scale_changed", self, "on_Scale_Changed")
	on_Window_Resized(Render.vp.size, Render.currentScale)
	on_Scale_Changed(Render.currentScale)
	hide_dummy()
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
	
	$TopWall.position = Vector2(0, -ws.y/2/sc)
	$BotWall.position = Vector2(0, ws.y/2/sc)
	$LeftWall.position = Vector2(-ws.x/2/sc, 0)
	$RightWall.position = Vector2(ws.x/2/sc, 0)

func on_Scale_Changed(sc):
	canvas.scale = Vector2(sc, sc)

func _on_Players_instance_player(no, coords):
	var instance = player.instance()
	instance.player_no = no
	instance.device = Global.allControllers[no]
	instance.position = coords - (Render.RESOLUTION/2) + Vector2(16,31)
	$YSort.add_child(instance)
	if no == 0:
		show_dummy()
	
func hide_dummy():
	$YSort/Dummy.visible = false
	$YSort/Cancel.visible = false

func show_dummy():
	$YSort/Dummy.visible = true
	$YSort/Cancel.visible = true

func _on_Dummy_activated():
	MenuSwitcher.switch_menu(teams)

func _on_Cancel_activated():
	MenuSwitcher.switch_menu(title)


func _on_Back_clicked():
	MenuSwitcher.switch_menu(title)
