extends Node2D

##
# Properties

var pos_interpolation = Util.interpolate(
	[
		Vector2(1080, 1920),
		Vector2(250, 250) * 2,
		Vector2(300, 100) * 2,
		Vector2(100, 300) * 2,
		Vector2(0, 0)
	], 
	0.1
)

var elapsed = 0.0
var duration = 5.0

func _ready():
	self.position = pos_interpolation[0]

func _draw():
	Util.draw_interpolation(self, pos_interpolation)

func _process(delta):
	elapsed += delta
	var t = elapsed / duration
	var current_pos = Util.interpolate_point(pos_interpolation, t)
	
	self.position = current_pos
	update()
