extends Area2D

const speed: int = 300

@onready var collision_shape_2d = $CollisionShape2D

var viewport_size: Vector2i
var player_size: Vector2i

func _ready() -> void:
	viewport_size = get_viewport().size
	player_size = collision_shape_2d.shape.get_rect().size

func _process(delta: float) -> void:
	var input_map: float = Input.get_axis("player_left", "player_right")
	handle_movement(input_map, delta)
	update_animations()

func handle_movement(input_map: float, delta: float) -> void:
	position.x += input_map * speed * delta
	position.x = clamp(
		position.x,
		player_size.x / 2,
		viewport_size.x - (player_size.x / 2)
	)

func update_animations() -> void:
	pass
