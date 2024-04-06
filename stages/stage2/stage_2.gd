extends Node2D
class_name Stage2

@onready var dialog_player: DialogPlayer = $DialogPlayer

var player_lives: int = 5
var high_score: int = 0
var score: int = 0
var graze_count: int = 0
var combo: int = 0
var max_combo: int = 0
var time_left: float = 3000.0


func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
