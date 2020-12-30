extends StaticBody2D

const MatrixBlock = preload("res://types/MatrixBlock.gd")

const BLOCK_STONE_CLOSED_TEXTURE = preload("res://sprites/brick-stone-001.png")
const BLOCK_STONE_LINE_TEXTURE = preload("res://sprites/brick-stone-002.png")
const BLOCK_STONE_CROSSED_TEXTURE = preload("res://sprites/brick-stone-003.png")
const BLOCK_STONE_TOP_LEFT_TEXTURE = preload("res://sprites/brick-stone-004-top-left.png")
const BLOCK_STONE_TOP_RIGHT_TEXTURE = preload("res://sprites/brick-stone-004-top-right.png")
const BLOCK_STONE_BOTTOM_LEFT_TEXTURE = preload("res://sprites/brick-stone-004-bottom-left.png")
const BLOCK_STONE_BOTTOM_RIGHT_TEXTURE = preload("res://sprites/brick-stone-004-bottom-right.png")
const BLOCK_STONE_END_LEFT_TEXTURE = preload("res://sprites/brick-stone-005-left.png")
const BLOCK_STONE_END_RIGHT_TEXTURE = preload("res://sprites/brick-stone-005-right.png")
const BLOCK_STONE_END_TOP_TEXTURE = preload("res://sprites/brick-stone-005-top.png")
const BLOCK_STONE_END_BOTTOM_TEXTURE = preload("res://sprites/brick-stone-005-bottom.png")
const BLOCK_STONE_T_TOP_TEXTURE = preload("res://sprites/brick-stone-006-t-top.png")
const BLOCK_STONE_T_BOTTOM_TEXTURE = preload("res://sprites/brick-stone-006-t-bottom.png")
const BLOCK_STONE_T_LEFT_TEXTURE = preload("res://sprites/brick-stone-006-t-left.png")
const BLOCK_STONE_T_RIGHT_TEXTURE = preload("res://sprites/brick-stone-006-t-right.png")

const BLOCK_GLASS_TEXTURE = preload("res://sprites/brick-glass.png")
const BLOCK_10_001_TEXTURE = preload("res://sprites/brick-10-001.png")
const BLOCK_10_002_TEXTURE = preload("res://sprites/brick-10-002.png")
const BLOCK_10_003_TEXTURE = preload("res://sprites/brick-10-003.png")
const BLOCK_100_001_TEXTURE = preload("res://sprites/brick-100-001.png")
const BLOCK_100_002_TEXTURE = preload("res://sprites/brick-100-002.png")
const BLOCK_100_003_TEXTURE = preload("res://sprites/brick-100-003.png")
const BLOCK_1000_001_TEXTURE = preload("res://sprites/brick-1000-001.png")
const BLOCK_1000_002_TEXTURE = preload("res://sprites/brick-1000-002.png")
const BLOCK_1000_003_TEXTURE = preload("res://sprites/brick-1000-003.png")
const BLOCK_EXIT = preload("res://sprites/exit.png")

##
# Properties
var active = true
var bounds = Rect2(0, 0, 0, 0)
var matrix_block: MatrixBlock = null
var sprites = []
var sprites_scale = 1

func _ready():
	bounds = Rect2(
		Config.BLOCK_SIZE / -2, Config.BLOCK_SIZE / -2, 
		Config.BLOCK_SIZE, Config.BLOCK_SIZE
	)

func _process(delta):
	for sprite in self.sprites:
		sprite.scale.x = $Destroyable.target_scale
		sprite.scale.y = $Destroyable.target_scale
		sprite.scale *= self.sprites_scale
	
	if self.sprites.size() > 1:
		var i = 1
		for sprite in self.sprites:
			sprite.rotation += i * delta * 0.5
			i += PI / 16
			
func set_matrix_block(matrix_block: MatrixBlock):
	self.matrix_block = matrix_block
	
	for sprite in self.sprites:
		if sprite:
			sprite.queue_free()
	
	self.sprites = []
	
	if self.matrix_block.type == Config.BlockType.EXIT:
		$Destroyable/Particles.texture = BLOCK_EXIT
		self.add_to_group(Config.GROUP_BLOCK_EXIT)
		
		var sprite = Sprite.new()
		sprite.texture = BLOCK_EXIT
		self.sprites.append(sprite)
	elif self.matrix_block.type == Config.BlockType.STONE:
		self.add_to_group(Config.GROUP_BLOCK_STONE)
		var sprite = Sprite.new()
		
		if self.matrix_block.shape == Config.BlockShape.CLOSED:
			$Destroyable/Particles.texture = BLOCK_STONE_CLOSED_TEXTURE	
			sprite.texture = BLOCK_STONE_CLOSED_TEXTURE
		if self.matrix_block.shape == Config.BlockShape.CROSSED:
			$Destroyable/Particles.texture = BLOCK_STONE_CROSSED_TEXTURE	
			sprite.texture = BLOCK_STONE_CROSSED_TEXTURE
		if self.matrix_block.shape == Config.BlockShape.HORIZONTAL:
			$Destroyable/Particles.texture = BLOCK_STONE_LINE_TEXTURE	
			sprite.texture = BLOCK_STONE_LINE_TEXTURE
		if self.matrix_block.shape == Config.BlockShape.VERTICAL:
			$Destroyable/Particles.texture = BLOCK_STONE_LINE_TEXTURE	
			sprite.texture = BLOCK_STONE_LINE_TEXTURE
			sprite.rotation = PI / 2.0
		if self.matrix_block.shape == Config.BlockShape.TOP_LEFT:
			$Destroyable/Particles.texture = BLOCK_STONE_TOP_LEFT_TEXTURE	
			sprite.texture = BLOCK_STONE_TOP_LEFT_TEXTURE
		if self.matrix_block.shape == Config.BlockShape.TOP_RIGHT:
			$Destroyable/Particles.texture = BLOCK_STONE_TOP_RIGHT_TEXTURE	
			sprite.texture = BLOCK_STONE_TOP_RIGHT_TEXTURE
		if self.matrix_block.shape == Config.BlockShape.BOTTOM_LEFT:
			$Destroyable/Particles.texture = BLOCK_STONE_BOTTOM_LEFT_TEXTURE	
			sprite.texture = BLOCK_STONE_BOTTOM_LEFT_TEXTURE
		if self.matrix_block.shape == Config.BlockShape.BOTTOM_RIGHT:
			$Destroyable/Particles.texture = BLOCK_STONE_BOTTOM_RIGHT_TEXTURE	
			sprite.texture = BLOCK_STONE_BOTTOM_RIGHT_TEXTURE
		if self.matrix_block.shape == Config.BlockShape.T_TOP:
			$Destroyable/Particles.texture = BLOCK_STONE_T_TOP_TEXTURE	
			sprite.texture = BLOCK_STONE_T_TOP_TEXTURE
		if self.matrix_block.shape == Config.BlockShape.T_BOTTOM:
			$Destroyable/Particles.texture = BLOCK_STONE_T_BOTTOM_TEXTURE	
			sprite.texture = BLOCK_STONE_T_BOTTOM_TEXTURE
		if self.matrix_block.shape == Config.BlockShape.T_LEFT:
			$Destroyable/Particles.texture = BLOCK_STONE_T_LEFT_TEXTURE	
			sprite.texture = BLOCK_STONE_T_LEFT_TEXTURE
		if self.matrix_block.shape == Config.BlockShape.T_RIGHT:
			$Destroyable/Particles.texture = BLOCK_STONE_T_RIGHT_TEXTURE	
			sprite.texture = BLOCK_STONE_T_RIGHT_TEXTURE
		if self.matrix_block.shape == Config.BlockShape.END_TOP:
			$Destroyable/Particles.texture = BLOCK_STONE_END_TOP_TEXTURE	
			sprite.texture = BLOCK_STONE_END_TOP_TEXTURE
		if self.matrix_block.shape == Config.BlockShape.END_LEFT:
			$Destroyable/Particles.texture = BLOCK_STONE_END_LEFT_TEXTURE	
			sprite.texture = BLOCK_STONE_END_LEFT_TEXTURE
		if self.matrix_block.shape == Config.BlockShape.END_RIGHT:
			$Destroyable/Particles.texture = BLOCK_STONE_END_RIGHT_TEXTURE	
			sprite.texture = BLOCK_STONE_END_RIGHT_TEXTURE
		if self.matrix_block.shape == Config.BlockShape.END_BOTTOM:
			$Destroyable/Particles.texture = BLOCK_STONE_END_BOTTOM_TEXTURE	
			sprite.texture = BLOCK_STONE_END_BOTTOM_TEXTURE
				
		self.sprites.append(sprite)
		
	elif self.matrix_block.type == Config.BlockType.GLASS:
		$Destroyable/Particles.texture = BLOCK_GLASS_TEXTURE
		self.add_to_group(Config.GROUP_BLOCK_GLASS)
		
		var sprite = Sprite.new()
		sprite.texture = BLOCK_GLASS_TEXTURE
		self.sprites.append(sprite)
	
	elif self.matrix_block.type == Config.BlockType._10:
		$Destroyable/Particles.texture = BLOCK_10_002_TEXTURE
		self.add_to_group(Config.GROUP_BLOCK_10)
		
		var sprite1 = Sprite.new()
		var sprite2 = Sprite.new()
		var sprite3 = Sprite.new()
		sprite1.texture = BLOCK_10_001_TEXTURE
		sprite2.texture = BLOCK_10_002_TEXTURE
		sprite3.texture = BLOCK_10_003_TEXTURE
		self.sprites.append(sprite1)
		self.sprites.append(sprite2)
		self.sprites.append(sprite3)
	
	elif self.matrix_block.type == Config.BlockType._100:
		$Destroyable/Particles.texture = BLOCK_100_002_TEXTURE
		self.add_to_group(Config.GROUP_BLOCK_100)
		
		var sprite1 = Sprite.new()
		var sprite2 = Sprite.new()
		var sprite3 = Sprite.new()
		sprite1.texture = BLOCK_100_001_TEXTURE
		sprite2.texture = BLOCK_100_002_TEXTURE
		sprite3.texture = BLOCK_100_003_TEXTURE
		self.sprites.append(sprite1)
		self.sprites.append(sprite2)
		self.sprites.append(sprite3)
	
	elif self.matrix_block.type == Config.BlockType._1000:
		$Destroyable/Particles.texture = BLOCK_1000_002_TEXTURE
		self.add_to_group(Config.GROUP_BLOCK_1000)
		
		var sprite1 = Sprite.new()
		var sprite2 = Sprite.new()
		var sprite3 = Sprite.new()
		sprite1.texture = BLOCK_1000_001_TEXTURE
		sprite2.texture = BLOCK_1000_002_TEXTURE
		sprite3.texture = BLOCK_1000_003_TEXTURE
		self.sprites.append(sprite1)
		self.sprites.append(sprite2)
		self.sprites.append(sprite3)
	
	if self.matrix_block.type == Config.BlockType.NONE:
		$Collision.disabled = true
	else:
		if self.sprites.size() > 1:
			$Collision.shape = CircleShape2D.new()
			$Collision.shape.radius = Config.BLOCK_SIZE / 2 * 0.86
		else:
			$Collision.shape = RectangleShape2D.new()
			$Collision.shape.extents = Vector2(
				Config.BLOCK_SIZE / 2, Config.BLOCK_SIZE / 2
			)
	
	for sprite in self.sprites:
		self.sprites_scale = Vector2(Config.BLOCK_SIZE, Config.BLOCK_SIZE) / sprite.texture.get_size()
		$Destroyable/Particles.process_material.scale = 0.5 * self.sprites_scale.x
		add_child(sprite)
		
	# var label = Label.new()
	# label.text = self.matrix_block.label
	# label.rect_scale = Vector2(2, 2)
	# label.rect_position = Vector2(-100, 0)
	# self.add_child(label)
	
func destroy():
	self.matrix_block.alive = false
	$Collision.disabled = true
	
	if self.matrix_block.type == Config.BlockType.EXIT:
		$SoundWin.play()
	else:
		$Destroyable.die() 
		
		if self.matrix_block.type == Config.BlockType.GLASS:
			$SoundBreak.play()
		elif self.matrix_block.type == Config.BlockType._10:
			$SoundBreakGlass1.play()
		elif self.matrix_block.type == Config.BlockType._100:
			$SoundBreakGlass2.play()
		elif self.matrix_block.type == Config.BlockType._1000:
			$SoundBreakGlass2.play()
