extends CharacterBody2D
class_name Parsee

var rotation_speed_radians: float = 0.5

const SPEED := 30.0
var x_bounds := [300, 1000]
var random_position: Vector2

@onready var blocks = $"Blocks"


func _physics_process(delta: float) -> void:
	blocks.rotation += rotation_speed_radians * delta

	#var target_position := random_position - global_position
	#velocity = target_position * SPEED * delta

	#move_and_slide()

	var direction: int
	if abs(random_position.x - global_position.x) <= 10.0:
		direction = 0
	else:
		direction = -1 if random_position.x < global_position.x else 1

	get_parent().global_position.x += direction * SPEED * delta




func _on_move_timer_timeout() -> void:
	random_position = Vector2(randi() % 700 + 300, global_position.y)
	print("random_position %s" % random_position)
