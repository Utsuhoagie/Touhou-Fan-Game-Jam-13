extends CharacterBody2D
class_name Parsee

var rotation_speed_radians: float = 0.5

@onready var blocks = $"../Blocks"


func _physics_process(delta: float) -> void:
	blocks.rotation += rotation_speed_radians * delta
