extends Area2D
class_name KomachiBaseShot

@onready var sprite: AnimatedSprite2D = $Sprite
@onready var collision: CollisionShape2D = $Collision

const RANDOM_COLORS: Array[Color] = [Color.KHAKI, Color.ORANGE, Color.GOLD, Color.CORAL]


func randomize_color() -> void:
	sprite.modulate = RANDOM_COLORS[randi() % RANDOM_COLORS.size()]
