extends Area2D
class_name Player1Shot

var speed := 1500
var shot_bounce := 625

func _process(delta) -> void:
	position.y -= speed * delta
	

func _on_body_entered(body) -> void:
	if body.get_name() == "YinyangOrb":
		var diff_x: float = body.position.x - position.x
		var angle_radians: float = remap(diff_x, -32, 32, -PI * 0.625, -PI * 0.375)
		body.velocity = Vector2(
			shot_bounce * cos(angle_radians),
			shot_bounce * sin(angle_radians)
		)
	
	queue_free()
	
