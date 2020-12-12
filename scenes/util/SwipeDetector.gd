extends Node2D

##
# Constants
var SWIPE_SIZE = 64

##
# Properties
var pressed = false
var swipe_start_position = Vector2(0, 0)
var swipe_end_position = Vector2(0, 0)

##
# Signals
signal swipe

func _input(event):
	if event is InputEventMouseButton:
		if pressed != event.pressed:
			if event.pressed:
				swipe_start_position = event.position
			else:
				swipe_end_position = event.position
				_handle_swipe(swipe_start_position, swipe_end_position)
		
		pressed = event.pressed
	
	elif event is InputEventKey and not event.pressed:
		var direction = null
		
		if event.scancode == KEY_RIGHT:
			direction = G.SwipeDirection.SWIPE_RIGHT
		if event.scancode == KEY_UP:
			direction = G.SwipeDirection.SWIPE_UP
		if event.scancode == KEY_LEFT:
			direction = G.SwipeDirection.SWIPE_LEFT
		if event.scancode == KEY_DOWN:
			direction = G.SwipeDirection.SWIPE_DOWN
		
		if direction:
			emit_signal("swipe", direction)
			
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
			direction = G.SwipeDirection.SWIPE_RIGHT
		if _is_between(swipe_angle, 45, 135):
			direction = G.SwipeDirection.SWIPE_UP
		if _is_between(swipe_angle, 135, 225):
			direction = G.SwipeDirection.SWIPE_LEFT
		if _is_between(swipe_angle, 225, 315):
			direction = G.SwipeDirection.SWIPE_DOWN
		
		if direction:
			emit_signal("swipe", direction)

func _is_between(n, x, y):
	return n >= x and n <= y
