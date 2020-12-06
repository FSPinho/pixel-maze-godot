extends StaticBody2D

##
# Properties
var size_start = Global.BLOCK_SIZE * 0.20
var size_end = Global.BLOCK_SIZE * 0.25
var width_start = Global.BLOCK_SIZE * 0.05
var width_end = Global.BLOCK_SIZE * 0.05
var count_start = 2
var count_end = 8
var spikes = []
var count = 10.0
var scale_up = false
var scale_min = 0.8

func _ready():
	self.add_to_group(Global.GROUP_ENEMY)
	
	$Collision.shape.radius = size_end
	
	for i in range(count):
		randomize()
		
		var angle = (i / count) * PI * 2.0 
		var size = randf() * (size_end - size_start) + size_start 
		var width = randf() * (width_end - width_start) + width_start 
		
		var point1 = Vector2(
			cos(angle) * size,
			sin(angle) * size
		)
		
		var point2 = Vector2(
			cos(angle - PI / 2) * width,
			sin(angle - PI / 2) * width
		) + point1 * 0.5
		
		var point3 = Vector2(
			cos(angle + PI / 2) * width,
			sin(angle + PI / 2) * width
		) + point1 * 0.5
		
		spikes.append({
			"s": PoolVector2Array([
				Vector2(0, 0),
				point3,
				point1,
				point2,
				Vector2(0, 0)
			]),
			"c": "#B71C1C"
		})
		
		spikes.append({
			"s": PoolVector2Array([
				Vector2(0, 0) * 0.8,
				point3 * 0.6,
				point1 * 0.8,
				point2 * 0.6,
				Vector2(0, 0) * 0.8
			]),
			"c": "#D32F2F"
		})
		
		spikes.append({
			"s": PoolVector2Array([
				Vector2(0, 0) * 0.4,
				point3 * 0.4,
				point1 * 0.4,
				point2 * 0.4,
				Vector2(0, 0) * 0.4
			]),
			"c": "#F44336"
		})
		
func _draw():
	var i = 0
	for s in spikes:
		draw_colored_polygon(s.s, s.c)
		i += 1

func _process(delta):
	if self.scale.x <= scale_min:
		scale_up = true
	if self.scale.x >= 0.99:
		scale_up = false
	
	if scale_up:
		self.scale.x = min(1, self.scale.x + delta * 0.1)
	else:
		self.scale.x = max(0, self.scale.x - delta * 0.1)
	
	self.scale.y = self.scale.x


