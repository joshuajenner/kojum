extends Node2D


onready var score = $Score


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_Goal_area_entered(area):
	if area.name == "Ball" :
		score.get_node('Team2').value += 1
		area.reset()


func _on_Goal2_area_entered(area):
	if area.name == "Ball" :
		score.get_node('Team1').value += 1
		area.reset()
