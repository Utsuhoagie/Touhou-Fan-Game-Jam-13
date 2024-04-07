extends Node2D
class_name Stage2

@onready var dialog_player: DialogPlayer = $DialogPlayer
@onready var parsee: Node2D = $Parsee
@onready var transition: Transition = $Transition

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
	await transition.fade_from_black()
	

func _process(delta):
	pass
