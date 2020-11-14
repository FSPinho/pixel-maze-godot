extends Node2D

var SWIPE_SIZE = 128
var SWIPE_UP = "UP"
var SWIPE_DOWN = "DOWN"
var SWIPE_LEFT = "LEFT"
var SWIPE_RIGHT = "RIGHT"

var pressed = false
var swipe_start_position = Vector2(0, 0)
var swipe_end_position = Vector2(0, 0)

func _input(event):
	if event is InputEventMouseButton:
		if pressed != event.pressed:
			if event.pressed:
				swipe_start_position = event.position
			else:
				swipe_end_position = event.position
				_handle_swipe(swipe_start_position, swipe_end_position)
		
		pressed = event.pressed
		
	update()

func _handle_swipe(start, end):
	var direction = end - start
	var swipe_angle = (atan2(direction.y, direction.x) * 180 / PI) * -1
	var swipe_offset = sqrt(pow(direction.x, 2) + pow(direction.y, 2))
	
	if swipe_angle < 0:
		swipe_angle += 360
	
	if swipe_offset >= SWIPE_SIZE:
		direction = null
	
		if _is_between(swipe_angle, 0, 45) or _is_between(swipe_angle, 315, 360):
			direction = SWIPE_RIGHT
		if _is_between(swipe_angle, 45, 135):
			direction = SWIPE_UP
		if _is_between(swipe_angle, 135, 225):
			direction = SWIPE_LEFT
		if _is_between(swipe_angle, 225, 315):
			direction = SWIPE_DOWN
		
		if direction:
			print (direction)

func _is_between(n, x, y):
	return n >= x and n <= y

func _draw():
	if swipe_start_position:
		draw_circle(swipe_start_position, 4, Color.red)
	if swipe_end_position:
		draw_circle(swipe_end_position, 4, Color.blue)
