extends StaticBody2D

##
# Properties
var active = true
var bounds = Rect2(0, 0, 0, 0)
var active_color = "#607D8B"
var active_color2 = "#90A4AE"
var active_color3 = "#B0BEC5"
var inactive_color = "#000"

func initialize(w, h, enable_spikes = false):
	bounds = Rect2(w / -2, h / -2, w, h)
	$Collision.shape.extents = Vector2(w / 2, h / 2)

func set_inactive():
	$Collision.queue_free()
	bounds = Rect2(bounds.size.x / -1.5, bounds.size.y / -1.5, bounds.size.x, bounds.size.y)
	active = false
