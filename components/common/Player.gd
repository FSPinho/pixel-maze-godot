extends KinematicBody2D

var Ripple = preload("res://components/common/Ripple.tscn")
var PLAYER_TEXTURE = preload("res://sprites/player.png")

##
# Constants
var SPEED_BASE = Config.BLOCK_SIZE * 1.2
var TAIL_SIZE = 16.0
var TAIL_VISIBLE_SIZE = 16.0
var TAIL_VISIBLE_SCALE = 0.5

##
# Properties
var bounds = null
var size = Config.BLOCK_SIZE * 0.15
var size_scale = 1.0
var position_delayed = self.position
var direction = Vector2(0.0, 0.0)
var position_data = []
var color = Color(1, 1, 1, 1)

var speed = SPEED_BASE
var speed_min = SPEED_BASE
var speed_max_half = SPEED_BASE * 2.5
var speed_max = SPEED_BASE * 3
var speed_decay = SPEED_BASE * 4
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

func _ready():
	$Collision.shape.radius = size / 2
	$Destroyable/Particles.texture = PLAYER_TEXTURE
	$Destroyable/Particles.process_material.scale = 0.05
	$SwipeDetector.connect("on_swipe", self, "set_direction")

func _draw_circle(pos = Vector2(0, 0), scale = 1, alpha = 1):
	var _color = Color(color)
	_color.a = alpha
	draw_circle(pos, size / 2 * scale * size_scale, _color)
	
	draw_arc(
		pos, 
		size / 2 * scale * size_scale, 0, 2 * PI, 
		Config.CIRCLE_QUALITY, 
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
	var _direction = direction.normalized()
	var _speed = _sigmoid(speed, speed_min, speed_max)
	
	size_scale = $Destroyable.target_scale
	
	if $Destroyable.alive and abs(_direction.x + _direction.y) > 0:
		var _collision = self.move_and_collide(direction * _speed * delta)
		 
		if _collision and !did_collide:
			on_collision(_collision)
		
		if _collision and not speed_up_half:
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
	
	Store.set_game_player_position(self.position_delayed)

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
	var direction = Vector2(0, 0)
	
	if d == Config.SwipeDirection.SWIPE_UP:
		direction = Vector2(0, -1)	
	if d == Config.SwipeDirection.SWIPE_DOWN:
		direction = Vector2(0, 1)
	if d == Config.SwipeDirection.SWIPE_LEFT:
		direction = Vector2(-1, 0)
	if d == Config.SwipeDirection.SWIPE_RIGHT:
		direction = Vector2(1, 0)
	
	if self.move_elapsed <= self.move_delay and direction == self.direction:
		self.speed_up = true
	else:
		self.speed_up_half = true
		
	self.move_elapsed = 0
	self.direction = direction
	self.idle = false
	
	if $Destroyable.alive:
		$SoundMove.play()
	
func do_ripple():
	var ripple = Ripple.instance()
	add_child(ripple)
	ripple.start(size, size * 8, "circle")

func on_collision(collision: KinematicCollision2D):
	do_ripple()
	
	if collision_play_elapsed > collision_play_delay:
		collision_play_elapsed = 0
		$SoundCollision.play()
		
	if collision.collider.is_in_group(Config.GROUP_BLOCK_GLASS) or \
		collision.collider.is_in_group(Config.GROUP_BLOCK_10) or \
		collision.collider.is_in_group(Config.GROUP_BLOCK_100) or \
		collision.collider.is_in_group(Config.GROUP_BLOCK_1000):
		collision.collider.destroy()
	
	if collision.collider.is_in_group(Config.GROUP_BLOCK_10):
		Store.add_game_points(10)
	
	elif collision.collider.is_in_group(Config.GROUP_BLOCK_100):
		Store.add_game_points(100)
	
	elif collision.collider.is_in_group(Config.GROUP_BLOCK_1000):
		Store.add_game_points(1000)
	
	elif collision.collider.is_in_group(Config.GROUP_BLOCK_EXIT):
		collision.collider.destroy()
		die()
	 
func die():
	$Destroyable.die()
