extends Area2D
class_name Player3Shot

const SPEED := 1200
const DAMAGE := 10

func _process(delta: float) -> void:
	position.y -= SPEED * delta


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()




func _on_body_entered(body: Node2D) -> void:
	if body is Komachi:
		var komachi: Komachi = body as Komachi

		komachi.take_damage(DAMAGE)
		queue_free()
