extends CanvasLayer
class_name Stage2UI

@onready var graze_label = %GrazeLabel
@onready var high_score_label = %HighScoreLabel
@onready var life_count_container = $LifeCountContainer
@onready var score_label = %ScoreLabel
@onready var time_left_label = %TimeLeftLabel


func update_graze(new_graze: int) -> void:
	graze_label.text = "%02d" % new_graze
	

func update_high_score(new_high_score: int) -> void:
	high_score_label.text = "%07d" % new_high_score
	

func update_score(new_score: int) -> void:
	score_label.text = "%07d" % new_score
	

func update_time_left(new_time_left: float) -> void:
	time_left_label.text = "%04d" % round(new_time_left)
	

func life_down() -> void:
	life_count_container.get_children()[0].queue_free()
	

func life_init(player_lives: int) -> void:
	for i in range(player_lives):
		var life_rect = ColorRect.new()
		life_rect.custom_minimum_size = Vector2(20, 40)
		life_count_container.add_child(life_rect)
