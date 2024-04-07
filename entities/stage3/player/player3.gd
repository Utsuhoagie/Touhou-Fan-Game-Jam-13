extends CharacterBody2D
class_name Player3

signal bomb_finished
signal UI_changed(lives: int, max_lives: int, bombs: int, grazes: int, score: int)

var speed := 27000.0
var focus_slowdown := 0.45

@onready var stage3 = get_tree().current_scene
@onready var sprite: AnimatedSprite2D = $Sprite
@onready var hitbox: CollisionShape2D = $Hitbox
@onready var actual_hitbox_sprite: AnimatedSprite2D = $ActualHitboxSprite

@onready var audio_shot_player: AudioStreamPlayer = $"Audio Shot Player"
@onready var audio_bomb_player: AudioStreamPlayer = $"Audio Bomb Player"
@onready var audio_die_player: AudioStreamPlayer = $"Audio Die Player"
var player3_shot_sfx := preload("res://assets/audio/sfx/new/Player_Shoot.wav")
var player3_bomb_activation_sfx := preload("res://assets/audio/sfx/new/Player_Bomb_Activate.wav")
var player3_die_sfx := preload("res://assets/audio/sfx/new/Player_Hit.wav")

@onready var gun_timer: Timer = $GunTimer
@onready var guns: Node2D = $Guns

@onready var bomb_homing_timer: Timer = $"Bomb Homing Timer"
@onready var bomb_timer: Timer = $"Bomb Timer"
@onready var bomb_guns: Node2D = $"Bomb Guns"
var is_bombing: bool = false

var player3_shot_preload = preload("res://entities/stage3/player/player_3_shot.tscn")
var player3_bomb_preload = preload("res://entities/stage3/player/bomb_orb.tscn")

@export var komachi_node: Node2D


func _ready() -> void:
	sprite.play("default")
	actual_hitbox_sprite.visible = false


func _process(delta: float) -> void:
	handle_animation()
	handle_movement(delta)
	handle_shoot(delta)

	move_and_slide()
	clamp_in_screen()


func handle_animation() -> void:
	if hitbox.disabled and sprite.animation != "die":
		sprite.visible = !sprite.visible
	else:
		sprite.visible = true


func handle_movement(delta: float) -> void:
	if sprite.animation == "die":
		velocity = Vector2.ZERO
		return

	var x_dir := Input.get_axis("player_left", "player_right")
	var y_dir := Input.get_axis("player_up", "player_down")

	velocity = Vector2(x_dir * speed, y_dir * speed) * delta

	match x_dir:
		-1.0:
			sprite.play("left")
		0.0:
			sprite.play("default")
		1.0:
			sprite.play("right")

	if x_dir and y_dir:
		velocity *= 0.7

	if Input.is_action_pressed("player_focus"):
		velocity *= focus_slowdown
		actual_hitbox_sprite.visible = true
	else:
		actual_hitbox_sprite.visible = false


func handle_shoot(delta: float) -> void:
	if hitbox.disabled:
		return

	if Input.is_action_pressed("player_bomb") and bomb_timer.is_stopped() and stage3.bombs > 0:
		print("bomb")
		stage3.decrease_bombs()
		is_bombing = true
		bomb_timer.start()
		bomb_homing_timer.start()
		audio_bomb_player.volume_db = -9.0
		audio_bomb_player.stream = player3_bomb_activation_sfx
		audio_bomb_player.play()
		for bomb_gun in bomb_guns.get_children():
			var bomb: Player3Bomb = player3_bomb_preload.instantiate()
			bomb_gun.add_child(bomb)
			bomb.global_position = bomb_gun.global_position

	if not bomb_timer.is_stopped():
		bomb_guns.global_rotation_degrees += 5.0

		for bomb_gun in bomb_guns.get_children():
			if bomb_homing_timer.is_stopped():
				continue

			var bomb: Player3Bomb = bomb_gun.get_child(0) as Player3Bomb
			var further_position := bomb.global_position - (bomb_guns as Node2D).global_position
			further_position *= 0.0103

			print("current %s | further %s" % [bomb.global_position, further_position])

			bomb.global_position += further_position


	if Input.is_action_pressed("player_shoot") and gun_timer.is_stopped():
		audio_shot_player.stream = player3_shot_sfx
		audio_shot_player.play()

		gun_timer.start()
		for gun in guns.get_children():
			var shot: Player3Shot = player3_shot_preload.instantiate()
			get_tree().current_scene.add_child(shot)
			shot.global_position = gun.global_position


func clamp_in_screen() -> void:
	global_position.x = clampf(global_position.x, 32, get_viewport_rect().size.x - 32)
	global_position.y = clampf(global_position.y, 128, get_viewport_rect().size.y - 112)


func die() -> void:
	if is_bombing:
		return

	audio_die_player.stream = player3_die_sfx
	audio_die_player.play()

	stage3.decrease_lives()
	sprite.play("die")
	hitbox.set_deferred("disabled", true)


func _on_sprite_animation_finished() -> void:
	if sprite.animation == "die":
		sprite.play("invincible")
		($"Invincible Timer" as Timer).start()


func _on_invincible_timer_timeout() -> void:
	sprite.play("default")
	hitbox.disabled = false


func _on_graze_hitbox_area_entered(area: Area2D) -> void:
	if area is KomachiBaseShot and not hitbox.disabled:
		stage3.increase_grazes()


func _on_bomb_timer_timeout() -> void:
	is_bombing = false
	bomb_finished.emit()


func _on_bomb_homing_timer_timeout() -> void:
	for bomb_gun in bomb_guns.get_children():
		#audio_bomb_player.stream = player3_bomb_homing_sfx
		#audio_bomb_player.volume_db = 0.0
		#audio_bomb_player.play()
		var bomb: Player3Bomb = bomb_gun.get_child(0) as Player3Bomb
		bomb.reparent(get_tree().current_scene)
		bomb.home_on(komachi_node.get_node("Path/Path Follow").global_position, self)
