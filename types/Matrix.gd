extends Node 

const MatrixBlock = preload("res://types/MatrixBlock.gd")

var width = 0
var height = 0
var _matrix = {}
var _percent = {
	Config.BlockType.STONE: 0,
	Config.BlockType.GLASS: 0,
	Config.BlockType._10: 0,
	Config.BlockType._100: 0,
	Config.BlockType._1000: 0,
}

var start = [0, 0]
var end = [0, 0]

func _init(w: int = Config.WORLD_WIDTH, h: int = Config.WORLD_HEIGHT):
	self.width = w
	self.height = h
	
	var bounds = Rect2(
		Config.BLOCK_SIZE * Config.WORLD_WIDTH / -2, 
		Config.BLOCK_SIZE * Config.WORLD_HEIGHT / -2, 
		Config.BLOCK_SIZE * Config.WORLD_WIDTH, 
		Config.BLOCK_SIZE * Config.WORLD_HEIGHT
	)
	
	if w <= 0 or h <= 0:
		return
	
	randomize()
	
	for i in range(self.height):
		for j in range(self.width):
			
			var rand = randi() % 1000
			var type = Config.BlockType.STONE
			var percent_glass = 1000 * Config.BLOCK_GLASS_PERCENT
			var percent_10 = percent_glass + 1000 * Config.BLOCK_10_PERCENT
			var percent_100 = percent_10 + 1000 * Config.BLOCK_100_PERCENT
			var percent_1000 = percent_100 + 1000 * Config.BLOCK_1000_PERCENT
			
			if rand <= percent_glass:
				type = Config.BlockType.GLASS
				self._percent[Config.BlockType.GLASS] += 1
				
			elif rand <= percent_10:
				type = Config.BlockType._10
				self._percent[Config.BlockType._10] += 1
			
			elif rand <= percent_100:
				type = Config.BlockType._100
				self._percent[Config.BlockType._100] += 1
			
			elif rand <= percent_1000:
				type = Config.BlockType._1000
				self._percent[Config.BlockType._1000] += 1
			
			else:
				self._percent[Config.BlockType.STONE] += 1
			
			var matrix_block = MatrixBlock.new(type)
			
			matrix_block.position = Vector2(
				j * Config.BLOCK_SIZE + Config.BLOCK_SIZE / 2 - bounds.size.x / 2,
				i * Config.BLOCK_SIZE + Config.BLOCK_SIZE / 2 - bounds.size.y / 2
			)
			
			self.set_block(i, j, matrix_block)
	
	var mi: float = ceil(self.height / 2)
	var mj: float = ceil(self.height / 2)
	
	self.start = [mi, mj]
	
	var path: Array = []
	var path_max: Array = []
	var canGo: bool = true
	
	var deep: int = 0
	
	while canGo:
		if path.size() > path_max.size():
			path_max = path.duplicate(true)
		
		var block: MatrixBlock = self.get_block(mi, mj)
		self.get_block(mi, mj).type = Config.BlockType.NONE
		
		var nmi: int = mi
		var nmj: int = mj
		var up_av = mi > 1 && _check_around(
			mi - 1, mj, 
			range(mi - 2, mi), 
			range(mj - 1, mj + 2)
		)
		var do_av = mi < self.height - 2 &&  _check_around(
			mi + 1, mj, 
			range(mi + 1, mi + 3), 
			range(mj - 1, mj + 2)
		)
		var le_av = mj > 1 && _check_around(
			mi, mj - 1, 
			range(mi - 1, mi + 2), 
			range(mj - 2, mj)
		)
		var ri_av = mj < self.width - 2 && _check_around(
			mi, mj + 1, 
			range(mi - 1, mi + 2), 
			range(mj + 1, mj + 3)
		)
		
		if not (up_av or do_av or le_av or ri_av):
			if path.size() > 0:
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
		var ddeep = 0
		while not av.has(d):
			ddeep += 1
			d = randi() % 4
			if ddeep > 10000:
				return
		
		if d == 0:
			nmi -= 1
		if d == 1:
			nmi += 1
		if d == 2:
			nmj -= 1
		if d == 3:
			nmj += 1
		
		path.append([mi, mj])
		mi = nmi
		mj = nmj
		deep += 1
		if deep > 10000:
			return 

	var end = path_max[path_max.size() - 1]
	self.end = [end[0], end[1]]
	self.get_block(end[0], end[1]).type = Config.BlockType.EXIT
	
	for i in range(self.height):
		for j in range(self.width):
			get_block(i, j).shape = _get_shape(i, j)
			print (get_block(i, j).shape)

func _check_around(i, j, ri, rj):
	var near = 0
	for _i in ri:
		for _j in rj:
			if self.get_block(_i, _j).type != Config.BlockType.NONE:
				near += 1
	return near >= 6

func _get_shape(i, j):
	var w = self.width - 1
	var h = self.height - 1
	var has_up = i > 0 and get_block(i - 1, j).type == Config.BlockType.STONE
	var has_do = i < h and get_block(i + 1, j).type == Config.BlockType.STONE
	var has_le = j > 0 and get_block(i, j - 1).type == Config.BlockType.STONE
	var has_ri = j < w and get_block(i, j + 1).type == Config.BlockType.STONE 
	
	get_block(i, j).label = "u=%s d=%s l=%s r=%s" % [
		"t" if has_up else "f", 
		"t" if has_do else "f", 
		"t" if has_le else "f", 
		"t" if has_ri else "f"
	]
	
	if has_up and has_do and has_le and has_ri:
		return Config.BlockShape.CROSSED
	if not(has_up or has_do or has_le or has_ri):
		return Config.BlockShape.CLOSED
	if has_up and has_le and has_do:
		return Config.BlockShape.T_LEFT
	if has_up and has_ri and has_do:
		return Config.BlockShape.T_RIGHT
	if has_le and has_up and has_ri:
		return Config.BlockShape.T_TOP
	if has_le and has_do and has_ri:
		return Config.BlockShape.T_BOTTOM
	if has_up and has_le:
		return Config.BlockShape.BOTTOM_RIGHT
	if has_up and has_ri:
		return Config.BlockShape.BOTTOM_LEFT
	if has_do and has_le:
		return Config.BlockShape.TOP_RIGHT
	if has_do and has_ri:
		return Config.BlockShape.TOP_LEFT
	if has_up and has_do:
		return Config.BlockShape.VERTICAL
	if has_le and has_ri:
		return Config.BlockShape.HORIZONTAL
	if has_up:
		return Config.BlockShape.END_TOP
	if has_le:
		return Config.BlockShape.END_LEFT
	if has_ri:
		return Config.BlockShape.END_RIGHT
	if has_do:
		return Config.BlockShape.END_BOTTOM
	
	return Config.BlockShape.CLOSED
	
func set_block(i: int, j: int, v: MatrixBlock) -> void:
	self._matrix["%s %s" % [str(i), str(j)]] = v

func get_block(i: int, j: int) -> MatrixBlock:
	return self._matrix["%s %s" % [str(i), str(j)]]

func get_summary():
	var _out = "[%d : %d = %d] {\n" % [self.width, self.height, self.width * self.height]
	
	_out += "\tSTONE: %d,\n" % self._percent[Config.BlockType.STONE]
	_out += "\tGLASS: %d,\n" % self._percent[Config.BlockType.GLASS]
	_out += "\t10   : %d,\n" % self._percent[Config.BlockType._10]
	_out += "\t100  : %d,\n" % self._percent[Config.BlockType._100]
	_out += "\t1000 : %d,\n" % self._percent[Config.BlockType._1000]
	
	_out += "\n}"
	
	return _out

