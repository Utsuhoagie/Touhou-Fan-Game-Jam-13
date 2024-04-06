extends KomachiBaseShot
class_name KomachiShotCoinMedium

const BASE_SPEED := 900.0
const MIN_SPEED := 160.0
const DECELERATION := 0.018
var speed_multiplier: float = 1.0
var angle: float = 0.0


func _ready() -> void:
	body_entered.connect(on_body_entered)


func init(angle: float, color: Color = Color.WHITE) -> void:
	self.angle = angle
	randomize_color()


func _process(delta: float) -> void:
	var current_speed := clampf(BASE_SPEED * speed_multiplier, MIN_SPEED, BASE_SPEED)
	var velocity: Vector2 = Vector2(0, current_speed).rotated(deg_to_rad(angle))

	position += velocity * delta

	if current_speed == BASE_SPEED * speed_multiplier:
		speed_multiplier -= DECELERATION


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()


func on_body_entered(body: Node2D) -> void:
	if body is Player3:
		body.die()
