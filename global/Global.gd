extends Node

#signal player_connected

var kb_taken = false

# -2 = None // -1 = KB // 0-7 = Controller
var allControllers = [-2,-2,-2,-2,-2,-2,-2,-2]
var allBodies = [0,0,0,0,0,0,0,0]
var allSkin = [0,0,0,0,0,0,0,0]
var allFaces = [0,0,0,0,0,0,0,0]
var allHair = [0,0,0,0,0,0,0,0]
var allHairColour = [0,0,0,0,0,0,0,0]
var allClothes = [0,0,0,0,0,0,0,0]
var allHands = [0,0,0,0,0,0,0,0]
var allColour = [0,0,0,0,0,0,0,0]
var allTeams = [0,0,0,0,0,0,0,0]
enum {NO, PAD}

var availBodies = ["SL", "SM", "SD", "BL", "BM", "BD"]
var availSkin = ["L", "M", "D"]
var availFaces = [1,2]
var availHair = [1,2,3,4]
var availHands = [1,2,3]
var availHairColour = [1,2,3,4,5]
var availClothes = ["1B", "1W", "2B", "2W"]
var availTeams = ["Dragons", "Monks", "Sun"]


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Attribute, direction
func customize_attr(player, attr, dir):
	if (attr == "body"):
		allBodies[player] = handle_attribute_change(allBodies[player], dir, availBodies.size())
		set_skin(player, allBodies[player])
		return availBodies[allBodies[player]]
	if (attr == "face"):
		allFaces[player] = handle_attribute_change(allFaces[player], dir, availFaces.size())
		return str(availFaces[allFaces[player]])
	if (attr == "hair"):
		allHair[player] = handle_attribute_change(allHair[player], dir, availHair.size())
		return str(availHair[allHair[player]])
	if (attr == "hair_colour"):
		allHairColour[player] = handle_attribute_change(allHairColour[player], dir, availHairColour.size())
		return str(availHairColour[allHairColour[player]])
	if (attr == "clothes"):
		allClothes[player] = handle_attribute_change(allClothes[player], dir, availClothes.size())
		set_hands(player, allClothes[player])
		return str(availClothes[allClothes[player]])

func set_skin(player, curr):
	var body = availBodies[curr]
	if ("L" in body):
		allSkin[player] = 0
	elif ("M" in body):
		allSkin[player] = 1
	elif ("D" in body):
		allSkin[player] = 2

func set_hands(player, curr):
	var clothes = availClothes[curr]
	if ("B" in clothes):
		allHands[player] = 0
	elif ("W" in clothes):
		allHands[player] = 1
	elif ("C" in clothes):
		allHands[player] = 2

func handle_attribute_change(curr, dir, size):
	if ((curr + dir) >= size):
		return 0
	elif ((curr + dir) <= -1):
		return size-1
	else:
		return curr + dir

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
