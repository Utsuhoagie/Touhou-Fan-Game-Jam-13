extends CharacterBody2D
class_name Komachi

const SPEED := 1200

const MAX_HP := 1000
const HP_THRESHOLD_SPELL_2 := MAX_HP * 0.7
const HP_THRESHOLD_SPELL_3 := MAX_HP * 0.4
@export var current_HP := MAX_HP
var current_spell := 1

var can_take_damage: bool = true

@onready var sprite: AnimatedSprite2D = $Sprite


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
