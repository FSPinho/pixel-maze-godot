extends StaticBody2D

const MatrixBlock = preload("res://types/MatrixBlock.gd")

const BLOCK_STONE_TEXTURE = preload("res://sprites/brick-stone.png")
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

##
# Properties
var active = true
var bounds = Rect2(0, 0, 0, 0)
var matrix_block: MatrixBlock = null
var sprites = []

func _ready():
	bounds = Rect2(
		Config.BLOCK_SIZE / -2, Config.BLOCK_SIZE / -2, 
		Config.BLOCK_SIZE, Config.BLOCK_SIZE
	)

func _process(delta):
	for sprite in self.sprites:
		sprite.scale.x = $Destroyable.target_scale
		sprite.scale.y = $Destroyable.target_scale
	
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
	
	if self.matrix_block.type == Config.BlockType.STONE:
		$Destroyable/Particles.texture = BLOCK_STONE_TEXTURE
		self.add_to_group(Config.GROUP_BLOCK_STONE)
		
		var sprite = Sprite.new()
		sprite.texture = BLOCK_STONE_TEXTURE
		self.sprites.append(sprite)
		
	if self.matrix_block.type == Config.BlockType.GLASS:
		$Destroyable/Particles.texture = BLOCK_GLASS_TEXTURE
		self.add_to_group(Config.GROUP_BLOCK_GLASS)
		
		var sprite = Sprite.new()
		sprite.texture = BLOCK_GLASS_TEXTURE
		self.sprites.append(sprite)
	
	if self.matrix_block.type == Config.BlockType._10:
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
	
	if self.matrix_block.type == Config.BlockType._100:
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
	
	if self.matrix_block.type == Config.BlockType._1000:
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
		
	$Destroyable/Particles.process_material.scale = 0.5
	
	if self.sprites.size() > 1:
		$Collision.shape = CircleShape2D.new()
		$Collision.shape.radius = Config.BLOCK_SIZE / 2 * 0.86
	else:
		$Collision.shape = RectangleShape2D.new()
		$Collision.shape.extents = Vector2(
			Config.BLOCK_SIZE / 2, Config.BLOCK_SIZE / 2
		)
	
	for sprite in self.sprites:
		add_child(sprite)
	
func destroy():
	self.matrix_block.alive = false
	$Collision.disabled = true
	$Destroyable.die() 
