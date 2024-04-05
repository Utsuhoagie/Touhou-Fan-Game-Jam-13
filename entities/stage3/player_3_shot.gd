extends Area2D
class_name Player3Shot

var speed := 1200

func _process(delta: float) -> void:
	position.y -= speed * delta


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
