extends CharacterBody2D
class_name YinyangOrb

var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var swing_bounce := 1250

@onready var card_tilemap: TileMap = $"../CardTilemap"
@onready var sprite: Sprite2D = $Sprite


func _ready() -> void:
	velocity = Vector2(-750, -750)
	

func _physics_process(delta: float) -> void:
	velocity.y += gravity * delta
	card_tilemap.check_overlap(position)
	
	var collision: KinematicCollision2D = (
		move_and_collide(velocity * delta)
	)
	if collision:
		var collider: Object = collision.get_collider()
		velocity = velocity.bounce(collision.get_normal())
		velocity *= 0.9
	
	sprite.flip_h = velocity.x < 0
	

func handle_player_swing(player_pos: Vector2) -> void:
	var pos_diff: Vector2 = position - player_pos
	var angle_radians: float = atan2(pos_diff.y, pos_diff.x)
	angle_radians = remap(angle_radians, -PI, 0, -PI * 0.875, -PI * 0.125)
	
	velocity = Vector2(
		swing_bounce * cos(angle_radians),
		swing_bounce * sin(angle_radians)
	)
	
