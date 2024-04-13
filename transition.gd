extends AnimationPlayer
class_name Transition

@onready var transition_timer: Timer = $TransitionTimer

func fade_to_black() -> void:
	get_tree().paused = true
	play("fade_to_black")
	transition_timer.start()
	await transition_timer.timeout
	get_tree().paused = false


func fade_from_black() -> void:
	get_tree().paused = true
	play("fade_from_black")
	transition_timer.start()
	await transition_timer.timeout
	get_tree().paused = false

