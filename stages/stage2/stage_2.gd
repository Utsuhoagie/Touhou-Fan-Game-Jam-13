extends Node2D
class_name Stage2

signal blocks_cleared

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
	blocks_remaining = $Parsee/ParseeBody/Blocks.get_child_count()
	await transition.fade_from_black()


func _process(delta):
	pass


func decrease_blocks(n: int) -> void:
	blocks_remaining -= 1
	if blocks_remaining <= 0:
		blocks_cleared.emit()


func life_down() -> void:
	print("life down")
	player_lives -= 1
	#stage_1_ui.life_down()

	if player_lives <= 0:
		get_tree().paused = true
		#game_over()
