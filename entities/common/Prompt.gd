extends AnimatedSprite2D

@onready var timer: Timer = $Timer
@onready var flash_timer: Timer = $"Flash Timer"


func _process(delta: float) -> void:
	if timer.is_stopped() and visible:
		visible = false

	elif not timer.is_stopped() and flash_timer.is_stopped():
		flash_timer.start()
		visible = not visible
