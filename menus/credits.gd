extends CanvasLayer
class_name Credits

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var select_sfx: AudioStreamPlayer = $SelectSFX
@onready var transition: Transition = $Transition


func _ready() -> void:
	await transition.fade_from_black()
	animation_player.play("LabelFlash")
	

func _process(_delta: float):
	if Input.is_action_just_pressed("ui_accept"):
		select_sfx.play()
		await transition.fade_to_black()
		get_tree().change_scene_to_file("res://menus/menu.tscn")
	
