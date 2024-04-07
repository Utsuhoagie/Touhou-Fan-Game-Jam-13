extends CharacterBody2D
class_name Parsee

var rotation_speed_radians: float = 0.5

const SPEED := 30.0
var x_bounds := [300, 1000]
var random_position: Vector2

@onready var blocks = $"Blocks"
@onready var sprite = $"Sprite"

const SHOT_ANGLE_OFFSET_BASE := 4.5
@onready var ring_timer: Timer = $"Ring Timer"
@onready var gap_timer: Timer = $"Gap Timer"
@onready var ring_guns: Node2D = $"Ring Guns"

var parsee_st2_shot_preload := preload ("res://entities/stage2/parsee_st2_shot.tscn")

func _physics_process(delta: float) -> void:
	blocks.rotation += rotation_speed_radians * delta

	var direction: int
	if abs(random_position.x - global_position.x) <= 10.0:
		direction = 0
	else:
		direction = -1 if random_position.x < global_position.x else 1

	get_parent().global_position.x += direction * SPEED * delta

	match direction:
		- 1:
			sprite.play("left")
		0:
			sprite.play("idle")
		1:
			sprite.play("right")

func _process(delta: float) -> void:
	if ring_timer.is_stopped():
		ring_timer.start()
		ring_guns.global_rotation_degrees += 30.0

	if not ring_timer.is_stopped():
		var ring_guns_count: int = ring_guns.get_child_count()
		var wait_time: float = ring_timer.wait_time
		var time_left: float = ring_timer.time_left
		var interval: float = wait_time / ring_guns_count

		if gap_timer.is_stopped() and time_left / wait_time >= 0.7:
			gap_timer.start()

			for gun_ in ring_guns.get_children():
				var gun: Node2D = gun_ as Node2D
				for i in range(4):
					var shot: ParseeSt2Shot = parsee_st2_shot_preload.instantiate() as ParseeSt2Shot
					get_tree().current_scene.add_child(shot)

					var shot_angle_offset := SHOT_ANGLE_OFFSET_BASE * (i - 1.5)
					#var shot_angle_offset := 0.0
					shot.init(
						gun.global_rotation_degrees - shot_angle_offset * 1.5,
						gun.global_rotation_degrees + shot_angle_offset * 1.5
					)
					shot.global_position = gun.global_position

func _on_move_timer_timeout() -> void:
	random_position = Vector2(randi() % 700 + 300, global_position.y)
