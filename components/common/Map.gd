extends Node2D

##
# Constants
const MapCell = preload("res://components/common/MapCell.gd")

##
# Properties

var bounds = null
var bounds_outer = null
var cell_size = 10

func _draw():
	draw_rect(self.bounds_outer, Color(0.8, 0.8, 0.8, 0.75), true, 10, true)

func _ready():
	self.bounds = Rect2(
		Vector2(
			cell_size * 2, 
			Config.VIEWPORT_HEIGHT - cell_size * 
			Config.WORLD_HEIGHT - cell_size * 2
		), 
		Vector2(cell_size * Config.WORLD_WIDTH, cell_size * Config.WORLD_HEIGHT)
	)
	
	self.bounds_outer = Rect2(
		Vector2(
			cell_size, 
			Config.VIEWPORT_HEIGHT - cell_size * 
			Config.WORLD_HEIGHT - cell_size * 3
		), 
		Vector2(
			cell_size * Config.WORLD_WIDTH + cell_size * 2, 
			cell_size * Config.WORLD_HEIGHT + cell_size * 2
		)
	)
	
	$MapPlayer.cell_size = self.cell_size
	$MapPlayer.z_index = 10

func _process(delta):
	$MapPlayer.position = \
		self.bounds.position + \
		(
			Store.get_game_player_position() + 
			Vector2(Config.WORLD_WIDTH, Config.WORLD_HEIGHT) * 
			Config.BLOCK_SIZE / 2
		) * cell_size / Config.BLOCK_SIZE
	
	var matrix = Store.get_game_matrix()
	
	for i in matrix.height:
		for j in matrix.width:
			var block = Store.get_game_block(i, j)
			
			if block.type == Config.BlockType.EXIT:
				if not block.instance_mapped and Store.get_game_show_exit():
					var node = Node2D.new()
					node.position = self.bounds.position + Vector2(
						j * cell_size, i * cell_size
					) + Vector2(cell_size / 2, cell_size / 2)
					node.set_script(MapCell)
					node.cell_size = cell_size
					node.color = Color(0, 0, 1)
					node.exit = true
					self.add_child(node)
					block.instance_mapped = node
			else:
				var block_rect = Rect2(
					Vector2(
						j * Config.BLOCK_SIZE, 
						i * Config.BLOCK_SIZE
					) - 
					Vector2(
						Config.WORLD_WIDTH, Config.WORLD_HEIGHT
					) * Config.BLOCK_SIZE / 2,
					Vector2(
						Config.BLOCK_SIZE, 
						Config.BLOCK_SIZE
					)
				)
				
				var player_size = Config.BLOCK_SIZE * 0.15
				var player_rect = Rect2(
					(
						Store.get_game_player_position() - 
						Vector2(player_size, player_size) / 2
					),
					Vector2(player_size, player_size)
				)
				if block_rect.intersects(player_rect):
					block.visited = true
					
				if block.visited and not block.instance_mapped and not block.type == Config.BlockType.STONE:
					var node = Node2D.new()
					node.position = self.bounds.position + Vector2(
						j * cell_size, i * cell_size
					) + Vector2(cell_size / 2, cell_size / 2)
					node.set_script(MapCell)
					node.cell_size = cell_size
					node.modulate = Color(0.5, 0.5, 0.5)
					self.add_child(node)
					block.instance_mapped = node
