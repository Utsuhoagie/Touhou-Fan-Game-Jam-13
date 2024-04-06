extends KomachiBaseShot
class_name KomachiShotCoinBig

const BASE_SPEED := 360.0
var speed_multiplier: float = 1.0
var angle: float = 0.0


func init(speed_multiplier: float, angle: float, color: Color = Color.WHITE) -> void:
	self.speed_multiplier = speed_multiplier
	self.angle = angle
	randomize_color()


func _process(delta: float) -> void:
	var velocity: Vector2 = Vector2(0, BASE_SPEED * speed_multiplier)\
		.rotated(deg_to_rad(angle))

	position += velocity * delta


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
