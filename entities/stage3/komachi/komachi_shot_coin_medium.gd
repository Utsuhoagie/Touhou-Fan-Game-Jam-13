extends Area2D
class_name KomachiShotCoinMedium

const BASE_SPEED := 900.0
const MIN_SPEED := 160.0
const DECELERATION := 0.018
var speed_multiplier: float = 1.0
var angle: float = 0.0

@onready var sprite: AnimatedSprite2D = $Sprite
@onready var collision: CollisionShape2D = $Collision


func init(angle: float) -> void:
	self.angle = angle


func _process(delta: float) -> void:
	var current_speed := clampf(BASE_SPEED * speed_multiplier, MIN_SPEED, BASE_SPEED)
	var velocity: Vector2 = Vector2(0, current_speed).rotated(deg_to_rad(angle))

	position += velocity * delta

	if current_speed == BASE_SPEED * speed_multiplier:
		speed_multiplier -= DECELERATION


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
