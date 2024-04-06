extends CharacterBody2D
class_name Komachi

const SPEED := 1200

var can_take_damage: bool = true
const MAX_HP := 1000
const HP_THRESHOLD_SPELL_2 := MAX_HP * 0.95
const HP_THRESHOLD_SPELL_3 := MAX_HP * 0.4
@export var current_HP := MAX_HP
var current_spell := 2 # 1

@onready var sprite: AnimatedSprite2D = $Sprite
@onready var path: Path2D = $"../../"
@onready var path_follow: PathFollow2D = $"../"

@onready var player3: Player3 = $"../../../../Player3" as Player3
@onready var original_position: Vector2 = ($"../../../" as Node2D).global_position

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
@onready var spell_2_guns: Node2D = $"Spell2 Guns"
@onready var spell_2_circle_timer: Timer = $"Spell2 Guns/Circle Timer"
var spell_2_shot_coin_medium_preload := preload("res://entities/stage3/komachi/komachi_shot_coin_medium.tscn")
var spell_2_current_circle_count: int = 0


func take_damage(damage: int) -> void:
	if not can_take_damage:
		return

	current_HP -= damage

	if current_HP <= HP_THRESHOLD_SPELL_2 and current_spell == 1:
		current_spell = 2
		global_position = original_position
	elif current_HP <= HP_THRESHOLD_SPELL_3 and current_spell == 2:
		current_spell = 3
	elif current_HP <= 0 and current_spell == 3:
		current_spell = -1
		can_take_damage = false
		print("die")


func _physics_process(delta: float) -> void:
	handle_spell(delta)


func handle_spell(delta: float) -> void:
	match current_spell:
		# Spell 1
		# Moves slowly
		# Circular waves: each wave has velocities increasing from one end to the other.
		# Homing, staggered single shots: fast, big bullets.
		1:
			if not path.curve:
				path.curve = spell_1_path
			path_follow.progress_ratio = path_follow.progress_ratio + 0.05 * delta

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


		# Spell 2
		# Stationary and shooting fast, but decelerating medium coins in circles
		# Once every few seconds, charge up and pause circles.
		# After charging finishes, charge at player, then wait.
		# Then do big melee scythe slash.
		2:
			path.curve = null
			if spell_2_circle_timer.is_stopped():
				spell_2_circle_timer.start()
				spell_2_current_circle_count = 0
				spell_2_guns.global_rotation += SPELL_2_CIRCLES_ROTATION_DEGREES

			if not spell_2_circle_timer.is_stopped():
				var spell_2_circle_gun: Node2D = spell_2_guns.get_child(1) as Node2D
				var wait_time: float = spell_2_circle_timer.wait_time
				var time_left: float = spell_2_circle_timer.time_left
				var interval: float = (wait_time * 0.45) / SPELL_2_MAX_CIRCLES

				if spell_2_current_circle_count == SPELL_2_MAX_CIRCLES:
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

