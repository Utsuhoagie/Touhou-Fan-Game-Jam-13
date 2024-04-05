extends Area2D
class_name Player1

var speed := 500

@onready var gun: Node2D = $Gun
@onready var gun_timer: Timer = $GunTimer
@onready var hitbox: CollisionShape2D = $Hitbox
@onready var swing_collision_area: Area2D = $SwingCollisionArea
@onready var swing_cooldown_timer: Timer = $SwingCooldownTimer
@onready var yinyang_orb: YinyangOrb = $"../YinyangOrb"

var shot_preload = preload("res://entities/stage1/player_1_shot.tscn")
var player_size: Vector2i
var viewport_size: Vector2i


func _ready() -> void:
	player_size = hitbox.shape.get_rect().size
	viewport_size = get_viewport().size
	

func _physics_process(delta: float) -> void:
	var input_map: float = Input.get_axis("player_left", "player_right")
	handle_movement(input_map, delta)
	
	if (Input.is_action_just_pressed("player_swing")
	and swing_collision_area.has_overlapping_bodies()
	and swing_cooldown_timer.is_stopped()):
		yinyang_orb.handle_player_swing(position)
	
	handle_shoot()
	
	#if has_overlapping_bodies():
		#die()
		
	update_animations()
	

func die() -> void:
	print("oofs")
	

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
	

func update_animations() -> void:
	#if velocity.x != 0:
		#move animation
	pass
	
