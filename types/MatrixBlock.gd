extends Node

var type: int = Config.BlockType.STONE
var shape: int = Config.BlockShape.CLOSED
var alive: bool = true
var visited: bool = false
var instance = null
var instance_mapped = null
var position = Vector2(0, 0)
var label = "Block"

func _init(type = Config.BlockType.STONE, alive = true):
	self.type = type
	self.alive = alive
