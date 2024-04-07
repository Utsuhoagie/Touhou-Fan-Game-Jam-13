extends KomachiBaseShot
class_name KomachiShotCoinBig

const BASE_SPEED := 360.0
var speed_multiplier: float = 1.0
var curve: float = 0.0
var current_curve: float = curve
var angle: float = 0.0


func _ready() -> void:
	body_entered.connect(on_body_entered)


func init(speed_multiplier: float, angle: float, curve: float = 0.0, color: Color = Color.WHITE) -> void:
	self.speed_multiplier = speed_multiplier
	self.angle = angle
	self.curve = curve
	randomize_color()


func _process(delta: float) -> void:
	var velocity: Vector2 = Vector2(0, BASE_SPEED * speed_multiplier)\
		.rotated(deg_to_rad(angle + current_curve))

	position += velocity * delta
	current_curve += curve
	rotation_degrees += curve + velocity.length() * delta * 0.3


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()


func on_body_entered(body: Node2D) -> void:
	if body is Player3:
		body.die()
