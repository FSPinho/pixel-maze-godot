extends Node2D

##
# Properties

var cell_size = 0
var color = Color(0, 0, 0, 0.75)
var exit = false

func _ready():
	self.scale = Vector2(0, 0)

func _draw():
	self.draw_rect(
		Rect2(
			Vector2(self.cell_size / -2, self.cell_size / -2), 
			Vector2(self.cell_size, self.cell_size)
		),
		color, true, 0, true
	)

func _process(delta):
	self.scale = self.scale.linear_interpolate(Vector2(1, 1), 0.05)
