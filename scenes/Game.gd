extends Node

##
# Constants
var VIEWPORT_WIDTH = 1080
var VIEWPORT_HEIGHT = 1920

func _ready():
	$Player.position = Vector2(VIEWPORT_WIDTH / 2, VIEWPORT_HEIGHT / 2)
	$SwipeDetector.connect("swipe", self, "_on_swipe")


func _on_swipe(direction):
	var dir = Vector2(0, 0)
	
	if direction == $SwipeDetector.SwipeDirection.SWIPE_UP:
		dir = Vector2(0, -1)
	if direction == $SwipeDetector.SwipeDirection.SWIPE_RIGHT:
		dir = Vector2(1, 0)
	if direction == $SwipeDetector.SwipeDirection.SWIPE_LEFT:
		dir = Vector2(-1, 0)
	if direction == $SwipeDetector.SwipeDirection.SWIPE_DOWN:
		dir = Vector2(0, 1)
	
	$Player.set_direction(dir)
