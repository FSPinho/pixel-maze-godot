extends StaticBody2D

##
# Constants
var target = null
var bounds = Rect2(0, 0, 0, 0)
var position_offset = Vector2(0, 0)
var collision_width = 96

func _draw():
	draw_rect(
		bounds, 
		"#AAA", false, collision_width, true
	)

func _physics_process(delta):
	if target:
		self.position = target.position_delayed * -1 + position_offset


func set_size(w, h):
	$Collision1.disabled = false
	$Collision1.shape.extents = Vector2(w / 2, collision_width / 2)
	$Collision1.position = Vector2(0, h / -2)

	$Collision2.disabled = false	
	$Collision2.shape.extents = Vector2(w / 2, collision_width / 2)
	$Collision2.position = Vector2(0, h / 2)
	
	$Collision3.disabled = false
	$Collision3.shape.extents = Vector2(collision_width / 2, h / 2)
	$Collision3.position = Vector2(w / -2, 0)
	
	$Collision4.disabled = false
	$Collision4.shape.extents = Vector2(collision_width / 2, h / 2)
	$Collision4.position = Vector2(w / 2, 0)
	
	bounds = Rect2(w / -2, h / -2, w, h)
