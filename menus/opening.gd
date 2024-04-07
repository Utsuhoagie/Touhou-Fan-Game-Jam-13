extends CanvasLayer
class_name Opening

@export var menu_scene: PackedScene

@onready var opening_sequence = $OpeningSequence


func _ready() -> void:
	opening_sequence.play("opening")
	

func _process(delta: float) -> void:
	if not opening_sequence.is_playing() and Input.is_anything_pressed():
		get_tree().change_scene_to_packed(menu_scene)
	
