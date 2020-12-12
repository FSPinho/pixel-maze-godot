extends Node

##
# Constants


func _ready():
	$World.initialize(21, 21)
	$World.position_offset = Vector2(G.VIEWPORT_WIDTH / 2.0, G.VIEWPORT_HEIGHT / 2.0)
	$World.target = $World/Player
	$World/Player.bounds = $World.bounds
	$SwipeDetector.connect("swipe", self, "_on_swipe")


func _on_swipe(direction):
	var dir = Vector2(0, 0)
	
	if direction == G.SwipeDirection.SWIPE_UP:
		dir = Vector2(0, -1)
	if direction == G.SwipeDirection.SWIPE_RIGHT:
		dir = Vector2(1, 0)
	if direction == G.SwipeDirection.SWIPE_LEFT:
		dir = Vector2(-1, 0)
	if direction == G.SwipeDirection.SWIPE_DOWN:
		dir = Vector2(0, 1)
	
	$World/Player.set_direction(dir)
