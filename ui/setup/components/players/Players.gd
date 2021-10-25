extends Control

var player_connector = load("res://ui/setup/components/players/Player.tscn")


func _ready():
	setup_player_connectors()
	
func setup_player_connectors():
	if Global.players.size() < 8:
		player_connector
		


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
