extends Node

##
# Constants

const APP_NAME = "Pixel Maze"
var VIEWPORT_WIDTH = max(OS.get_window_size().x, 1080)
var VIEWPORT_HEIGHT = max(OS.get_window_size().y, 1920)

const BLOCK_SIZE = 560.0
const BLOCK_GLASS_PERCENT = 0.25
const BLOCK_10_PERCENT = 0.1
const BLOCK_100_PERCENT = 0.05
const BLOCK_1000_PERCENT = 0.025
const WORLD_WIDTH = 21
const WORLD_HEIGHT = 21

const CIRCLE_QUALITY = 64

const GROUP_PLAYER = "g-player"
const GROUP_BLOCK_STONE = "g-block-stone"
const GROUP_BLOCK_GLASS = "g-block-glass"
const GROUP_BLOCK_10 = "g-block-10"
const GROUP_BLOCK_100 = "g-block-100"
const GROUP_BLOCK_1000 = "g-block-1000"
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
	STONE = 1,
	GLASS = 2,
	_10 = 3,
	_100 = 4,
	_1000 = 5,
}

enum GameState {
	IDLE = 0
	PLAYING = 1,
}
