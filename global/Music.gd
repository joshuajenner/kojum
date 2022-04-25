extends Node

onready var player = $MenuMusic

export var transition_duration = 1.00
export var transition_type = 1 # TRANS_SINE

var MM_Bus = AudioServer.get_bus_index("Menu_Music")
var MS_Bus = AudioServer.get_bus_index("Menu_SFX")
var GM_Bus = AudioServer.get_bus_index("Game_Music")
var GS_Bus = AudioServer.get_bus_index("Game_SFX")

# Called when the node enters the scene tree for the first time.
func _ready():
	player.volume_db = -80


func slow_fadein():
	$Anim.play("fade_in_slow")

func fadein():
	play()
	$FadeIn.interpolate_property(player, "volume_db", -80, 0, transition_duration, transition_type, Tween.EASE_IN, 0)
	$FadeIn.start()


func fadeout():
	$FadeOut.interpolate_property(player, "volume_db", 0, -80, transition_duration, transition_type, Tween.EASE_IN, 0)
	$FadeOut.start()

func _on_FadeOut_tween_completed(object, key):
	object.stop()


func play():
	$MenuMusic.play()
	
func stop():
	$MenuMusic.stop()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass






