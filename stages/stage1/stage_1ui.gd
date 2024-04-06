extends CanvasLayer
class_name Stage1UI

@onready var score_label = %ScoreLabel
@onready var graze_label = %GrazeLabel
@onready var combo_label = %ComboLabel
@onready var max_combo_label = %MaxComboLabel


func update_graze_count(new_graze_count: int):
	graze_label.text = "Graze: " + str(new_graze_count)
	

func update_score(new_score: int):
	score_label.text = "Score: " + str(new_score)
	

func update_combo(new_combo: int):
	combo_label.text = "Combo: " + str(new_combo)
	

func update_max_combo(new_max_combo: int):
	max_combo_label.text = "MaxCombo: " + str(new_max_combo)
	
