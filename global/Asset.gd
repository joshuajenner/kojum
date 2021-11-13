extends Node



var FACE_SMALL = [
	load("res://assets/textures/players/faces/big_1.png"),
	load("res://assets/textures/players/faces/big_2.png")
]
var FACE_BIG= [
	load("res://assets/textures/players/faces/big_1.png"),
	load("res://assets/textures/players/faces/big_2.png")
]


var HAIR_SMALL = [
	load("res://assets/textures/players/hair/small_1.png"),
	load("res://assets/textures/players/hair/small_2.png")
]
var HAIR_BIG = [
	load("res://assets/textures/players/hair/big_1.png"),
	load("res://assets/textures/players/hair/big_2.png")
]

var HANDS = [
	load("res://assets/textures/players/hand_1.png"),
	load("res://assets/textures/players/hand_2.png"),
	load("res://assets/textures/players/hand_3.png")
]

const LIGHT_SKIN = [Color8(240,198,158), Color8(231,182,136)]
const MED_SKIN = [Color8(217,160,102), Color8(209,150,92)]
const DARK_SKIN = [Color8(102,57,49), Color8(76,46,41)]

const HAIR_COLOURS = [
	Color8(230,230,230),
	Color8(255,207,64),
	Color8(38,10,0),
	Color8(117,127,134),
	Color8(18,18,18)
]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
