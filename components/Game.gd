extends Node

##
# Constants

const PlayerScene = preload("res://components/common/Player.tscn")
const Player_ = preload("res://components/common/Player.gd")
const WorldScene = preload("res://components/common/World.tscn")
const World_ = preload("res://components/common/World.gd")
const MapScene = preload("res://components/common/Map.tscn")
const Map_ = preload("res://components/common/Map.gd")
const ProgressScene = preload("res://components/common/Progress.tscn")
const Progress_ = preload("res://components/common/Progress.gd")

##
# Properties
var player: Player_ = null
var world: World_ = null
var map: Map_ = null
var progress: Progress_ = null

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
	self.world.add_child(self.player)	
	Log.i("Game - Player created...", 3)
	
	self.map = MapScene.instance()
	self.add_child(self.map)	
	Log.i("Game - Map created...", 3)
	
	self.progress = ProgressScene.instance()
	self.add_child(self.progress)	
	Log.i("Game - Progress created...", 3)
	
func on_game_end():
	pass
