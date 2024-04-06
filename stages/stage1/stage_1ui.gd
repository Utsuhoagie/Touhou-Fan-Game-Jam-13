extends CanvasLayer
class_name Stage1UI

@onready var combo_label = %ComboLabel
@onready var graze_label = %GrazeLabel
@onready var high_score_label = %HighScoreLabel
@onready var max_combo_label = %MaxComboLabel
@onready var score_label = %ScoreLabel
@onready var time_left_label = %TimeLeftLabel


func update_graze_count(new_graze_count: int):
	graze_label.text = "Graze: " + str(new_graze_count)
	

func update_high_score(new_high_score: int):
	high_score_label.text = "%07d" % new_high_score
	

func update_score(new_score: int):
	score_label.text = "%07d" % new_score
	

func update_combo(new_combo: int):
	combo_label.text = "%02d" % new_combo
	

func update_max_combo(new_max_combo: int):
	max_combo_label.text = "%02d" % new_max_combo
	

func update_time_left(new_time_left: float):
	time_left_label.text = "%04d" % round(new_time_left)
	
