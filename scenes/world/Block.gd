extends StaticBody2D

##
# Properties
var active = true
var bounds = Rect2(0, 0, 0, 0)
var active_color = "#607D8B"
var active_color_stroke = "#78909C"
var inactive_color = "#000"
var inactive_color_stroke = "#000"


func _draw():
	draw_rect(bounds, active_color if active else inactive_color, true, 0, true)
	draw_rect(bounds, active_color_stroke if active else inactive_color_stroke, false, 2, true)

func initialize(w, h):
	bounds = Rect2(w / -2, h / -2, w, h)
	$Collision.shape.extents = Vector2(w / 2, h / 2)

func set_inactive():
	$Collision.disabled = true
	bounds = Rect2(bounds.size.x / -1.5, bounds.size.y / -1.5, bounds.size.x, bounds.size.y)
	active = false
