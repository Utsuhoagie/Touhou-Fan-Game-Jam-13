extends CharacterBody2D
class_name Komachi

const SPEED := 1200

var can_take_damage: bool = true
const MAX_HP := 1000
const HP_THRESHOLD_SPELL_2 := MAX_HP * 0.7
const HP_THRESHOLD_SPELL_3 := MAX_HP * 0.4
@export var current_HP := MAX_HP
var current_spell := 1

@onready var sprite: AnimatedSprite2D = $Sprite

# Spells
const SPELL_1_ROTATION_DEGREES := 1.0
@onready var spell_1_timer: Timer = $"Spell1 Timer"
var spell_1_shot_coin_preload := preload("res://entities/stage3/komachi/komachi_shot_coin.tscn")



func take_damage(damage: int) -> void:
	if not can_take_damage:
		return

	current_HP -= damage
	print("take damage! %s" % current_HP)

	if current_HP <= HP_THRESHOLD_SPELL_2 and current_spell == 1:
		current_spell = 2
		print("to spell 2")
	elif current_HP <= HP_THRESHOLD_SPELL_3 and current_spell == 2:
		current_spell = 3
		print("to spell 3")
	elif current_HP <= 0 and current_spell == 3:
		current_spell = -1
		can_take_damage = false
		print("die")


func _process(delta: float) -> void:
	handle_spell(delta)


func handle_spell(delta: float) -> void:
	match current_spell:
		1:
			# Spell 1
			# Circular, overlaid waves.
			# Each wave has velocities increasing from one end to the other.
			var spell_1_guns: Node2D = $"Spell1 Guns"

			spell_1_guns.global_rotation += SPELL_1_ROTATION_DEGREES

			if spell_1_timer.is_stopped():
				spell_1_timer.start()

				for gun in spell_1_guns.get_children():
					# Shoot 10 coins per wave, start wave from downwards, based on Gun rotation
					for i in range(10):
						var coin := spell_1_shot_coin_preload.instantiate() as KomachiShotCoin
						coin.init(0.4 + 0.07 * i, 0.0 + i * 8 + rad_to_deg(gun.global_rotation))
						coin.global_position = gun.global_position
						get_tree().current_scene.add_child(coin)
