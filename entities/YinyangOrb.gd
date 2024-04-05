extends CharacterBody2D

@export var swing_bounce: float = 500.0

@onready var sprite_2d = $Sprite2D

var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready() -> void:
	velocity = Vector2(-500, -500)

func _physics_process(delta: float) -> void:
	velocity.y += gravity * delta
	var collision: KinematicCollision2D = (
		move_and_collide(velocity * delta)
	)
	
	if collision:
		velocity = velocity.bounce(collision.get_normal())
		velocity.y *= 0.9
	
	sprite_2d.flip_h = velocity.x < 0

func handle_player_swing(player_pos: Vector2) -> void:
	var pos_diff: Vector2 = position - player_pos
	
	velocity = Vector2(swing_bounce * (pos_diff.x / 50), swing_bounce)
