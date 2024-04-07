extends Area2D
class_name Player3Bomb

const DAMAGE := 80
const SPEED := 3.0
const FUZZY := 50

@onready var sprite: AnimatedSprite2D = $Sprite as AnimatedSprite2D

var komachi_position: Vector2
var velocity: Vector2


func _ready() -> void:
	body_entered.connect(on_body_entered)
	area_entered.connect(on_area_entered)


func home_on(position: Vector2, player: Player3) -> void:
	komachi_position = position
	var target_position := komachi_position - global_position
	var fuzzy_x := (randi() % (2 * FUZZY)) - FUZZY
	var fuzzy_y := (randi() % (2 * FUZZY)) - FUZZY
	target_position += Vector2(fuzzy_x, fuzzy_y)
	velocity = target_position * SPEED

	player.bomb_finished.connect(on_bomb_finished)


func _process(delta: float) -> void:
	if komachi_position:
		position += velocity * delta


func on_body_entered(body: Node2D) -> void:
	if body is Komachi:
		body.take_damage(DAMAGE, true)


func on_area_entered(area: Area2D) -> void:
	if area is KomachiBaseShot:
		area.queue_free()


func on_bomb_finished() -> void:
	queue_free()
