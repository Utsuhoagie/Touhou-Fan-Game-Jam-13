extends KomachiBaseShot
class_name KomachiShotStraight

const BASE_SPEED := 450.0
var speed_multiplier: float = 1.0
var angle: float = 0.0


func _ready() -> void:
	body_entered.connect(on_body_entered)


func init(speed_multiplier: float, angle: float) -> void:
	self.speed_multiplier = speed_multiplier
	self.angle = angle
	sprite.global_rotation_degrees = angle + 180.0


func _process(delta: float) -> void:
	var velocity: Vector2 = Vector2(0, BASE_SPEED * speed_multiplier)\
		.rotated(deg_to_rad(angle))

	position += velocity * delta


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()


func on_body_entered(body: Node2D) -> void:
	if body is Player3:
		body.die()
