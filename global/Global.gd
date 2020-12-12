extends Node

var APP_NAME = "Pixel Maze"
var VIEWPORT_WIDTH = 1080.0
var VIEWPORT_HEIGHT = 1920.0
var BLOCK_SIZE = 560.0
var CIRCLE_QUALITY = 64

var GROUP_RIPPLE = "g-ripples"
var GROUP_ENEMY = "g-enemies"

enum SwipeDirection {
	SWIPE_UP = 1,
	SWIPE_DOWN = 2,
	SWIPE_LEFT = 3,
	SWIPE_RIGHT = 4,
}

enum BlockType {
	STONE = 1,
	GLASS = 2,
	TEN = 3,
	HUNDRED = 4,
	THOUSAND = 5,
}
