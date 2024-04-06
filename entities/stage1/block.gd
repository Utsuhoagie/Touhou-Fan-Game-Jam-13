extends StaticBody2D
class_name Block

@export var hp := 1

@onready var stage_1: Stage1 = get_parent()

var score_label_preload = preload("res://entities/stage1/score_label.tscn")

func _on_area_2d_body_entered(_body: Node2D):
	hp -= 1
	if hp == 0:
		stage_1.combo += 1
		var score: int = 200 * stage_1.combo
		stage_1.score += score
		
		var score_label: ScoreLabel = score_label_preload.instantiate()
		score_label.text = str(score)
		score_label.global_position = global_position
		stage_1.add_child(score_label)
		
		stage_1.blocks_remaining -= 1
		queue_free()
	
