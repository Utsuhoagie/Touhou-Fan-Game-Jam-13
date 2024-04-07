extends CanvasLayer
class_name Opening

@export var menu_scene: PackedScene

@onready var opening_sequence: AnimatedSprite2D = $OpeningSequence
@onready var start_sfx: AudioStreamPlayer = $StartSFX
@onready var transition: Transition = $Transition


func _ready() -> void:
	await transition.fade_from_black()
	opening_sequence.play("opening")


func _process(delta: float) -> void:
	if not opening_sequence.is_playing() and Input.is_anything_pressed():
		start_sfx.play()
		await transition.fade_to_black()
		get_tree().change_scene_to_packed(menu_scene)

