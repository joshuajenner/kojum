extends Control

var config_path = "res://config.cfg"
var config  = ConfigFile.new()
var settings = config.load(config_path)
var audio = "audio"

var MM_Bus = AudioServer.get_bus_index("Menu_Music")
var MS_Bus = AudioServer.get_bus_index("Menu_SFX")
var GM_Bus = AudioServer.get_bus_index("Game_Music")
var GS_Bus = AudioServer.get_bus_index("Game_SFX")


func _ready():
#	$MenuMusic/MM_Slider.value = db2linear(AudioServer.get_bus_volume_db(MM_Bus))
	$MenuMusic/MM_Slider.value = config.get_value(audio, "menu_music")
	$MenuSFX/MS_Slider.value = config.get_value(audio, "menu_sfx")
	$GameMusic/GM_Slider.value = config.get_value(audio, "game_music")
	$GameSFX/GS_Slider.value = config.get_value(audio, "game_sfx")


func _on_MM_Slider_value_changed(value):
	$MenuMusic/MM_Value.text = str(value * 100)
	AudioServer.set_bus_volume_db(MM_Bus, linear2db(value))
	set_button_text()

func _on_MM_Slider_mouse_exited():
	$MenuMusic/MM_Slider.release_focus()


func _on_MS_Slider_value_changed(value):
	$MenuSFX/MS_Value.text = str(value * 100)
	AudioServer.set_bus_volume_db(MS_Bus, linear2db(value))
	set_button_text()

func _on_MS_Slider_mouse_exited():
	$MenuSFX/MS_Slider.release_focus()


func _on_GM_Slider_value_changed(value):
	$GameMusic/GM_Value.text = str(value * 100)
	AudioServer.set_bus_volume_db(GM_Bus, linear2db(value))
	set_button_text()

func _on_GM_Slider_mouse_exited():
	$GameMusic/GM_Slider.release_focus()


func _on_GS_Slider_value_changed(value):
	$GameSFX/GS_Value.text = str(value * 100)
	AudioServer.set_bus_volume_db(GS_Bus, linear2db(value))
	set_button_text()

func _on_GS_Slider_mouse_exited():
	$GameSFX/GS_Slider.release_focus()


func set_button_text():
	$Save.text = "Save"

func _on_Save_button_down():
	config.set_value(audio, "menu_music", $MenuMusic/MM_Slider.value)
	config.set_value(audio, "menu_sfx", $MenuSFX/MS_Slider.value)
	config.set_value(audio, "game_music", $GameMusic/GM_Slider.value)
	config.set_value(audio, "game_sfx", $GameSFX/GS_Slider.value)
	config.save(config_path)
	$Save.text = "Saved!"
