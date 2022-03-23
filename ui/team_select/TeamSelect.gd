extends Node2D

onready var fill = $Fill
onready var canvas = $UICanvas
onready var left = $UICanvas/UI/Left
onready var right = $UICanvas/UI/Right
onready var leftArea = $"Left Box/Left Area"
onready var rightArea = $"Right Box/Right Area"

var player = preload("res://players/Player.tscn")
var setup = "res://ui/setup/Setup.tscn"
var mapSelect = "res://ui/map_select/MapSelect.tscn"
var rng = RandomNumberGenerator.new()
var leftIndex = 0
var rightIndex = 0
var leftReady = false
var rightReady = false


var spawns = [
	# Left
	Vector2(-184, 80),
	Vector2(-150, 32),
	Vector2(-80, 32),
	Vector2(-43, 80),
	# Right
	Vector2(184, 80),
	Vector2(150, 32),
	Vector2(80, 32),
	Vector2(43, 80)
]


# Called when the node enters the scene tree for the first time.
func _ready():
	Render.connect("window_resized", self, "on_Window_Resized")
	Render.connect("scale_changed", self, "on_Scale_Changed")
	on_Window_Resized(Render.vp.size, Render.currentScale)
	on_Scale_Changed(Render.currentScale)
	
	rng.randomize()
	leftIndex = rng.randi_range(1, Global.team_select.size()-1)
	rng.randomize()
	rightIndex = rng.randi_range(1, Global.team_select.size()-1)
	moveIndex(1, 1)
	displayTeam(0, leftIndex)
	displayTeam(1, rightIndex)
	
	Global.chosenTeams[0] = leftIndex
	Global.chosenTeams[1] = rightIndex
	
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
	
#	$TopWall.position = Vector2(0, -ws.y/2/sc)
#	$BotWall.position = Vector2(0, ws.y/2/sc)
#	$LeftWall.position = Vector2(-ws.x/2/sc, 0)
#	$RightWall.position = Vector2(ws.x/2/sc, 0)
	

func on_Scale_Changed(sc):
	canvas.scale = Vector2(sc, sc)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func moveIndex(side, dir):
	var temp
	if side == 0:
		temp = wrapNum(leftIndex + dir)
		if temp == rightIndex:
			temp += dir
		leftIndex = wrapNum(temp)
	elif side == 1:
		temp = wrapNum(rightIndex + dir)
		if temp == leftIndex:
			temp += dir
		rightIndex = wrapNum(temp)


func wrapNum(num):
	if num < 1:
		return Global.team_select.size() - 1
	elif num >= Global.team_select.size():
		return 1
	else:
		return num


func displayTeam(side, index):
	if side == 0:
		$UICanvas/UI/Left/Shadow/Flag.texture = load(Global.team_select[index][0])
		$UICanvas/UI/Left/Title.text = Global.team_select[index][1]
		$UICanvas/UI/Left/Desc.text = Global.team_select[index][2]
	elif side == 1:
		$UICanvas/UI/Right/Shadow/Flag.texture = load(Global.team_select[index][0])
		$UICanvas/UI/Right/Title.text = Global.team_select[index][1]
		$UICanvas/UI/Right/Desc.text = Global.team_select[index][2]


func checkReady():
	if leftReady and rightReady:
		MenuSwitcher.switch_menu(mapSelect)
		pass

func setTeams(side):
	# Left side = 0, Right side = 1
	if side == 0:
		for body in leftArea.get_overlapping_bodies():
			if "Player" in body.name:
				Global.allTeams[body.player_no] = leftIndex
				body.set_customs()
	elif side == 1:
		for body in rightArea.get_overlapping_bodies():
			if "Player" in body.name:
				Global.allTeams[body.player_no] = rightIndex
				body.set_customs()


func _on_Left_Area_body_entered(body):
	if ("Player" in body.name):
		Global.allTeams[body.player_no] = leftIndex
		body.set_customs()
		
func _on_Right_Area_body_entered(body):
	if ("Player" in body.name):
		Global.allTeams[body.player_no] = rightIndex
		body.set_customs()

func _on_DummyCancel_activated():
	MenuSwitcher.switch_menu(setup)


# Left Next Team
func _on_DummyLN_activated():
	moveIndex(0, 1)
	displayTeam(0, leftIndex)
	setTeams(0)
	Global.chosenTeams[0] = leftIndex

# Left Previous Team
func _on_DummyLP_activated():
	moveIndex(0, -1)
	displayTeam(0, leftIndex)
	setTeams(0)
	Global.chosenTeams[0] = leftIndex

# Left Ready Up
func _on_DummyLR_activated():
	leftReady = !leftReady
	if leftReady:
		$YSort/DummyLR/Label.text = "Ready"
	else:
		$YSort/DummyLR/Label.text = "Not Ready"
	checkReady()


# Right Next Team
func _on_DummyRN_activated():
	moveIndex(1, 1)
	displayTeam(1, rightIndex)
	setTeams(1)
	Global.chosenTeams[1] = rightIndex

# Right Previous Team
func _on_DummyRP_activated():
	moveIndex(1, -1)
	displayTeam(1, rightIndex)
	setTeams(1)
	Global.chosenTeams[1] = rightIndex

# Right Ready Up
func _on_DummyRR_activated():
	rightReady = !rightReady
	if rightReady:
		$YSort/DummyRR/Label.text = "Ready"
	else:
		$YSort/DummyRR/Label.text = "Not Ready"
	checkReady()
