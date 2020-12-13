extends Node

var type: int = Config.BlockType.STONE
var alive: bool = true
var visited: bool = false
var instance = null
var instance_mapped = null

func _init(type = Config.BlockType.STONE, alive = true):
	self.type = type
	self.alive = alive
	self.visited = false
	self.instance = null
	self.instance_mapped = false
