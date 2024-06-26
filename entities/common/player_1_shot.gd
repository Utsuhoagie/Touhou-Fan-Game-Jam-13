extends Area2D
class_name Player1Shot

var speed := 1750
var shot_bounce := 625

func _process(delta: float) -> void:
	position.y -= speed * delta


func _on_body_entered(body: Node2D) -> void:
	if body.get_name() == "YinyangOrb":
		var diff_x: float = body.position.x - position.x
		var angle_radians: float = remap(diff_x, -32, 32, -PI * 0.625, -PI * 0.375)
		body.velocity = Vector2(
			shot_bounce * cos(angle_radians),
			shot_bounce * sin(angle_radians)
		)

		body.bounce_sfx.play()
		queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
