extends Node2D

##
# Constants
var SPEED_BASE = 300

##
# Properties
var size = 96.0
var direction = Vector2(0.0, 0.0)
var speed = SPEED_BASE
var speed_min = SPEED_BASE
var speed_max = SPEED_BASE * 3.2
var speed_decay = SPEED_BASE * 5.2
var color = Color(1, 1, 1, 1)
var circle_quality = 32

func _ready():
	print (_sigmoid(speed, speed_min, speed_max))
	print (_sigmoid(speed + 10, speed_min, speed_max))
	print (_sigmoid(speed + 20, speed_min, speed_max))
	print (_sigmoid(speed + 30, speed_min, speed_max))
	print (_sigmoid(speed + 40, speed_min, speed_max))

func _draw():
	draw_circle(Vector2(0, 0), size / 2, color)
	draw_arc(
		Vector2(0, 0), 
		size / 2, 0, 2 * PI, 
		circle_quality, 
		color, 1, true
	)

func _process(delta):
	var _speed = _sigmoid(speed, speed_min, speed_max)
	self.position += direction * _speed * delta
	speed = max(min(speed - speed_decay * delta, speed_max), speed_min)
	
	var _summary = "\n\nSpeed:\t%.2f" % speed
	_summary += "\n_Speed:\t%.2f" % _speed
	$Label.text = _summary

func _sigmoid(n, _min, _max):
	var E = 2.718281
	return max(
		_min, 
		(_max - _min) * 2 / (1 + pow(E, -0.004 * (n - _min))) - 
		(_max - _min) + _min
	)

func set_size(s):
	size = s

func set_speed(s):
	speed = s

func set_direction(d):
	direction = d
	speed = speed_max
