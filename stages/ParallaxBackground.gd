extends ParallaxBackground

@export var scroll_speed: float = 100.0


func _process(delta: float) -> void:
	scroll_base_offset += Vector2(0, scroll_speed) * delta
	
