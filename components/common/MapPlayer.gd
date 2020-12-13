extends Node2D

##
# Properties

var cell_size = 0

func _draw():
	draw_circle(Vector2(0, 0), cell_size / 4, Color.white)
