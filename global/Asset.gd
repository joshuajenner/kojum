extends Node



var BODIES = [
	load("res://assets/textures/players/body_small.png"),
	load("res://assets/textures/players/body_big.png")
]

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
	load("res://assets/textures/players/hair/small_2.png"),
	load("res://assets/textures/players/hair/small_3.png"),
	load("res://assets/textures/players/hair/small_4.png")
]
var HAIR_BIG = [
	load("res://assets/textures/players/hair/big_1.png"),
	load("res://assets/textures/players/hair/big_2.png"),
	load("res://assets/textures/players/hair/big_3.png"),
	load("res://assets/textures/players/hair/big_4.png")
]

var CLOTHES_SMALL = [
	load("res://assets/textures/players/clothes/small_1.png"),
	load("res://assets/textures/players/clothes/small_1.png"),
	load("res://assets/textures/players/clothes/small_2.png"),
	load("res://assets/textures/players/clothes/small_2.png")
]
var CLOTHES_BIG = [
	load("res://assets/textures/players/clothes/big_1.png"),
	load("res://assets/textures/players/clothes/big_1.png"),
	load("res://assets/textures/players/clothes/big_2.png"),
	load("res://assets/textures/players/clothes/big_2.png")
	
]


var HANDS = [
	load("res://assets/textures/players/hand_1.png"),
	load("res://assets/textures/players/hand_2.png"),
	load("res://assets/textures/players/hand_3.png")
]

const LIGHT_SKIN = [Color8(240,198,158), Color8(231,182,136)]
const MED_SKIN = [Color8(217,160,102), Color8(209,150,92)]
const DARK_SKIN = [Color8(102,57,49), Color8(76,46,41)]
const ALL_SKIN = [LIGHT_SKIN, MED_SKIN, DARK_SKIN, LIGHT_SKIN, MED_SKIN, DARK_SKIN]

enum cc {PRVW, ORANGE}
const CLOTHES_COLOUR = [
	[Color8(74,84,98), Color8(51,57,65)],
	[Color8(223,113,37), Color8(211,105,34)]
]

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
