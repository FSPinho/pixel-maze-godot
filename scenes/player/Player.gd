extends KinematicBody2D

var Ripple = preload("res://scenes/util/Ripple.tscn")

##
# Constants
var SPEED_BASE = Global.BLOCK_SIZE * 0.6
var TAIL_SIZE = 16.0
var TAIL_VISIBLE_SIZE = 16.0
var TAIL_VISIBLE_SCALE = 0.5

##
# Properties
var bounds = null
var size = Global.BLOCK_SIZE * 0.15
var size_scale = 1.0
var position_delayed = self.position
var direction = Vector2(0.0, 0.0)
var position_data = []
var color = Color(1, 1, 1, 1)

var speed = SPEED_BASE
var speed_min = SPEED_BASE
var speed_max_half = SPEED_BASE * 2.5
var speed_max = SPEED_BASE * 3
var speed_decay = SPEED_BASE * 6
var speed_up_half = false
var speed_up = false

var did_collide = false

var idle = true
var idle_elapsed = 3
var idle_delay = 4

var collision_play_elapsed = 0.6
var collision_play_delay = 0.6

var move_elapsed = 0.6
var move_delay = 0.6

var dead = false


func _ready():
	$Collision.shape.radius = size / 2

func _draw_circle(pos = Vector2(0, 0), scale = 1, alpha = 1):
	var _color = Color(color)
	_color.a = alpha
	draw_circle(pos, size / 2 * scale * size_scale, _color)
	
	draw_arc(
		pos, 
		size / 2 * scale * size_scale, 0, 2 * PI, 
		Global.CIRCLE_QUALITY, 
		_color, 2, true
	)

func _draw():
	var _speed_overflow = speed - speed_min
	var _speed_overflow_max = speed_max - speed_min
	var _speed = _speed_overflow / _speed_overflow_max
	var _scale = lerp(1, TAIL_VISIBLE_SCALE, _speed)
	var _interpolation_scale = lerp(1.0, 0.0, _speed)
	
	var _s = 1.0
	for _d in position_data.slice(0, TAIL_VISIBLE_SIZE):
		var __d = _d
		__d.x = self.position.x if direction.x == 0 else __d.x
		__d.y = self.position.y if direction.y == 0 else __d.y
		_draw_circle(__d.linear_interpolate(self.position, _interpolation_scale) - self.position, _scale * _s)
		_s -= 0.02
	
func _process(delta):
	if idle:
		idle_elapsed += delta
		if idle_elapsed >= idle_delay:
			idle_elapsed = 0
			do_ripple()
	
	update()

func _physics_process(delta):
	
	if dead:
		size_scale = max(size_scale - 1 * delta, 0)
	
	var _direction = direction.normalized()
	var _speed = _sigmoid(speed, speed_min, speed_max)
	
	if not dead and abs(_direction.x + _direction.y) > 0:
		var _collision = self.move_and_collide(direction * _speed * delta)
		 
		if _collision and !did_collide:
			if collision_play_elapsed > collision_play_delay:
				collision_play_elapsed = 0
				$SoundCollision.play()
			do_ripple()
			
			if _collision.collider.is_in_group(Global.GROUP_ENEMY):
				die()
		
		if _collision and not speed_up_half:
			_collision.collider_shape
			direction *= 0.2
		
		did_collide = not not _collision
			
	if speed >= speed_max - 1:
		speed_up = false
	
	if speed >= speed_max_half - 1:
		speed_up_half = false
	
	if speed_up:
		speed = max(min(speed + speed_decay * delta * 4.0, speed_max), speed_min)
	elif speed_up_half:
		speed = max(min(speed + speed_decay * delta * 4.0, speed_max_half), speed_min)
	else:
		speed = max(min(speed - speed_decay * delta, speed_max), speed_min)
		
	position_data.insert(0, self.position)
	if position_data.size() > TAIL_SIZE:
		position_delayed = position_data.pop_back()
	
	collision_play_elapsed += delta
	move_elapsed += delta

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
	if move_elapsed <= move_delay and d == direction:
		speed_up = true
	else:
		speed_up_half = true
		
	move_elapsed = 0
	direction = d
	idle = false
	
	if not dead:
		$SoundMove.play()
	
func do_ripple():
	var ripple = Ripple.instance()
	add_child(ripple)
	ripple.start(size, size * 8, "circle")
	
func die():
	dead = true
	$Particles.emitting = true
