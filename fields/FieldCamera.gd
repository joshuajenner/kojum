extends Camera2D


func _ready():
	Render.connect("scale_changed", self, "on_Scale_Changed")
	on_Scale_Changed(Render.currentScale)

func on_Scale_Changed(sc):
	zoom = Vector2(1/sc, 1/sc)
	

