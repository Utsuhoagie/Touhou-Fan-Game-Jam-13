extends Label
class_name ScoreLabel

@onready var score_display_timer = $ScoreDisplayTimer

var scroll_speed := 50


func _process(delta: float):
	position.y += scroll_speed * delta
	
	if score_display_timer.is_stopped():
		queue_free()
	
