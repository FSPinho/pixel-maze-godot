extends Node2D

##
# Properties
var progress = 0.0
var progress_scaled = 0.0

var speed = 0

var size = 0.0
var size_max = 0.0

var shape = "circle"
var alpha = 1.0
var target_position = Vector2(0, 0)

func _ready():
	add_to_group(Config.GROUP_RIPPLE)

func _draw():
	if shape == "circle":
		draw_arc(
			Vector2(0, 0), lerp(size, size_max, progress) / 2, 0, PI * 2, 
			Config.CIRCLE_QUALITY,
			Color(1, 1, 1, lerp(1, 0, progress)), 8, true
		)
		
		draw_circle(
			Vector2(0, 0), lerp(size, size_max, progress) / 2,
			Color(1, 1, 1, lerp(0.4, 0, progress))
		)
	
func _process(delta):
	self.position = target_position - get_parent().position
	
	if size and size_max > size:
		var _speed = speed / (size_max - size)
		progress += max(0, _speed * delta)
		progress_scaled = Util.sigmoid(progress, 0, 1)
	
	update()
	
	if progress >= 0.99:
		self.queue_free()

func start(s, s_max, sh, sp = 150):
	size = s
	size_max = s_max
	speed = sp
	shape = sh
	progress = 0
	target_position = get_parent().position
