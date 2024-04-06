extends ParallaxBackground

func _process(delta: float) -> void:
	scroll_base_offset += Vector2(0, 100) * delta
