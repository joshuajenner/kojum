extends Node

var MM_Bus = AudioServer.get_bus_index("Menu_Music")
var MS_Bus = AudioServer.get_bus_index("Menu_SFX")
var GM_Bus = AudioServer.get_bus_index("Game_Music")
var GS_Bus = AudioServer.get_bus_index("Game_SFX")

var kb_taken = false
var titleFirstLoad = true

# -2 = None // -1 = KB // 0-7 = Controller
var allControllers = [-2,-2,-2,-2,-2,-2,-2,-2]
var allNames = [["A","A","A"],["A","A","A"],["A","A","A"],["A","A","A"],["A","A","A"],["A","A","A"],["A","A","A"],["A","A","A"]]
var allBodies = [0,0,0,0,0,0,0,0]
var allSkin = [0,0,0,0,0,0,0,0]
var allFaces = [0,0,0,0,0,0,0,0]
var allHair = [0,0,0,0,0,0,0,0]
var allHairColour = [0,0,0,0,0,0,0,0]
var allClothes = [0,0,0,0,0,0,0,0]
var allHands = [0,0,0,0,0,0,0,0]
var allColour = [0,0,0,0,0,0,0,0]
var allTeams = [0,0,0,0,0,0,0,0]
# -1 = No mask
var allMasks = [-1,-1,-1,-1,-1,-1,-1,-1]
var chosenTeams = [0,0]
enum {NO, PAD}

var availBodies = ["SL", "SM", "SD", "BL", "BM", "BD"]
var availSkin = ["L", "M", "D"]
var availFaces = [1,2,3,4,5,6,7,8]
var availHair = [1,2,3,4,5,6,7,8,9,10,11,12,13]
var availHands = [1,2,3]
var availHairColour = [1,2,3,4,5,6,7,8,9]
var availClothes = ["1B", "1W", "2B", "2W", "3B", "3W", "3C", "4B", "4C", "5B", "5C", "6B", "6W", "6C", "7B", "7W", "7C", "8B", "8W", "9B", "9W", "9C", "10B", "10C", "11B", "11C", "12C"]
# var availTeams = ["Dragons", "Monks", "Sun"]

var demonz_found = false

var team_select = [
	[],
	["res://assets/textures/ui/select_flags/dragons.png", "Koboyo Dragons", "Their fiery plays make for a unique spectacle, attracting viewership that has cemented Kojum as the national sport."],
	["res://assets/textures/ui/select_flags/warriors.png", "Kitoshi Fighters", "These wandering warriors enjoy Kojum as light sparring. They claim to be looking for demons, though no one has seen any."],
	["res://assets/textures/ui/select_flags/sun.png", "Miyuki's Community", "Under Miyuki's guidance, these vagabonds have found a fresh start through Kojum, as others do the dawn of a new day."],
	["res://assets/textures/ui/select_flags/monks.png", "Monks of Gaan", "Finding that it trains the mind and body well, these monks have taken up Kojum as another exercise in their lifestyle."],
	["res://assets/textures/ui/select_flags/foxes.png", "Tago Foxes", "The Foxes are a pillar to their community, and are a favourite in dethroning the Dragons. Their rivalry spans generations."],
	["res://assets/textures/ui/select_flags/lotus.png", "Hatana Family", "In order to better connect with the common folk, some members of the ruling class have decided to participate in Kojum."],
	["res://assets/textures/ui/select_flags/geisha.png", "Hosts of Hatana", "Kojum's popularity sees the royal servants taking part. No complaints though, they enjoyed leaving the palace more often."],
	["res://assets/textures/ui/select_flags/wheat.png", "Villagers", "While many associate Kojum with prestige, the youth of the island have turned it into the nation's favourite past time."]
]

var TEAM_ICONS = [
	"",
	load("res://assets/textures/factions/dragons.png"),
	load("res://assets/textures/factions/warriors.png"),
	load("res://assets/textures/factions/sun.png"),
	load("res://assets/textures/factions/monks.png"),
	load("res://assets/textures/factions/foxes.png"),
	load("res://assets/textures/factions/lotus.png"),
	load("res://assets/textures/factions/geisha.png"),
	load("res://assets/textures/factions/wheat.png")
]

# Yellow, Green, Red, Blue
# {PRVW, BLUE, GREEN, YELLOW, ORANGE, RED, PURPLE, PINK, BROWN, BLACK}
# Color8(45,74,149)
var TEAM_FIELD_COLOURS = [
	[Color8(74,84,98), Color8(51,57,65), Color8(39,43,47)],
	[Color8(46,79,163), Color8(43,66,125), Color8(34,44,68)],
	[Color8(6,101,47), Color8(8,78,37), Color8(6,35,18)],
	[Color8(237,167,0), Color8(198,140,6), Color8(153,110,11)],
	[Color8(223,113,37), Color8(188,92,36), Color8(157,85,37)],
	[Color8(173,51,51), Color8(140,49,49), Color8(95,43,43)],
	[Color8(118,66,138), Color8(85,57,96), Color8(54,43,59)],
	[Color8(205,106,175), Color8(185,85,155), Color8(154,76,130)],
	[Color8(143,86,59), Color8(109,71,54), Color8(66,49,41)],
	[Color8(0,0,0), Color8(0,0,0), Color8(0,0,0)]
]


var demonz = ["res://assets/textures/ui/select_flags/oni.png", "????????", "????????????????????????????????"]
var demonz_icon = load("res://assets/textures/factions/oni.png")
var timeDict = OS.get_time()


const allMaps = [
	"res://fields/dojo/Dojo.tscn",
	"res://fields/courtyard/Courtyard.tscn",
	"res://fields/market/Market.tscn",
	"res://fields/temple/Temple.tscn"
]

var config_path = "user://config.cfg"
var config  = ConfigFile.new()
var settings = config.load(config_path)
var audio = "audio"


func _ready():
	#	ProjectSettings.load_resource_pack("user://Kojum.pck")
	
	# If config not found, create config
	if settings != OK:
		config.set_value(audio, "menu_music", 0.1)
		config.set_value(audio, "menu_sfx", 0.5)
		config.set_value(audio, "game_music", 0.1)
		config.set_value(audio, "game_sfx", 0.5)
		config.save("user://config.cfg")
		
	# Apply Settings
	AudioServer.set_bus_volume_db(MM_Bus, linear2db(config.get_value(audio, "menu_music")))
	AudioServer.set_bus_volume_db(MS_Bus, linear2db(config.get_value(audio, "menu_sfx")))
	AudioServer.set_bus_volume_db(GM_Bus, linear2db(config.get_value(audio, "game_music")))
	AudioServer.set_bus_volume_db(GS_Bus, linear2db(config.get_value(audio, "game_sfx")))
	
	# Demonz
	if (timeDict.hour == 4):
		team_select.push_back(demonz)
		TEAM_ICONS.push_back(demonz_icon)
		team_select[2][2] = "These wandering warriors enjoy Kojum as light sparring. They claim to be looking for demons, and have found them!"
		demonz_found = true
#	print(timeDict.hour)

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
