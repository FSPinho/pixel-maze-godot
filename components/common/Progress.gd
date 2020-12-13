extends Node2D

##
# Constants

var PROGRESS_TEXTURE = preload("res://sprites/progress.png") 
var BLOCK_TEXTURE = preload("res://sprites/brick-1000-002.png") 
var EXIT_TEXTURE = preload("res://sprites/exit.png") 

##
# Properties

var sprite_progress_left: Sprite = null
var sprite_progress_right: Sprite = null
var sprite_progress_middle: Sprite = null

var progress = 0

func _ready():
	var sprite_base_scale = 0.25
	var sprite_scale = Config.VIEWPORT_WIDTH * sprite_base_scale / PROGRESS_TEXTURE.get_width()
	var sprite_size = PROGRESS_TEXTURE.get_size()
	var sprite_size_scaled = PROGRESS_TEXTURE.get_size() * sprite_scale
	
	##
	# Left
	
	self.sprite_progress_left = Sprite.new()
	self.sprite_progress_left.texture = PROGRESS_TEXTURE
	self.sprite_progress_left.scale = Vector2(sprite_scale, sprite_scale)
	self.sprite_progress_left.position = Vector2(
		sprite_size_scaled.x / 4, 
		sprite_size_scaled.y / 2
	)
	self.sprite_progress_left.region_enabled = true
	self.sprite_progress_left.region_rect = Rect2(0, 0, sprite_size.x / 2, sprite_size.y)
	
	##
	# Right
	
	self.sprite_progress_right = Sprite.new()
	self.sprite_progress_right.texture = PROGRESS_TEXTURE
	self.sprite_progress_right.scale = Vector2(sprite_scale, sprite_scale)
	self.sprite_progress_right.position = Vector2(
		Config.VIEWPORT_WIDTH - sprite_size_scaled.x / 4, 
		sprite_size_scaled.y / 2
	)
	self.sprite_progress_right.region_enabled = true
	self.sprite_progress_right.region_rect = Rect2(sprite_size.x / 2, 0, sprite_size.x / 2, sprite_size.y)
	
##
	# Center
	
	self.sprite_progress_middle = Sprite.new()
	self.sprite_progress_middle.texture = PROGRESS_TEXTURE
	self.sprite_progress_middle.scale = Vector2(sprite_scale * sprite_base_scale * 24, sprite_scale)
	self.sprite_progress_middle.position = Vector2(
		Config.VIEWPORT_WIDTH / 2, 
		sprite_size_scaled.y / 2
	)
	self.sprite_progress_middle.region_enabled = true
	self.sprite_progress_middle.region_rect = Rect2(sprite_size.x / 4, 0, sprite_size.x / 2, sprite_size.y)
	

	self.add_child(self.sprite_progress_left)
	self.add_child(self.sprite_progress_right)
	self.add_child(self.sprite_progress_middle)
	
	self.scale = Vector2(0.95, 0.95)
	self.position.x = Config.VIEWPORT_WIDTH * (1.0 - 0.95) / 2
	self.position.y = position.x
	
	$Bar.position = Vector2(self.position.x * sprite_base_scale * 5, 0)
	$Bar.position.y = sprite_size_scaled.y / 3.85
	$Bar.scale.y = sprite_base_scale * 280
	$Bar.scale.x = 0
	$Bar.width = Config.VIEWPORT_WIDTH - self.position.x * 1.25 * 2
	$Bar.color = Color("#2196F3")

	$BarBG.position = Vector2(self.position.x * sprite_base_scale * 5, 0)
	$BarBG.position.y = sprite_size_scaled.y / 3.85
	$BarBG.scale.y = sprite_base_scale * 280
	$BarBG.scale.x = 1
	$BarBG.width = Config.VIEWPORT_WIDTH - self.position.x * 1.25 * 2
	$BarBG.color = Color(1, 1, 1, 1)

	$Label.rect_scale = Vector2(1, 1)
	$Label.rect_position.y = sprite_size_scaled.y / 3.8
	
	$Star.texture = BLOCK_TEXTURE
	$Star.scale = Vector2(0.1, 0.1)
	$Star.position = Vector2(self.position.x * 2.5, self.position.y * 2.5)
	
	$Exit.texture = EXIT_TEXTURE
	$Exit.scale = Vector2(0.1, 0.1)
	$Exit.position = Vector2(
		Config.VIEWPORT_WIDTH - self.position.x * 2.5, 
		self.position.y * 2.5
	)
	
func _process(delta):
	var progress = min(Store.game_points / Store.game_points_show_exit, 1)
	self.progress = min(self.progress + 1 * delta, progress)
	
	$Bar.scale.x = self.progress
	
	$Label.text = "%d/%d" % [Store.game_points, Store.game_points_show_exit]
	$Label.rect_position = Vector2(
		Config.VIEWPORT_WIDTH / 2 - $Label.rect_size.x / 2, 
		$Label.rect_position.y
	)
	
	$Star.rotation = Util.animate($Star.rotation, 0, PI * 2, PI / 4, delta, true)



