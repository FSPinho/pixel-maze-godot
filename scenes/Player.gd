extends KinematicBody2D

##
# Constants
var SPEED_BASE = 300
var TAIL_SIZE = 16
var TAIL_VISIBLE_SIZE = 16
var TAIL_VISIBLE_SCALE = 0.5

##
# Properties
var bounds = null
var size = 96.0
var position_delayed = self.position
var direction = Vector2(0.0, 0.0)
var position_data = []
var speed = SPEED_BASE
var speed_min = SPEED_BASE
var speed_max = SPEED_BASE * 3.5
var speed_decay = SPEED_BASE * 7.5
var speed_up = false
var color = Color(1, 1, 1, 1)
var circle_quality = 32

func _ready():
	$Collision.shape.radius = size / 2

func _draw_circle(pos = Vector2(0, 0), scale = 1, alpha = 1):
	var _color = Color(color)
	_color.a = alpha
	draw_circle(pos, size / 2 * scale, _color)
	
	draw_arc(
		pos, 
		size / 2 * scale, 0, 2 * PI, 
		circle_quality, 
		_color, 2, true
	)

func _draw():
	var _speed_overflow = speed - speed_min
	var _speed_overflow_max = speed_max - speed_min
	var _speed = _speed_overflow / _speed_overflow_max
	var _scale = lerp(1, TAIL_VISIBLE_SCALE, _speed)
	var _interpolation_scale = lerp(1, 0.0, _speed)
	
	var _s = 1.0
	for _d in position_data.slice(0, TAIL_VISIBLE_SIZE):
		var __d = _d
		__d.x = self.position.x if direction.x == 0 else __d.x
		__d.y = self.position.y if direction.y == 0 else __d.y
		_draw_circle(__d.linear_interpolate(self.position, _interpolation_scale) - self.position, _scale * _s)
		_s -= 0.02
	
func _process(delta):
	update()

func _physics_process(delta):
	var _direction = direction.normalized()
	var _speed = _sigmoid(speed, speed_min, speed_max)
	if abs(_direction.x + _direction.y) > 0:
		var _collision = self.move_and_collide(direction * _speed * delta)
		if _collision and not speed_up:
			_collision.collider_shape
			direction *= 0.2
			
	if speed >= speed_max:
		speed_up = false
	
	if speed_up:
		speed = max(min(speed + speed_decay * delta * 6, speed_max), speed_min)
	else:
		speed = max(min(speed - speed_decay * delta, speed_max), speed_min)
	
	position_data.insert(0, self.position)
	if position_data.size() > TAIL_SIZE:
		position_delayed = position_data.pop_back()

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
	speed_up = true
