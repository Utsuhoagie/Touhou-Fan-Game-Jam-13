extends Node2D
class_name Stage1

@onready var stage_1_ui: Stage1UI = $Stage1UI

var score: int = 0
var graze_count: int = 0
var combo: int = 0
var max_combo: int = 0

var all_cards_turned: bool = false
var blocks_remaining: int


func _ready() -> void:
	blocks_remaining = get_tree().get_nodes_in_group("blocks").size()
	

func _process(_delta: float) -> void:
	if combo > max_combo:
		max_combo = combo
	
	stage_1_ui.update_score(score)
	stage_1_ui.update_graze_count(graze_count)
	stage_1_ui.update_combo(combo)
	stage_1_ui.update_max_combo(max_combo)
	
	if blocks_remaining == 0 and all_cards_turned:
		print("stage 1 complete")
	
