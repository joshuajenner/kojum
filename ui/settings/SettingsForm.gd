extends Control

onready var sfx = $UIAudio

var config_path = "user://config.cfg"
var config  = ConfigFile.new()
var settings = config.load(config_path)
var audio = "audio"

var MM_Bus = AudioServer.get_bus_index("Menu_Music")
var MS_Bus = AudioServer.get_bus_index("Menu_SFX")
var GM_Bus = AudioServer.get_bus_index("Game_Music")
var GS_Bus = AudioServer.get_bus_index("Game_SFX")

var initValues = [0,0,0,0]

var device = 0

func _ready():
	initValues[0] = config.get_value(audio, "menu_music")
	initValues[1] = config.get_value(audio, "menu_sfx")
	initValues[2] = config.get_value(audio, "game_music")
	initValues[3] = config.get_value(audio, "game_sfx")
	$MenuMusic/MM_Slider.value = config.get_value(audio, "menu_music")
	$MenuSFX/MS_Slider.value = config.get_value(audio, "menu_sfx")
	$GameMusic/GM_Slider.value = config.get_value(audio, "game_music")
	$GameSFX/GS_Slider.value = config.get_value(audio, "game_sfx")
	first_focus()

func _input(event):
	if event is InputEventJoypadButton:
		device = event.get_device()
		# Shitty fix for xbox controllers sending double inputs and controllers over bluetooth
		if (("Bluetooth" in Input.get_joy_name(device)) or ("Series" in Input.get_joy_name(device))):
			get_tree().set_input_as_handled()


func first_focus():
	$MenuMusic/MM_Slider.grab_focus()

func _on_MM_Slider_value_changed(value):
	$MenuMusic/MM_Value.text = str(value * 100)
	AudioServer.set_bus_volume_db(MM_Bus, linear2db(value))
	set_button_text()

#func _on_MM_Slider_mouse_exited():
#	$MenuMusic/MM_Slider.release_focus()


func _on_MS_Slider_value_changed(value):
	$MenuSFX/MS_Value.text = str(value * 100)
	AudioServer.set_bus_volume_db(MS_Bus, linear2db(value))
	set_button_text()

#func _on_MS_Slider_mouse_exited():
#	$MenuSFX/MS_Slider.release_focus()


func _on_GM_Slider_value_changed(value):
	$GameMusic/GM_Value.text = str(value * 100)
	AudioServer.set_bus_volume_db(GM_Bus, linear2db(value))
	set_button_text()

#func _on_GM_Slider_mouse_exited():
#	$GameMusic/GM_Slider.release_focus()


func _on_GS_Slider_value_changed(value):
	$GameSFX/GS_Value.text = str(value * 100)
	AudioServer.set_bus_volume_db(GS_Bus, linear2db(value))
	set_button_text()

#func _on_GS_Slider_mouse_exited():
#	$GameSFX/GS_Slider.release_focus()


func set_button_text():
	$Save.text = "Save"

func reset_values():
	AudioServer.set_bus_volume_db(MM_Bus, linear2db(initValues[0]))
	AudioServer.set_bus_volume_db(MS_Bus, linear2db(initValues[1]))
	AudioServer.set_bus_volume_db(GM_Bus, linear2db(initValues[2]))
	AudioServer.set_bus_volume_db(GS_Bus, linear2db(initValues[3]))
	$MenuMusic/MM_Slider.value = initValues[0]
	$MenuSFX/MS_Slider.value = initValues[1]
	$GameMusic/GM_Slider.value = initValues[2]
	$GameSFX/GS_Slider.value = initValues[3]

func _on_Save_button_down():
	config.set_value(audio, "menu_music", $MenuMusic/MM_Slider.value)
	config.set_value(audio, "menu_sfx", $MenuSFX/MS_Slider.value)
	config.set_value(audio, "game_music", $GameMusic/GM_Slider.value)
	config.set_value(audio, "game_sfx", $GameSFX/GS_Slider.value)
	initValues[0] = $MenuMusic/MM_Slider.value
	initValues[1] = $MenuSFX/MS_Slider.value
	initValues[2] = $GameMusic/GM_Slider.value
	initValues[3] = $GameSFX/GS_Slider.value
	config.save(config_path)
	sfx.play_press()
	$Save.text = "Saved!"


func _on_Save_focus_entered():
	sfx.play_move()

func _on_Save_mouse_entered():
	$Save.grab_focus()


func _on_MM_Slider_mouse_entered():
	$MenuMusic/MM_Slider.grab_focus()
func _on_MS_Slider_mouse_entered():
	$MenuSFX/MS_Slider.grab_focus()
func _on_GM_Slider_mouse_entered():
	$GameMusic/GM_Slider.grab_focus()
func _on_GS_Slider_mouse_entered():
	$GameSFX/GS_Slider.grab_focus()

func _on_Slider_focus_entered():
	sfx.play_move()
	
