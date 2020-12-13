extends Node

var type: int = Config.BlockType.STONE
var alive: bool = true
var instance = null

func _init(type = Config.BlockType.STONE, alive = true):
	self.type = type
	self.alive = alive
	self.instance = null
