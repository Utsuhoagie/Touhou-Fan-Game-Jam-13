extends StaticBody2D
class_name Block

@export var hp := 1

func _on_area_2d_body_entered(body):
	hp -= 1
	if hp == 0:
		queue_free()
	
