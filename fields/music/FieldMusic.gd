extends AudioStreamPlayer

export var transition_duration = 1.00
export var transition_type = 1 # TRANS_SINE

var GM_Bus = AudioServer.get_bus_index("Game_Music")
var current_db = AudioServer.get_bus_volume_db(GM_Bus)

func _ready():
	pass
	
func fade_in():
	play()
	$Tween.interpolate_property(self, "volume_db", -80, 0, transition_duration, transition_type, Tween.EASE_IN, 0)
	$Tween.start()

func fade_out():
	$Tween.interpolate_property(self, "volume_db", 0, -80, transition_duration, transition_type, Tween.EASE_IN, 0)
	$Tween.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
