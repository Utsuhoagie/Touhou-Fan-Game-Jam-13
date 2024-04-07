extends CanvasLayer
class_name Credits

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	animation_player.play("LabelFlash")
	

func _process(_delta: float):
	if Input.is_action_just_pressed("ui_accept"):
		get_tree().change_scene_to_file("res://menus/menu.tscn")
	
