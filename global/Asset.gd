extends Node



var BODIES = [
	load("res://assets/textures/players/body_small_s.png"),
	load("res://assets/textures/players/body_big_s.png")
]

var FACE_SMALL = [
	load("res://assets/textures/players/faces/small_1.png"),
	load("res://assets/textures/players/faces/small_2.png"),
	load("res://assets/textures/players/faces/small_3.png"),
	load("res://assets/textures/players/faces/small_4.png"),
	load("res://assets/textures/players/faces/small_5.png"),
	load("res://assets/textures/players/faces/small_6.png"),
	load("res://assets/textures/players/faces/small_7.png"),
	load("res://assets/textures/players/faces/small_8.png")
]
var FACE_BIG= [
	load("res://assets/textures/players/faces/big_1.png"),
	load("res://assets/textures/players/faces/big_2.png"),
	load("res://assets/textures/players/faces/big_3.png"),
	load("res://assets/textures/players/faces/big_4.png"),
	load("res://assets/textures/players/faces/big_5.png"),
	load("res://assets/textures/players/faces/big_6.png"),
	load("res://assets/textures/players/faces/big_7.png"),
	load("res://assets/textures/players/faces/big_8.png")
]


var HAIR_SMALL = [
	load("res://assets/textures/players/hair/small_1.png"),
	load("res://assets/textures/players/hair/small_2.png"),
	load("res://assets/textures/players/hair/small_3.png"),
	load("res://assets/textures/players/hair/small_4.png"),
	load("res://assets/textures/players/hair/small_5.png"),
	load("res://assets/textures/players/hair/small_6.png"),
	load("res://assets/textures/players/hair/small_7.png"),
	load("res://assets/textures/players/hair/small_8.png"),
	load("res://assets/textures/players/hair/small_9.png"),
	load("res://assets/textures/players/hair/small_10.png"),
	load("res://assets/textures/players/hair/small_11.png"),
	load("res://assets/textures/players/hair/small_12.png"),
	load("res://assets/textures/players/hair/small_13.png")
]
var HAIR_BIG = [
	load("res://assets/textures/players/hair/big_1.png"),
	load("res://assets/textures/players/hair/big_2.png"),
	load("res://assets/textures/players/hair/big_3.png"),
	load("res://assets/textures/players/hair/big_4.png"),
	load("res://assets/textures/players/hair/big_5.png"),
	load("res://assets/textures/players/hair/big_6.png"),
	load("res://assets/textures/players/hair/big_7.png"),
	load("res://assets/textures/players/hair/big_8.png"),
	load("res://assets/textures/players/hair/big_9.png"),
	load("res://assets/textures/players/hair/big_10.png"),
	load("res://assets/textures/players/hair/big_11.png"),
	load("res://assets/textures/players/hair/big_12.png"),
	load("res://assets/textures/players/hair/big_13.png")
]

var CLOTHES_SMALL = [
	load("res://assets/textures/players/clothes/small_1.png"),
	load("res://assets/textures/players/clothes/small_1.png"),
	load("res://assets/textures/players/clothes/small_2.png"),
	load("res://assets/textures/players/clothes/small_2.png"),
	load("res://assets/textures/players/clothes/small_3.png"),
	load("res://assets/textures/players/clothes/small_3.png"),
	load("res://assets/textures/players/clothes/small_3.png"),
	load("res://assets/textures/players/clothes/small_4.png"),
	load("res://assets/textures/players/clothes/small_4.png"),
	load("res://assets/textures/players/clothes/small_5.png"),
	load("res://assets/textures/players/clothes/small_5.png"),
	load("res://assets/textures/players/clothes/small_6.png"),
	load("res://assets/textures/players/clothes/small_6.png"),
	load("res://assets/textures/players/clothes/small_6.png"),
	load("res://assets/textures/players/clothes/small_7.png"),
	load("res://assets/textures/players/clothes/small_7.png"),
	load("res://assets/textures/players/clothes/small_7.png"),
	load("res://assets/textures/players/clothes/small_8.png"),
	load("res://assets/textures/players/clothes/small_8.png"),
	load("res://assets/textures/players/clothes/small_9.png"),
	load("res://assets/textures/players/clothes/small_9.png"),
	load("res://assets/textures/players/clothes/small_9.png"),
	load("res://assets/textures/players/clothes/small_10.png"),
	load("res://assets/textures/players/clothes/small_10.png"),
	load("res://assets/textures/players/clothes/small_11.png"),
	load("res://assets/textures/players/clothes/small_11.png"),
	load("res://assets/textures/players/clothes/small_12.png")
]
var CLOTHES_BIG = [
	load("res://assets/textures/players/clothes/big_1.png"),
	load("res://assets/textures/players/clothes/big_1.png"),
	load("res://assets/textures/players/clothes/big_2.png"),
	load("res://assets/textures/players/clothes/big_2.png"),
	load("res://assets/textures/players/clothes/big_3.png"),
	load("res://assets/textures/players/clothes/big_3.png"),
	load("res://assets/textures/players/clothes/big_3.png"),
	load("res://assets/textures/players/clothes/big_4.png"),
	load("res://assets/textures/players/clothes/big_4.png"),
	load("res://assets/textures/players/clothes/big_5.png"),
	load("res://assets/textures/players/clothes/big_5.png"),
	load("res://assets/textures/players/clothes/big_6.png"),
	load("res://assets/textures/players/clothes/big_6.png"),
	load("res://assets/textures/players/clothes/big_6.png"),
	load("res://assets/textures/players/clothes/big_7.png"),
	load("res://assets/textures/players/clothes/big_7.png"),
	load("res://assets/textures/players/clothes/big_7.png"),
	load("res://assets/textures/players/clothes/big_8.png"),
	load("res://assets/textures/players/clothes/big_8.png"),
	load("res://assets/textures/players/clothes/big_9.png"),
	load("res://assets/textures/players/clothes/big_9.png"),
	load("res://assets/textures/players/clothes/big_9.png"),
	load("res://assets/textures/players/clothes/big_10.png"),
	load("res://assets/textures/players/clothes/big_10.png"),
	load("res://assets/textures/players/clothes/big_11.png"),
	load("res://assets/textures/players/clothes/big_11.png"),
	load("res://assets/textures/players/clothes/big_12.png")
]

var HANDS = [
	load("res://assets/textures/players/hand_1.png"),
	load("res://assets/textures/players/hand_2.png"),
	load("res://assets/textures/players/hand_3.png")
]

var demon_clothes = load("res://assets/textures/players/clothes/demon_clothes.png")
var demon_hair = load("res://assets/textures/players/hair/demon_hair.png")
# is in use
var MASKS = [false, false, false, false, false, false, false, false]

func request_mask(player):
	var mask_num = 0
	for m in MASKS.size():
		if MASKS[m] == false:
			MASKS[m] = true
			mask_num = m
			break
	Global.allMasks[player] = mask_num
	return mask_num

func return_mask(index, player):
	MASKS[index] = false
	Global.allMasks[player] = -1


# const LIGHT_SKIN = [Color8(230,204,174), Color8(231,182,136)]
const LIGHT_SKIN = [Color8(240,198,158), Color8(231,182,136)]
const MED_SKIN = [Color8(217,160,102), Color8(209,150,92)]
const DARK_SKIN = [Color8(102,57,49), Color8(76,46,41)]
const DEMON_SKIN = Color8(24,23,32)
const ALL_SKIN = [LIGHT_SKIN, MED_SKIN, DARK_SKIN, LIGHT_SKIN, MED_SKIN, DARK_SKIN]


const DEMON_COLOUR = [
	[Color8(172,50,50), Color8(144,49,49), Color8(24,23,32)], 
	[Color8(108,51,90), Color8(86,46,74), Color8(24,23,32)],
	[Color8(48,96,130), Color8(44,80,104), Color8(24,23,32)], 
	[Color8(55,148,110), Color8(52,121,92), Color8(24,23,32)], 
	[Color8(214,206,41), Color8(171,165,43), Color8(24,23,32)], 
	[Color8(223,113,38), Color8(198,101,36), Color8(24,23,32)], 
	[Color8(143,86,59), Color8(118,75,55), Color8(24,23,32)],
	[Color8(24,23,32), Color8(24,23,32), Color8(24,23,32)]
]

# White / Grey / Black / Blonde / Ginger / Red Head / Light Brown / Medium Brown / Dark Brown
const HAIR_COLOURS = [
	Color8(240,240,240),
	Color8(148,165,175),
	Color8(18,18,18),
	Color8(255,223,68),
	Color8(222,107,29),
	Color8(147,39,39),
	Color8(147,96,61),
	Color8(93,39,1),
	Color8(57,32,21)
]

enum cc {PRVW, BLUE, GREEN, YELLOW, ORANGE, RED, PURPLE, PINK, BROWN}
# old dark blue [Color8(38,41,73), Color8(24,23,33)]
# old dark green [Color8(7,54,21), Color8(5,35,14)]
const CLOTHES_COLOUR = [
	[Color8(74,84,98), Color8(51,57,65)],
	[Color8(46,79,163), Color8(43,66,125)],
	[Color8(6,101,47), Color8(8,78,37)],
	[Color8(237,167,0), Color8(198,140,6)],
	[Color8(223,113,37), Color8(188,92,36)],
	[Color8(173,51,51), Color8(140,49,49)],
	[Color8(118,66,138), Color8(85,57,96)],
	[Color8(205,106,175), Color8(185,85,155)],
	[Color8(143,86,59), Color8(109,71,54)],
	[Color8(0,0,0), Color8(0,0,0)]
]

const CLOTHES_WHITE = Color8(230,230,230)


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
