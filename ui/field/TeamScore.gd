extends Node2D

signal winner_announced

var team = 0
var score = 0

onready var team_icon = $Icon
onready var score_display = $Frame/Score

# Called when the node enters the scene tree for the first time.
func _ready():
	$Anim.play("ready")

func set_team(givenTeam):
	team = givenTeam
	team_icon.texture = Global.TEAM_ICONS[team]

func increase_score(amount):
	score += amount
	score_display.text = str(int(score_display.text) + amount)

func play_win():
	$Anim.play("win")
	emit_signal("winner_announced")

func play_tied():
	$Anim.play("tied")
	emit_signal("winner_announced")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func resume_menu_music():
	MenuMusic.fadein()
