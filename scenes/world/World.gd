extends StaticBody2D

var Block = preload("res://scenes/world/Block.tscn")

##
# Constants
var target = null
var bounds = Rect2(0, 0, 0, 0)
var position_offset = Vector2(0, 0)
var collision_width = 96
var blocks_horizontal = 0
var blocks_vertical = 0

func _draw():
	draw_rect(
		bounds, 
		"#222", true, 0, true
	)
	
func _physics_process(delta):
	if target:
		self.position = target.position_delayed * -1 + position_offset
		$Background.position = target.position_delayed * 0.4


func initialize(bh, bv):
	blocks_horizontal = bh
	blocks_vertical = bv
	var w = G.BLOCK_SIZE * bh
	var h = G.BLOCK_SIZE * bv
	
	$Collision1.disabled = false
	$Collision1.shape.extents = Vector2(w / 2, collision_width / 2)
	$Collision1.position = Vector2(0, h / -2 - collision_width / 2)

	$Collision2.disabled = false	
	$Collision2.shape.extents = Vector2(w / 2, collision_width / 2)
	$Collision2.position = Vector2(0, h / 2 + collision_width / 2)
	
	$Collision3.disabled = false
	$Collision3.shape.extents = Vector2(collision_width / 2, h / 2)
	$Collision3.position = Vector2(w / -2 - collision_width / 2, 0)
	
	$Collision4.disabled = false
	$Collision4.shape.extents = Vector2(collision_width / 2, h / 2)
	$Collision4.position = Vector2(w / 2 + collision_width / 2, 0)
	
	bounds = Rect2(w / -2, h / -2, w, h)
	
	randomize()
	
	var matrix = []
	for i in range(bv):
		var line = []
		matrix.append(line)
		for j in range(bh):
			line.append({
				"block": true,
				"head": false,
				"test": false
			})
	
	var mi = ceil(bv / 2)
	var mj = ceil(bh / 2)
	var path = []
	var canGo = true
	
	var ___i = 0
	while canGo:
		matrix[mi][mj].head = true
		matrix[mi][mj].block = false
		
		var nmi = mi
		var nmj = mj
		var up_av = mi > 1 && check_around(
			matrix, mi - 1, mj, 
			range(mi - 2, mi), 
			range(mj - 1, mj + 2)
		)
		var do_av = mi < bv - 2 &&  check_around(
			matrix, mi + 1, mj, 
			range(mi + 1, mi + 3), 
			range(mj - 1, mj + 2)
		)
		var le_av = mj > 1 && check_around(
			matrix, mi, mj - 1, 
			range(mi - 1, mi + 2), 
			range(mj - 2, mj)
		)
		var ri_av = mj < bh - 2 && check_around(
			matrix, mi, mj + 1, 
			range(mi - 1, mi + 2), 
			range(mj + 1, mj + 3)
		)
		
		if not (up_av or do_av or le_av or ri_av):
			if path.size() > 0:
				matrix[mi][mj].head = false
				var path_head = path.pop_front()
				mi = path_head[0]
				mj = path_head[1]
			else:
				canGo = false;
			
			continue
		
		var av = []
		if up_av:
			av.append(0)
		if do_av:
			av.append(1)
		if le_av:
			av.append(2)
		if ri_av:
			av.append(3)
			
		var d = randi() % 4
		var __i = 0
		while not av.has(d):
			__i += 1
			d = randi() % 4
			if __i > 10000:
				print (" --- LOOP")
				return
		
		if d == 0:
			nmi -= 1
		if d == 1:
			nmi += 1
		if d == 2:
			nmj -= 1
		if d == 3:
			nmj += 1
		
		matrix[mi][mj].head = false
		path.append([mi, mj])
		mi = nmi
		mj = nmj
		___i += 1
		if ___i > 10000:
			print(" --- UPPER LOOP")
			return 
	
	for i in range(bv):
		for j in range(bh):
			if matrix[i][j].block:
				add_child(create_block(i, j))
				

func create_block(i, j):
	var block = Block.instance()
	
	block.initialize(G.BLOCK_SIZE, G.BLOCK_SIZE, randi() % 8 == 0)
	
	block.position = Vector2(
		j * G.BLOCK_SIZE + G.BLOCK_SIZE / 2 - bounds.size.x / 2,
		i * G.BLOCK_SIZE + G.BLOCK_SIZE / 2 - bounds.size.y / 2
	)

	return block
		
func check_around(matrix, i, j, ri, rj):
	var near = 0
	for _i in ri:
		for _j in rj:
			if matrix[_i][_j].block:
				near += 1
	return near >= 6
	
