extends CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready() -> void:
	velocity.x = 200

func _physics_process(delta: float) -> void:
	velocity.y += gravity * delta
	
	var collision: KinematicCollision2D = (
		move_and_collide(velocity * delta)
	)
	
	if collision:
		velocity = velocity.bounce(collision.get_normal())
