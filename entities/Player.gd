extends Area2D

const speed: int = 400

@onready var hitbox := $Hitbox
@onready var swing_collision_area := $SwingCollisionArea
@onready var yinyang_orb := $"../YinyangOrb"

var player_size: Vector2i
var viewport_size: Vector2i

func _ready() -> void:
	player_size = hitbox.shape.get_rect().size
	viewport_size = get_viewport().size

func _physics_process(delta: float) -> void:
	var input_map: float = Input.get_axis("player_left", "player_right")
	handle_movement(input_map, delta)
	
	if (Input.is_action_just_pressed("player_swing")
	and swing_collision_area.has_overlapping_bodies()):
		yinyang_orb.handle_player_swing(position)
	
	if has_overlapping_bodies():
		die()
		
	update_animations()

func die() -> void:
	print("oofs")

func handle_movement(input_map: float, delta: float) -> void:
	position.x += input_map * speed * delta
	position.x = clamp(
		position.x,
		player_size.x / 2,
		viewport_size.x - (player_size.x / 2)
	)

func update_animations() -> void:
	#if velocity.x != 0:
		#move animation
	pass
