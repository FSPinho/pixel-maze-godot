extends Node

##
# Constants

const APP_NAME = "Pixel Maze"
var VIEWPORT_WIDTH = max(OS.get_window_size().x, 1080)
var VIEWPORT_HEIGHT = max(OS.get_window_size().y, 1920)

const BLOCK_SIZE = 560.0 * 0.45
const BLOCK_GLASS_PERCENT = 0.2
const BLOCK_10_PERCENT = 0.018
const BLOCK_100_PERCENT = 0.0058
const BLOCK_1000_PERCENT = 0.00258
const WORLD_WIDTH = 11
const WORLD_HEIGHT = 11

const CIRCLE_QUALITY = 64

const GROUP_PLAYER = "g-player"
const GROUP_BLOCK_STONE = "g-block-stone"
const GROUP_BLOCK_GLASS = "g-block-glass"
const GROUP_BLOCK_10 = "g-block-10"
const GROUP_BLOCK_100 = "g-block-100"
const GROUP_BLOCK_1000 = "g-block-1000"
const GROUP_BLOCK_EXIT = "g-block-exit"
const GROUP_RIPPLE = "g-ripples"
const GROUP_ENEMY = "g-enemies"

##
# Enums

enum SwipeDirection {
	SWIPE_UP = 1,
	SWIPE_DOWN = 2,
	SWIPE_LEFT = 3,
	SWIPE_RIGHT = 4,
}

enum BlockType {
	NONE = 0
	EXIT = 1
	STONE = 2,
	GLASS = 3,
	_10 = 4,
	_100 = 5,
	_1000 = 6,
}

enum BlockShape {
	CLOSED = 1
	CROSSED = 2
	TOP_LEFT = 3
	TOP_RIGHT = 4
	BOTTOM_LEFT = 5
	BOTTOM_RIGHT = 6
	T_TOP = 7
	T_LEFT = 8
	T_RIGHT = 9
	T_BOTTOM = 10
	VERTICAL = 11
	HORIZONTAL = 12
	END_TOP = 13
	END_LEFT = 14
	END_RIGHT = 15
	END_BOTTOM = 16
}

enum GameState {
	IDLE = 0
	PLAYING = 1,
}
