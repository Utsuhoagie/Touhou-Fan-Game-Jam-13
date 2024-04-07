extends Area2D
class_name OrbShot

var speed := 2000


func _process(delta) -> void:
	position.y -= speed * delta
	

func _on_body_entered(body) -> void:
	if body.get_name() == "ParseeBody":
		print("parsee: oof")
	
	queue_free()
