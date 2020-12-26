extends Node

var type: int = Config.BlockType.STONE
var alive: bool = true
var visited: bool = false
var instance = null
var instance_mapped = null
var exit = false
var position = Vector2(0, 0)

func _init(type = Config.BlockType.STONE, alive = true):
	self.type = type
	self.alive = alive
