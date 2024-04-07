extends CanvasLayer
class_name Stage1UI

@onready var animation_player = $AnimationPlayer
@onready var combo_label: Label = %ComboLabel
@onready var graze_label: Label = %GrazeLabel
@onready var high_score_label: Label = %HighScoreLabel
@onready var life_count_container: HBoxContainer = $LifeCountContainer
@onready var max_combo_label: Label = %MaxComboLabel
@onready var score_label: Label = %ScoreLabel
@onready var time_left_label: Label = %TimeLeftLabel


func update_graze_count(new_graze_count: int) -> void:
	graze_label.text = "Graze: " + str(new_graze_count)
	

func update_high_score(new_high_score: int) -> void:
	high_score_label.text = "%07d" % new_high_score
	

func update_score(new_score: int) -> void:
	score_label.text = "%07d" % new_score
	

func update_combo(new_combo: int) -> void:
	combo_label.text = "%02d" % new_combo
	

func harry_up() -> void:
	animation_player.play("harry_up")

func life_down() -> void:
	life_count_container.get_children()[0].queue_free()
	

func life_init(player_lives: int) -> void:
	for i in range(player_lives):
		var life_rect = ColorRect.new()
		life_rect.custom_minimum_size = Vector2(20, 40)
		life_count_container.add_child(life_rect)

func update_max_combo(new_max_combo: int) -> void:
	max_combo_label.text = "%02d" % new_max_combo
	

func update_time_left(new_time_left: float) -> void:
	time_left_label.text = "%04d" % round(new_time_left)
	
