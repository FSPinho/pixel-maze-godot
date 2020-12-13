extends Node

##
# Constants

const PlayerScene = preload("res://components/common/Player.tscn")
const Player_ = preload("res://components/common/Player.gd")
const WorldScene = preload("res://components/common/World.tscn")
const World_ = preload("res://components/common/World.gd")

##
# Properties
var player: Player_ = null
var world: World_ = null

func _ready():
	Store.connect("on_game_start", self, "on_game_start")
	Store.connect("on_game_end", self, "on_game_end")
	Store.start()
	
func on_game_start():
	Log.i("Game - Starting game...", 2)
	
	self.world = WorldScene.instance()
	self.add_child(self.world)
	Log.i("Game - World created...", 3)

	self.player = PlayerScene.instance()
	self.player.position = Store.game_player_position
	self.world.add_child(player)	
	Log.i("Game - Player created...", 3)

func on_game_end():
	pass
