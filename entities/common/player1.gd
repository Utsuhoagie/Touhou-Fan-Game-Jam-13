extends Area2D
class_name Player1

var speed := 500

@onready var stage = get_tree().current_scene
@onready var death_timer: Timer = $DeathTimer
@onready var invincible_timer: Timer = $InvincibleTimer
@onready var graze_area: Area2D = $GrazeArea
@onready var gun: Node2D = $Gun
@onready var gun_timer: Timer = $GunTimer
@onready var sprite: AnimatedSprite2D = $Sprite
@onready var swing_collision_area: Area2D = $SwingCollisionArea
@onready var swing_cooldown_timer: Timer = $SwingCooldownTimer
@onready var yinyang_orb: YinyangOrb = $"../YinyangOrb"
@onready var swing_sfx: AudioStreamPlayer = $SwingSFX

var shot_preload = preload("res://entities/common/player_1_shot.tscn")
var player_size: Vector2i
var viewport_size: Vector2i


func _ready() -> void:
	player_size = $GrazeArea/CollisionShape2D.shape.get_rect().size
	viewport_size = get_viewport().size


func _physics_process(delta: float) -> void:
	if not death_timer.is_stopped(): return

	var input_map: float = Input.get_axis("player_left", "player_right")
	handle_movement(input_map, delta)

	if (Input.is_action_just_pressed("player_swing")
	and swing_cooldown_timer.is_stopped()):
		swing_cooldown_timer.start()
		swing_sfx.play()

		if swing_collision_area.overlaps_body(yinyang_orb):
			yinyang_orb.handle_player_swing(position)

	handle_shoot()

	if (overlaps_body(yinyang_orb) and death_timer.is_stopped()
	and invincible_timer.is_stopped()):
		die()

	update_animations(input_map)


func die() -> void:
	death_timer.start()
	await death_timer.timeout

	stage.life_down()
	invincible_timer.start()


func _on_graze_area_body_exited(_body: Node2D):
	if not death_timer.is_stopped() or not invincible_timer.is_stopped():
		return

	stage.graze_count += 1
	stage.score += 1000


func handle_movement(input_map: float, delta: float) -> void:
	position.x += input_map * speed * delta
	position.x = clampf(
		position.x,
		player_size.x / 2,
		viewport_size.x - (player_size.x / 2)
	)
	

func handle_shoot() -> void:
	if Input.is_action_pressed("player_shoot") and gun_timer.is_stopped():
		gun_timer.start()

		var shot: Player1Shot = shot_preload.instantiate()
		get_tree().current_scene.add_child(shot)
		shot.global_position = gun.global_position
	

func update_animations(input_map: float) -> void:
	if not death_timer.is_stopped():
		sprite.play("die")
	elif not invincible_timer.is_stopped():
		sprite.play("invincible")
	elif not swing_cooldown_timer.is_stopped():
		sprite.play("swing")
	elif input_map > 0:
		sprite.play("right")
	elif input_map < 0:
		sprite.play("left")
	else:
		sprite.play("idle")

