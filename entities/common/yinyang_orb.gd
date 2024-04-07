extends CharacterBody2D
class_name YinyangOrb

var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var swing_bounce := 1150

@export var enable_bullets: bool

@onready var bounce_sfx: AudioStreamPlayer = $BounceSFX
@onready var floor: StaticBody2D = $"../Floor"
@onready var guns: Node2D = $Guns
@onready var gun_timer: Timer = $GunTimer
@onready var sprite: AnimatedSprite2D = $Sprite
@onready var stage = get_parent()

var orb_shot_preload = preload("res://entities/stage2/orb_shot.tscn")


func _ready() -> void:
	velocity = Vector2(-750, -750)
	if get_parent().name == "Stage2":
		velocity *= 0.5
	sprite.play("default")


func _physics_process(delta: float) -> void:
	velocity.y += gravity * delta

	var collision: KinematicCollision2D = (
		move_and_collide(velocity * delta)
	)
	if collision:
		var collider: Object = collision.get_collider()
		velocity = velocity.bounce(collision.get_normal())
		velocity *= 0.9

		bounce_sfx.play()
		if collider == floor:
			stage.combo = 0

	if enable_bullets and gun_timer.is_stopped():
		gun_timer.start()
		for gun in guns.get_children():
			var shot: OrbShot = orb_shot_preload.instantiate()
			get_tree().current_scene.add_child(shot)
			shot.global_position = gun.global_position

	sprite.flip_h = velocity.x > 0


func handle_player_swing(player_pos: Vector2) -> void:
	var pos_diff: Vector2 = position - player_pos
	var angle_radians: float = atan2(pos_diff.y, pos_diff.x)
	angle_radians = remap(angle_radians, -PI, 0, -PI * 0.875, -PI * 0.125)

	velocity = Vector2(
		swing_bounce * cos(angle_radians),
		swing_bounce * sin(angle_radians)
	)
	bounce_sfx.play()

