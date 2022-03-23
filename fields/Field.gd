extends Node2D

var player = preload("res://players/Player.tscn")
var map_select = "res://ui/map_select/MapSelect.tscn"

var rng = RandomNumberGenerator.new()
var usedSpawns = []

var teamJustScored = 0
var xBallSpawn
var yBallSpawn
var winner_not_announced = true

export (String) var path

export (Array, Vector2) var team1_spawns
export (Array, Vector2) var team2_spawns

export (Vector2) var team1_ballSpawns_start
export (Vector2) var team1_ballSpawns_end
export (Vector2) var team2_ballSpawns_start
export (Vector2) var team2_ballSpawns_end

const MATCH_TIME = 10
var timerOn = false
var winning_team = null

# Called when the node enters the scene tree for the first time.
func _ready():
	$Clock.text = time_from_seconds(MATCH_TIME)
	$Anim.play("ready")
	set_team_custos()
	select_spawns()
	spawn_Players()
	freeze_Players()
	hide_dummies()
	$Goal/Shape.disabled = false
	$Goal2/Shape.disabled = false
	$Countdown.start()

func set_team_custos():
	$TeamScoreLeft.set_team(Global.chosenTeams[0])
	$TeamScoreRight.set_team(Global.chosenTeams[1])
	
	$Back/FlagsLeft.material.set_shader_param("NEW1", Global.TEAM_FIELD_COLOURS[Global.chosenTeams[0]][0])
	$Back/FlagsLeft.material.set_shader_param("NEW2", Global.TEAM_FIELD_COLOURS[Global.chosenTeams[0]][1])
	$Back/FlagsLeft.material.set_shader_param("NEW3", Global.TEAM_FIELD_COLOURS[Global.chosenTeams[0]][2])
	$Back/FlagsLeft.material.set_shader_param("NEW4", Global.TEAM_FIELD_COLOURS[Global.chosenTeams[0]][3])
	$Over/FlagsBotLeft.material.set_shader_param("NEW1", Global.TEAM_FIELD_COLOURS[Global.chosenTeams[0]][0])
	$Over/FlagsBotLeft.material.set_shader_param("NEW2", Global.TEAM_FIELD_COLOURS[Global.chosenTeams[0]][1])
	$Over/FlagsBotLeft.material.set_shader_param("NEW3", Global.TEAM_FIELD_COLOURS[Global.chosenTeams[0]][2])
	$Over/FlagsBotLeft.material.set_shader_param("NEW4", Global.TEAM_FIELD_COLOURS[Global.chosenTeams[0]][3])
	
	$Back/FlagsRight.material.set_shader_param("NEW1", Global.TEAM_FIELD_COLOURS[Global.chosenTeams[1]][0])
	$Back/FlagsRight.material.set_shader_param("NEW2", Global.TEAM_FIELD_COLOURS[Global.chosenTeams[1]][1])
	$Back/FlagsRight.material.set_shader_param("NEW3", Global.TEAM_FIELD_COLOURS[Global.chosenTeams[1]][2])
	$Back/FlagsRight.material.set_shader_param("NEW4", Global.TEAM_FIELD_COLOURS[Global.chosenTeams[1]][3])
	$Over/FlagsBotRight.material.set_shader_param("NEW1", Global.TEAM_FIELD_COLOURS[Global.chosenTeams[1]][0])
	$Over/FlagsBotRight.material.set_shader_param("NEW2", Global.TEAM_FIELD_COLOURS[Global.chosenTeams[1]][1])
	$Over/FlagsBotRight.material.set_shader_param("NEW3", Global.TEAM_FIELD_COLOURS[Global.chosenTeams[1]][2])
	$Over/FlagsBotRight.material.set_shader_param("NEW4", Global.TEAM_FIELD_COLOURS[Global.chosenTeams[1]][3])


func spawn_Players():
	var team1_spawn_index = 0
	var team2_spawn_index = 0
	var instance
	for p in range(Global.allControllers.size()):
		if  Global.allControllers[p] != -2:
			instance = player.instance()
			instance.player_no = p
			instance.device = Global.allControllers[p]
		
			if Global.allTeams[p] == Global.chosenTeams[0]:
				instance.position = team1_spawns[usedSpawns[team1_spawn_index]]
				instance.isFacingRight = true
				team1_spawn_index += 1
			elif Global.allTeams[p] == Global.chosenTeams[1]:
				instance.position = team2_spawns[usedSpawns[team2_spawn_index]]
				instance.isFacingRight = false
				team2_spawn_index += 1
			
			$YSort.add_child(instance)

func select_spawns():
	rng.randomize()
	var ind
	for n in 8:
		ind = rng.randi_range(0, team1_spawns.size()-1)
		while usedSpawns.has(ind):
			ind = rng.randi_range(0, team1_spawns.size()-1)
		usedSpawns.push_back(ind)

func freeze_Players():
	for entity in $YSort.get_children():
		if "Player" in entity.name:
			entity.freeze()

func free_Players():
	for entity in $YSort.get_children():
		if "Player" in entity.name:
			entity.unfreeze()


func _process(_delta):
	if timerOn:
		$Clock.text = time_from_seconds(int($Timer.get_time_left()))

#func on_Window_Resized(ws, sc):
#	canvas.offset.x = max(0, (ws.x/2 - 512*sc/2))
#
#func on_Scale_Changed(sc):
#	canvas.scale = Vector2(sc, sc)

func time_from_seconds(time):
	var minutes = str(time/60)
	var seconds = str(time%60)
	if minutes.length() < 2:
		minutes = "0" + minutes
	if seconds.length() < 2:
		seconds = "0" + seconds
	return minutes + ":" + seconds

func _on_Goal_area_entered(area):
	if area.name == "Ball" :
		$TeamScoreRight.increase_score(1)
		area.remove()
		$BallSpawn.start(2)
		$"Goal Juice".play_goal()
		teamJustScored = 2


func _on_Goal2_area_entered(area):
	if area.name == "Ball" :
		$TeamScoreLeft.increase_score(1)
		area.remove()
		$BallSpawn.start(2)
		$"Goal Juice2".play_goal()
		teamJustScored = 1

func hide_dummies():
	$YSort/Rematch.hide()
	$YSort/Quit.hide()

func show_dummies():
	$YSort/Rematch.show()
	$YSort/Quit.show()


# Match Finished
func _on_Timer_timeout():
	freeze_Players()
	$Goal/Shape.disabled = true
	$Goal2/Shape.disabled = true
	$Music.fade_out()
	$Whistle.play_end()


func play_ui_win():
	if ($TeamScoreLeft.score > $TeamScoreRight.score):
		winning_team = Global.chosenTeams[0]
		$TeamScoreLeft.play_win()
	elif ($TeamScoreLeft.score < $TeamScoreRight.score):
		winning_team = Global.chosenTeams[1]
		$TeamScoreRight.play_win()
	else: 
		$TeamScoreLeft.play_tied()
		$TeamScoreRight.play_tied()


func _on_Countdown_almost_finished():
#	$Whistle.play_start()
	pass


# Match Started
func _on_Countdown_finished():
	$Timer.start(MATCH_TIME)
	timerOn = true
	free_Players()


func _on_Countdown_started():
	$Music.play()

func _on_BallSpawn_timeout():
	rng.randomize()
	if teamJustScored == 1:
		xBallSpawn = rng.randi_range(team1_ballSpawns_start.x, team1_ballSpawns_end.x)
		yBallSpawn = rng.randi_range(team1_ballSpawns_start.y, team1_ballSpawns_end.y)
	elif teamJustScored == 2:
		xBallSpawn = rng.randi_range(team2_ballSpawns_start.x, team2_ballSpawns_end.x)
		yBallSpawn = rng.randi_range(team2_ballSpawns_start.y, team2_ballSpawns_end.y)
		
	$YSort/Ball.reset(Vector2(xBallSpawn, yBallSpawn))


func _on_Whistle_finished():
	$Anim.play("game_over")

func crown_players():
	if winner_not_announced:
		for entity in $YSort.get_children():
			if "Player" in entity.name:
				if entity.team == winning_team:
					entity.show_crown()
		free_Players()
		show_dummies()
		winner_not_announced = false

func _on_TeamScoreLeft_winner_announced():
	crown_players()

func _on_TeamScoreRight_winner_announced():
	crown_players()


func _on_Rematch_activated():
	MenuSwitcher.restart_scene()
	MenuMusic.fadeout()


func _on_Quit_activated():
	MenuSwitcher.switch_menu(map_select)
