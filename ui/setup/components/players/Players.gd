extends Control

signal instance_player

onready var allPlayers = $HBoxContainer

func _ready():
	reset_controllers()
	setup_player_connectors()
	display_next_connector()
	grab_focus()
	set_customizer_indexes()

func set_customizer_indexes():
	var ind = 0
	for child in allPlayers.get_children():
		child.player_no = ind
		ind += 1

func reset_controllers():
	for child in allPlayers.get_children():
		child.turn_invisible()

func setup_player_connectors():
	# Show all which have a device connected
	for cont in Global.allControllers.size():
		if Global.allControllers[cont] != -2:
			allPlayers.get_child(cont).turn_visible()
			allPlayers.get_child(cont).display_customizers()

func display_next_connector():
	# Show one for connection if not all are taken
	for cont in Global.allControllers.size():
		if Global.allControllers[cont] == -2:
			allPlayers.get_child(cont).turn_visible()
			break


func _gui_input(event):
	var inputPassed = false
	var device = -1
	# Set device to the correct joypad else its from kb
	if event is InputEventJoypadButton:
		device = event.get_device()
	# Pass input to customizer with correct device
	for child in allPlayers.get_children():
		if Global.allControllers[child.player_no] == device:
			child.receive_input(event)
			inputPassed = true
			break

	# If none found, must be new device, pass it to the first customizer with no device
	if !inputPassed:
		for child in allPlayers.get_children():
			if Global.allControllers[child.player_no] == -2:
				child.connect_to_device(event, device)
				display_next_connector()
				break

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Player_finished_setup():
	pass # Replace with function body.


func _on_Player2_finished_setup():
	pass # Replace with function body.
