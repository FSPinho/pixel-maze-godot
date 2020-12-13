extends Node

const Matrix = preload("res://types/Matrix.gd")
const MatrixBlock = preload("res://types/MatrixBlock.gd")

##
#  Signals

signal on_game_start
signal on_game_end

##
# Properties

var game_state: int = Config.GameState.IDLE
var game_matrix: Matrix = null
var game_player_position: Vector2 = Vector2(0, 0)
var game_show_exit = false
var game_points = 0.0
var game_points_show_exit = 500.0

##
# Methods

func _init():
	Log.i("Initializing store")
	Log.i("DONE.\n", 2)
	
func start():
	Log.i("Starting game...")
	
	self.game_state = Config.GameState.PLAYING
	Log.i("Game state set to PLAYING.", 2)
	
	self.game_matrix = Matrix.new()
	Log.i("Created game matrix%s" % self.game_matrix.get_summary(), 2)
	
	self.game_player_position = Vector2(0, 0)
	Log.i("Updated player initial position.", 2)
	
	Log.i("Emitting game start signal.", 2)
	emit_signal("on_game_start")	
	
	Log.i("DONE.\n", 2)

func end():
	emit_signal("on_game_end", 2)

func set_game_state(state: int) -> void:
	self.game_state = state

func get_game_state() -> int:
	return self.game_state

func get_game_matrix() -> Matrix:
	return self.game_matrix

func get_game_block(i: int, j: int) -> MatrixBlock:
	return self.game_matrix.get_block(i, j)

func set_game_player_position(pos: Vector2) -> void:
	self.game_player_position = pos

func get_game_player_position() -> Vector2:
	return self.game_player_position

func set_game_show_exit(show_exit) -> void:
	self.game_show_exit = show_exit
	
func get_game_show_exit() -> bool:
	return self.game_show_exit

func add_game_points(points) -> void:
	self.game_points += points


