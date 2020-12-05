extends Node2D

##
# Constants
var WIDTH = 400
var HEIGHT = 400

func _draw():
	draw_rect(
		Rect2(WIDTH / -2, HEIGHT / -2, WIDTH, HEIGHT), 
		Color.red, false, 5, true
	)
