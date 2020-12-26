extends Node2D

##
# Properties

var width = 0
var color = Color.transparent

func _draw():
	draw_rect(
		Rect2(0, 0, self.width, 1), 
		color, true, 0, true
	)
