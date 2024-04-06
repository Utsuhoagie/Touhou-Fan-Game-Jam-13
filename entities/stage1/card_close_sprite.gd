extends AnimatedSprite2D
class_name CardCloseSprite


func _on_timer_timeout() -> void:
	queue_free()
