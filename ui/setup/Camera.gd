extends Camera2D

export var DESIRED_RESOLUTION = Vector2(512, 288)
var vp
var scaling_factor = 1

func _ready():
	vp = get_viewport()
	vp.connect("size_changed", self, "on_vp_size_change")
	on_vp_size_change()

func on_vp_size_change():
	var scale_vector = vp.size / DESIRED_RESOLUTION
	var scale = min(scale_vector[0], scale_vector[1])
	var floored_scale = floor(scale)
	if abs(floored_scale - scale) >= 0.67:
		scale = floored_scale + 1
	else:
		scale = floored_scale
	if scale != scaling_factor:
#		scaling_factor = scale
		if scale == 0:
			scale = 1
		zoom = Vector2(1 / scale, 1 / scale)
		
#	var new_scaling_factor = max(floor(min(scale_vector[0], scale_vector[1])), 1)
#	if new_scaling_factor != scaling_factor:
#		scaling_factor = new_scaling_factor
#		zoom = Vector2(1 / scaling_factor, 1 / scaling_factor)
