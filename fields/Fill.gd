extends Polygon2D


# Called when the node enters the scene tree for the first time.
func _ready():
	Render.connect("window_resized", self, "on_Window_Resized")
	on_Window_Resized(Render.vp.size, Render.currentScale)


func on_Window_Resized(ws, _sc):
	set_polygon([
		Vector2(0, 0),
		Vector2(ws.x, 0),
		Vector2(ws.x, ws.y),
		Vector2(0, ws.y)
	])
	offset = Vector2((-ws.x/2), (-ws.y/2))

