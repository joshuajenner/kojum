extends Sprite

export var side = -1

func _ready():
	material.set_shader_param("NEW1", Global.TEAM_FIELD_COLOURS[Global.chosenTeams[side]][0])
	material.set_shader_param("NEW2", Global.TEAM_FIELD_COLOURS[Global.chosenTeams[side]][1])
	material.set_shader_param("NEW3", Global.TEAM_FIELD_COLOURS[Global.chosenTeams[side]][2])
