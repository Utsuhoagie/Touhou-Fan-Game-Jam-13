extends Area2D
class_name ParseeSt2Shot


const BASE_SPEED := 330.0
const BASE_DECELERATION := 1.0
var deceleration := BASE_DECELERATION
var angle: float = 0.0
var new_angle: float
var speed_modifier := 1.2

@onready var sprite: Sprite2D = $Sprite


func _ready() -> void:
	area_entered.connect(on_area_entered)


func init(angle: float, new_angle: float) -> void:
	self.angle = angle
	self.new_angle = new_angle
	sprite.global_rotation_degrees = angle + 180.0


func _process(delta: float) -> void:
	var velocity: Vector2 = Vector2(0, BASE_SPEED)\
		.rotated(deg_to_rad(angle))

	# Phase 1
	velocity *= deceleration
	deceleration = clampf(deceleration - 0.01, 0.5, 1.0)

	position += velocity * speed_modifier * delta


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()


func on_area_entered(area: Area2D) -> void:
	if area is Player1:
		area.die()


func _on_timer_timeout() -> void:
	angle = new_angle
	sprite.global_rotation_degrees = angle + 180.0
	deceleration = BASE_DECELERATION
	speed_modifier = 1.0
