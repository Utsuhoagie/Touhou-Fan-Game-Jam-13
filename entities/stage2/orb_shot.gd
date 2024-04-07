extends Area2D
class_name OrbShot

var speed := 2000
const DAMAGE := 20

@onready var shoot_sfx = $ShootSFX


func _ready() -> void:
	shoot_sfx.play()


func _process(delta) -> void:
	position.y -= speed * delta


func _on_body_entered(body: Node2D) -> void:
	if body is Parsee:
		body.take_damage(DAMAGE)
		queue_free()
