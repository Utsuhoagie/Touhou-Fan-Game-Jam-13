extends CharacterBody2D
class_name Komachi

const SPEED := 150

var can_take_damage: bool = true
const MAX_HP := 3500
const HP_THRESHOLD_SPELL_2 := MAX_HP * 0.7
const HP_THRESHOLD_SPELL_3 := MAX_HP * 0.3
@export var current_HP := MAX_HP
var current_spell: float = 1.0

@onready var sprite: AnimatedSprite2D = $Sprite
@onready var path: Path2D = $"../../"
@onready var path_follow: PathFollow2D = $"../"
@onready var bomb_damage_timer: Timer = $"Bomb Damage Timer"
@onready var HP_bar: TextureProgressBar = $"HP Bar"

@onready var player3: Player3 = $"../../../../Player3" as Player3
@onready var original_position: Vector2 = Vector2(640, 192) # ($"../../../" as Node2D).global_position - Vector2(0, 100.0)

# Spell 1
const SPELL_1_WAVES_ROTATION_DEGREES := 1.0
@onready var spell_1_guns: Node2D = $"Spell1 Guns"
@onready var spell_1_waves_timer: Timer = $"Spell1 Guns/Waves Timer"
@onready var spell_1_homing_timer: Timer = $"Spell1 Guns/Homing Timer"
var spell_1_shot_coin_preload := preload("res://entities/stage3/komachi/komachi_shot_coin.tscn")
var spell_1_shot_coin_big_preload := preload("res://entities/stage3/komachi/komachi_shot_coin_big.tscn")
var spell_1_path: Curve2D = preload("res://entities/stage3/komachi/spell_1_path.tres")
var spell_1_homing_recently_shot: Array[int] = []

# Spell 2
const SPELL_2_CIRCLES_ROTATION_DEGREES := 15.0
const SPELL_2_MAX_COINS_PER_CIRCLE := 30
const SPELL_2_MAX_CIRCLES := 3
const SPELL_2_MAX_CIRCLE_WAVES := 3 + 1	# has to add 1, don't know why
const SPELL_2_MELEE_DISTANCE := 180.0
@onready var spell_2_guns: Node2D = $"Spell2 Guns"
@onready var spell_2_circle_timer: Timer = $"Spell2 Guns/Circle Timer"
var spell_2_shot_coin_medium_preload := preload("res://entities/stage3/komachi/komachi_shot_coin_medium.tscn")
var spell_2_current_circle_count: int = 0
var spell_2_current_circle_waves_count: int = 0
var spell_2_melee_deceleration: float = 1.0
var spell_2_melee_player3_position: Vector2
var spell_2_melee_is_stopped: bool = false
var spell_2_melee_finished: bool = false

# Spell 3
const SPELL_3_RING_COUNT := 8
var spell_3_path: Curve2D = preload("res://entities/stage3/komachi/spell_3_path.tres")
@onready var spell_3_guns: Node2D = $"Spell3 Guns"
@onready var spell_3_fan_gun: Node2D = $"Spell3 Guns/Fan Guns/Gun"
@onready var spell_3_trident_timer: Timer = $"Spell3 Guns/Fan Guns/Trident Timer"
@onready var spell_3_coins_timer: Timer = $"Spell3 Guns/Fan Guns/Coins Timer"
@onready var spell_3_ring_gun: Node2D = $"Spell3 Guns/Ring Guns/Gun"
@onready var spell_3_ring_timer: Timer = $"Spell3 Guns/Ring Guns/Ring Timer"
var spell_3_shot_straight_preload := preload("res://entities/stage3/komachi/komachi_shot_straight.tscn")


func _ready() -> void:
	HP_bar.min_value = 0
	HP_bar.max_value = MAX_HP
	HP_bar.value = current_HP


func take_damage(damage: int, is_bomb: bool = false) -> void:
	if not can_take_damage:
		return

	current_HP -= damage
	HP_bar.value = current_HP

	if is_bomb:
		bomb_damage_timer.start()
		can_take_damage = false


	if current_HP <= HP_THRESHOLD_SPELL_2 and current_spell == 1.0:
		can_take_damage = false
		current_spell = 1.5
	elif current_HP <= HP_THRESHOLD_SPELL_3 and current_spell == 2.0:
		can_take_damage = false
		current_spell = 2.5
	elif current_HP <= 0 and current_spell == 3.0:
		can_take_damage = false
		current_spell = -1
		print("die")


func _physics_process(delta: float) -> void:
	handle_spell(delta)
	detect_player_hit()


func detect_player_hit() -> void:
	var collided := move_and_slide()


func handle_spell(delta: float) -> void:
	match current_spell:
		# Spell 1
		# Moves slowly
		# Circular waves: each wave has velocities increasing from one end to the other.
		# Homing, staggered single shots: fast, big bullets.
		1.0:
			if not path.curve:
				path.curve = spell_1_path
			path_follow.progress_ratio = path_follow.progress_ratio + 0.05 * delta

			if path_follow.progress_ratio >= 0.5:
				sprite.play("left")
			else:
				sprite.play("right")

			if spell_1_waves_timer.is_stopped():
				spell_1_waves_timer.start()

				# Shoot N coins per wave, start wave from downwards, based on Gun rotation
				var waves_guns: Node2D = spell_1_guns.get_node("Waves")
				waves_guns.global_rotation += SPELL_1_WAVES_ROTATION_DEGREES
				for gun in waves_guns.get_children():
					for i in range(10):
						var coin := spell_1_shot_coin_preload.instantiate() as KomachiShotCoin
						get_tree().current_scene.add_child(coin)

						coin.init(0.45 + 0.07 * i, i * 8 + gun.global_rotation_degrees)
						coin.global_position = gun.global_position

			if spell_1_homing_timer.is_stopped():
				spell_1_homing_timer.start()
				spell_1_homing_recently_shot = []

			if not spell_1_homing_timer.is_stopped():
				# Shoot 1 big coin, aimed at player
				var homing_guns: Node2D = spell_1_guns.get_node("Homing")
				var homing_guns_count: int = homing_guns.get_child_count()
				var wait_time: float = spell_1_homing_timer.wait_time * 0.6
				var time_left: float = spell_1_homing_timer.time_left
				var interval: float = wait_time / homing_guns_count
				for i in range(homing_guns_count):
					if i in spell_1_homing_recently_shot:
						continue
					if time_left <= wait_time - i * interval and time_left >= wait_time - (i + 1) * interval:
						var gun := homing_guns.get_child(i)
						var big_coin := spell_1_shot_coin_big_preload.instantiate() as KomachiShotCoinBig
						get_tree().current_scene.add_child(big_coin)

						var homing_angle := rad_to_deg(gun.get_angle_to(player3.global_position)) - 90.0
						big_coin.init(1.0, homing_angle)
						big_coin.global_position = gun.global_position

						spell_1_homing_recently_shot.append(i)


		# Transition to spell 2
		# Slowly moves towards original position
		1.5:
			var target_position := original_position - global_position
			velocity = target_position * SPEED * delta
			#spell_2_melee_deceleration = clampf(spell_2_melee_deceleration - 0.01, 0.7, 1.0)

			if global_position.distance_to(original_position) <= 10.0:
				current_spell = 2.0
				velocity = Vector2.ZERO
				#spell_2_melee_deceleration = 1.0

		# Spell 2
		# Stationary and shooting fast, but decelerating medium coins in circles
		# Once every few seconds, charge up and pause circles.
		# After charging finishes, charge at player, then wait.
		# Then do big melee scythe slash.
		2.0:
			can_take_damage = true
			path.curve = null

			var melee_timer: Timer = spell_2_guns.get_node("Melee Timer") as Timer

			if velocity.x < 0:
				sprite.play("left")
			elif velocity.x > 0:
				sprite.play("right")
			elif velocity.x == 0 and spell_2_current_circle_waves_count < SPELL_2_MAX_CIRCLE_WAVES:
				sprite.play("default")

			if spell_2_current_circle_waves_count == SPELL_2_MAX_CIRCLE_WAVES:
				if melee_timer.is_stopped():
					melee_timer.start()
					spell_2_melee_player3_position = player3.global_position
					spell_2_guns.global_rotation_degrees = 0.0

				var wait_time: float = melee_timer.wait_time
				var time_left: float = melee_timer.time_left
				var time_left_ratio: float = time_left / wait_time

				if time_left_ratio >= 0.75 and not spell_2_melee_is_stopped:
					print("charging at player")

					if global_position.distance_to(spell_2_melee_player3_position) >= SPELL_2_MELEE_DISTANCE:
						var target_position := spell_2_melee_player3_position - global_position
						velocity = target_position * spell_2_melee_deceleration * SPEED * delta
						spell_2_melee_deceleration = clampf(spell_2_melee_deceleration - 0.012, 0.65, 1.0)
					else:
						velocity = Vector2.ZERO
						spell_2_melee_deceleration = 1.0
						spell_2_melee_is_stopped = true
						sprite.play("default")
					#move_and_slide()

				elif time_left_ratio >= 0.71:
					print("preparing melee")

				elif time_left_ratio >= 0.5:
					print("melee")
					var melee_hitbox: Area2D = spell_2_guns.get_node("Melee Hitbox") as Area2D
					var melee_hitbox_collision: CollisionShape2D = melee_hitbox.get_node("Collision") as CollisionShape2D
					var melee_hitbox_sprite: Sprite2D = melee_hitbox.get_node("Sprite") as Sprite2D

					if sprite.animation != "attack" and not spell_2_melee_finished:
						sprite.play("attack")
					if sprite.animation == "attack" and sprite.frame == 3:
						sprite.play("default")
						melee_hitbox_sprite.visible = false
						spell_2_melee_finished = true
						return
					if spell_2_melee_finished:
						return
					melee_hitbox_collision.disabled = false
					melee_hitbox_sprite.visible = true
					melee_hitbox.global_rotation_degrees = clampf(melee_hitbox.global_rotation_degrees - 10.0, -140.0, 0.0)



				elif time_left_ratio >= 0.15:
					print("returning to %s" % original_position)
					var melee_hitbox: Area2D = spell_2_guns.get_node("Melee Hitbox") as Area2D
					var melee_hitbox_collision: CollisionShape2D = melee_hitbox.get_node("Collision") as CollisionShape2D
					var melee_hitbox_sprite: Sprite2D = melee_hitbox.get_node("Sprite") as Sprite2D
					melee_hitbox_sprite.visible = false
					melee_hitbox_collision.disabled = true
					melee_hitbox.global_rotation_degrees = 0.0

					var target_position := original_position - global_position
					velocity = target_position * spell_2_melee_deceleration * SPEED * delta
					spell_2_melee_deceleration = clampf(spell_2_melee_deceleration - 0.012, 0.5, 1.0)

					#move_and_slide()

				else:
					spell_2_melee_deceleration = 1.0
					spell_2_melee_is_stopped = false
					spell_2_melee_finished = false
					spell_2_current_circle_waves_count = 0
					velocity = Vector2.ZERO

				return


			if spell_2_circle_timer.is_stopped():
				spell_2_circle_timer.start()
				spell_2_current_circle_count = 0
				spell_2_current_circle_waves_count += 1
				spell_2_guns.get_node("Circle Gun").global_rotation += SPELL_2_CIRCLES_ROTATION_DEGREES

			if spell_2_current_circle_waves_count == SPELL_2_MAX_CIRCLE_WAVES:
				return

			if not spell_2_circle_timer.is_stopped():
				var spell_2_circle_gun: Node2D = spell_2_guns.get_child(1) as Node2D
				var wait_time: float = spell_2_circle_timer.wait_time
				var time_left: float = spell_2_circle_timer.time_left
				var interval: float = (wait_time * 0.45) / SPELL_2_MAX_CIRCLES

				if spell_2_current_circle_count == SPELL_2_MAX_CIRCLES:
					#spell_2_current_circle_waves_count += 1
					#print("------ wait %s, left %s, interval %s" % [wait_time, time_left, interval])
					return

				var t_big: float = wait_time - spell_2_current_circle_count * interval
				var t_small: float = wait_time - (spell_2_current_circle_count + 1) * interval

				if time_left <= t_big and time_left >= t_small:
					spell_2_current_circle_count += 1
					for j in range(SPELL_2_MAX_COINS_PER_CIRCLE):
						var coin_medium: KomachiShotCoinMedium = spell_2_shot_coin_medium_preload.instantiate() as KomachiShotCoinMedium
						get_tree().current_scene.add_child(coin_medium)

						coin_medium.init(j * (360 / SPELL_2_MAX_COINS_PER_CIRCLE) + spell_2_guns.global_rotation_degrees)
						coin_medium.global_position = spell_2_circle_gun.global_position


		# Transition to spell 3
		# Slowly moves towards original position
		2.5:
			var melee_hitbox: Area2D = spell_2_guns.get_node("Melee Hitbox") as Area2D
			var melee_hitbox_collision: CollisionShape2D = melee_hitbox.get_node("Collision") as CollisionShape2D
			var melee_hitbox_sprite: Sprite2D = melee_hitbox.get_node("Sprite") as Sprite2D
			melee_hitbox_sprite.visible = false
			melee_hitbox_collision.disabled = true
			melee_hitbox.global_rotation_degrees = 0.0

			var target_position := original_position - global_position
			velocity = target_position * SPEED * delta

			if global_position.distance_to(original_position) <= 10.0:
				current_spell = 3.0
				velocity = Vector2.ZERO
				path.curve = spell_3_path
				path_follow.progress_ratio = 0.37
				position = Vector2.ZERO

		# Spell 3
		# Fast "trident" pattern outside and in the middle of cone
		# Slower "fan" waves of coins inside cone
		# And full ring of big coins, that curve slightly when flying
		3.0:
			can_take_damage = true
			path_follow.progress_ratio = path_follow.progress_ratio + 0.05 * delta

			if path_follow.progress_ratio >= 0.13 and path_follow.progress_ratio <= 0.63:
				sprite.play("right")
			else:
				sprite.play("left")

			if spell_3_trident_timer.is_stopped():
				spell_3_trident_timer.start()

				# Trident
				for i in range(3):
					var straight: KomachiShotStraight = spell_3_shot_straight_preload.instantiate() as KomachiShotStraight
					get_tree().current_scene.add_child(straight)

					straight.init(1.0, -30.0 + 30.0 * i)
					straight.global_position = spell_3_fan_gun.global_position

			if spell_3_coins_timer.is_stopped():
				spell_3_coins_timer.start()

				for i in range(4):
					var coin_medium: KomachiShotCoinMedium = spell_2_shot_coin_medium_preload.instantiate() as KomachiShotCoinMedium
					get_tree().current_scene.add_child(coin_medium)

					var angle := -20.0 + 10.0 * i
					if angle >= 0.0:
						angle += 10.0
					coin_medium.init(angle, false)
					coin_medium.global_position = spell_3_fan_gun.global_position

			if spell_3_ring_timer.is_stopped():
				spell_3_ring_timer.start()

				for i in range(SPELL_3_RING_COUNT):
					var coin_big: KomachiShotCoinBig = spell_1_shot_coin_big_preload.instantiate() as KomachiShotCoinBig
					get_tree().current_scene.add_child(coin_big)

					coin_big.init(0.5, i * (360 / SPELL_3_RING_COUNT), 0.33)
					coin_big.global_position = spell_3_ring_gun.global_position


func _on_player_kill_hitbox_body_entered(body: Node2D) -> void:
	if body is Player3:
		body.die()


func _on_bomb_damage_timer_timeout() -> void:
	can_take_damage = true
