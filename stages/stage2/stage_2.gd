extends Node2D
class_name Stage2

@onready var dialog_player: DialogPlayer = $DialogPlayer
@onready var parsee: Node2D = $Parsee

var player_lives: int = 5
var high_score: int = 0
var score: int = 0
var graze_count: int = 0
var combo: int = 0
var max_combo: int = 0
var time_left: float = 3000.0

var blocks_remaining: int


func _ready():
	blocks_remaining = $Parsee/Blocks.get_child_count()
	get_tree().paused = false
	

func _process(delta):
	pass
