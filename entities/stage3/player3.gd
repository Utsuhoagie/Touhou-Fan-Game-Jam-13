extends CharacterBody2D
class_name Player3

var speed := 36000.0
var focus_slowdown := 0.5

@onready var sprite: AnimatedSprite2D = $Sprite
@onready var hitbox: CollisionShape2D = $Hitbox
@onready var actual_hitbox_sprite: AnimatedSprite2D = $ActualHitboxSprite

@onready var gun_timer: Timer = $GunTimer
@onready var guns: Node2D = $Guns

var player3_shot_preload = preload("res://entities/stage3/player_3_shot.tscn")


func _ready() -> void:
	sprite.play("default")
	actual_hitbox_sprite.visible = false


func _process(delta: float) -> void:
	handle_movement(delta)
	handle_shoot(delta)
	move_and_slide()


func handle_movement(delta: float) -> void:
	var x_dir := Input.get_axis("player_left", "player_right")
	var y_dir := Input.get_axis("player_up", "player_down")

	velocity = Vector2(x_dir * speed, y_dir * speed) * delta

	if x_dir and y_dir:
		velocity *= 0.7

	if Input.is_action_pressed("player_focus"):
		velocity *= focus_slowdown
		actual_hitbox_sprite.visible = true
	else:
		actual_hitbox_sprite.visible = false


func handle_shoot(delta: float) -> void:
	if Input.is_action_pressed("player_shoot") and gun_timer.is_stopped():
		gun_timer.start()
		for gun in guns.get_children():
			var shot: Player3Shot = player3_shot_preload.instantiate()
			get_tree().current_scene.add_child(shot)
			shot.global_position = gun.global_position




func _unhandled_input(event: InputEvent) -> void:
	pass
