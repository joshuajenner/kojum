extends Node2D


onready var fill = $Fill
onready var canvas = $UICanvas
onready var anim = $Anim
onready var mapDummies = [$YSort/Map1/Label, $YSort/Map2/Label]


var player = preload("res://players/Player.tscn")
var teamSelect = "res://ui/team_select/TeamSelect.tscn"
var selectedMap = 0

var spawns = [
	# Left
	Vector2(-176, 56),
	Vector2(-132, 56),
	Vector2(-88, 56),
	Vector2(-44, 56),
	# Right
	Vector2(176, 56),
	Vector2(132, 56),
	Vector2(88, 56),
	Vector2(44, 56),
]


func _ready():
	Render.connect("window_resized", self, "on_Window_Resized")
	Render.connect("scale_changed", self, "on_Scale_Changed")
	on_Window_Resized(Render.vp.size, Render.currentScale)
	on_Scale_Changed(Render.currentScale)
	
	var instance
	for p in range(Global.allControllers.size()):
		if  Global.allControllers[p] != -2:
			instance = player.instance()
			instance.player_no = p
			instance.device = Global.allControllers[p]
			$YSort.add_child(instance)
			instance.global_position = spawns[p]
	


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
	
	$TopWall.position = Vector2(0, -ws.y/2/sc)
	$BotWall.position = Vector2(0, ws.y/2/sc)
	$LeftWall.position = Vector2(-ws.x/2/sc, 0)
	$RightWall.position = Vector2(ws.x/2/sc, 0)

func on_Scale_Changed(sc):
	canvas.scale = Vector2(sc, sc)


func set_Selected_Map(index):
	selectedMap = index
	for map in range(mapDummies.size()):
		if map == index:
			mapDummies[map].text = "Selected"
		else:
			mapDummies[map].text = ""


func _on_Map1_activated():
	set_Selected_Map(0)

func _on_Map2_activated():
	set_Selected_Map(1)


func _on_Play_activated():
	MenuSwitcher.switch_menu(Global.allMaps[selectedMap])
	MenuMusic.fadeout()


func _on_Cancel_activated():
	MenuSwitcher.switch_menu(teamSelect)

func _on_Back_clicked():
	MenuSwitcher.switch_menu(teamSelect)
