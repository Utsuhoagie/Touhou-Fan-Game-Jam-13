extends CanvasLayer
class_name Menu

@export var prologue_scene: PackedScene
@export var options_scene: PackedScene
@export var credits_scene: PackedScene

@onready var opening_sequence: AnimatedSprite2D = $OpeningSequence
@onready var play_button = $SelectButtons/PlayButton

var opening_sequence_done: bool = false


func _ready() -> void:
	opening_sequence.show()
	opening_sequence.play("opening")
	play_button.grab_focus()


func _process(delta: float) -> void:
	if (not opening_sequence.is_playing() and Input.is_anything_pressed()
	and not Input.is_action_pressed("ui_accept")):
		opening_sequence_done = true
		opening_sequence.hide()
		
	

func _on_play_button_pressed() -> void:
	if not opening_sequence_done: return
	get_tree().change_scene_to_packed(prologue_scene)
	

func _on_options_button_pressed() -> void:
	get_tree().change_scene_to_packed(options_scene)
	

func _on_credits_button_pressed() -> void:
	get_tree().change_scene_to_packed(credits_scene)
	
