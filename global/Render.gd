extends Node


const RESOLUTION = Vector2(512, 288)
const MINIMUM = 0.67
var vp
var currentScale = 1
var targetScale = 1

signal window_resized(size, scale)
signal scale_changed(scale)


func _ready():
	vp = get_viewport()
	vp.connect("size_changed", self, "on_vp_size_change")
	on_vp_size_change()


func on_vp_size_change():
	# Check the ratio between the game res and the viewport
	var scaleVector = vp.size / RESOLUTION
	
	# Get the side with the smallest ratio
	targetScale = min(scaleVector[0], scaleVector[1])
	
	# Check if there is just enough space to scale up
	if targetScale - floor(targetScale) >= MINIMUM:
		targetScale = ceil(targetScale)
	else:
		targetScale = floor(targetScale)
	
	# Update scale
	if targetScale != currentScale:
		currentScale = targetScale
		emit_signal("scale_changed", currentScale)
	
	emit_signal("window_resized", vp.size, currentScale)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
