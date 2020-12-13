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

func _init(w: int = Config.WORLD_WIDTH, h: int = Config.WORLD_HEIGHT):
	self.width = w
	self.height = h
	
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
			
			print (percent_glass, " ", percent_10, " ", percent_100, " ", percent_1000)
			
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
			
			self.set_block(i, j, MatrixBlock.new(type))
	
	var mi: float = ceil(self.height / 2)
	var mj: float = ceil(self.height / 2)
	var path: Array = []
	var canGo: bool = true
	
	var deep: int = 0
	
	while canGo:
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

func _check_around(i, j, ri, rj):
	var near = 0
	for _i in ri:
		for _j in rj:
			if self.get_block(_i, _j).type != Config.BlockType.NONE:
				near += 1
	return near >= 6
	
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

