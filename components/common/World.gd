extends StaticBody2D

##
# Constants
const Block = preload("res://components/common/Block.tscn")
const MatrixBlock = preload("res://types/MatrixBlock.gd")

##
# Properties
var bounds = Rect2(0, 0, 0, 0)
var position_offset = Vector2(0, 0)
var collision_width = 96
var radar_block_size = 4
var update_delay = 1.0
var update_elapsed = 0.0
var process_half_delay = 0.5
var process_half_elapsed = 0.5

func _draw():
	draw_rect(
		bounds, 
		"#222", true, 0, true
	)
	
func _physics_process(delta):
	var target = Store.get_game_player_position()
	self.position = target * -1 + position_offset
	$Background.position = target * 0.4
	
func _process(delta):	
	process_half_elapsed += delta
	if process_half_elapsed >= process_half_delay:
		process_half_elapsed = 0.0
		_process_half()
	
func _process_half():
	for i in range(Config.WORLD_HEIGHT):
		for j in range(Config.WORLD_WIDTH):
			var matrix_block = Store.get_game_block(i, j)
			var position = matrix_block.position
			var position_real = position + self.position
			
			matrix_block.instance
			var is_out = \
				position_real.x < -Config.BLOCK_SIZE * 2 or \
				position_real.y < -Config.BLOCK_SIZE * 2 or \
				position_real.x > Config.VIEWPORT_WIDTH + Config.BLOCK_SIZE * 2 or \
				position_real.y > Config.VIEWPORT_HEIGHT + Config.BLOCK_SIZE * 2
			
			if is_out: 
				if matrix_block.instance:
					matrix_block.instance.queue_free()
					matrix_block.instance = null
			else:
				if not matrix_block.instance and matrix_block.alive:
					var block = create_block(position, matrix_block)
					matrix_block.instance = block
					add_child(block)

func _ready():
	var w = Config.BLOCK_SIZE * Config.WORLD_WIDTH
	var h = Config.BLOCK_SIZE * Config.WORLD_HEIGHT
	
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
	$Background/Texture.rect_position = bounds.position
	$Background/Texture.rect_size = bounds.size
	
	self.position_offset = Vector2(
		Config.VIEWPORT_WIDTH / 2,
		Config.VIEWPORT_HEIGHT / 2
	)

func create_block(position, matrix_block: MatrixBlock):
	randomize()
	
	var rand = randi() % 10
	var type = Config.BlockType.STONE
	
	if rand == 0:
		type = Config.BlockType.GLASS
	
	var block = Block.instance()
	block.set_position(position)
	block.set_matrix_block(matrix_block)
	return block

