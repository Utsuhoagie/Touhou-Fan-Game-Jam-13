extends Node2D
class_name Stage1

@onready var stage_1_ui: Stage1UI = $Stage1UI

var score: int = 0
var graze_count: int = 0
var combo: int = 0
var max_combo: int = 0


func _ready():
	pass
	

func _process(delta):
	if combo > max_combo:
		max_combo = combo
	
	stage_1_ui.update_score(score)
	stage_1_ui.update_graze_count(graze_count)
	stage_1_ui.update_combo(combo)
	stage_1_ui.update_max_combo(max_combo)
	
