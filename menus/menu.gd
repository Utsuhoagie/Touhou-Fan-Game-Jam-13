extends CanvasLayer
class_name Menu

@export var prologue_scene: PackedScene
@export var options_scene: PackedScene
@export var credits_scene: PackedScene

@onready var button_sfx: AudioStreamPlayer = $ButtonSFX
@onready var button_hover_sfx: AudioStreamPlayer = $ButtonHoverSFX
@onready var opening_sequence: AnimatedSprite2D = $OpeningSequence
@onready var play_button: Button = $SelectButtons/PlayButton

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
	select_button(prologue_scene)
	

func _on_options_button_pressed() -> void:
	select_button(options_scene)
	

func _on_credits_button_pressed() -> void:
	select_button(credits_scene)
	

func _on_play_button_focus_entered() -> void:
	play_hover_sfx()
	

func _on_options_button_focus_entered() -> void:
	play_hover_sfx()
	

func _on_credits_button_focus_entered() -> void:
	play_hover_sfx()
	

func play_hover_sfx() -> void:
	if not opening_sequence_done: return
	
	button_hover_sfx.play()
	

func select_button(packed_scene: PackedScene) -> void:
	if not opening_sequence_done: return
	
	button_sfx.play()
	get_tree().change_scene_to_packed(packed_scene)
