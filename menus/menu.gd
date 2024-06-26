extends CanvasLayer
class_name Menu

@export var prologue_scene: PackedScene
@export var options_scene: PackedScene
@export var credits_scene: PackedScene

@onready var button_sfx: AudioStreamPlayer = $ButtonSFX
@onready var button_hover_sfx: AudioStreamPlayer = $ButtonHoverSFX
@onready var play_button: Button = %PlayButton
@onready var transition: Transition = $Transition


func _ready() -> void:
	await transition.fade_from_black()
	play_button.grab_focus()
	

func _on_play_button_pressed() -> void:
	select_button(prologue_scene)
	

func _on_options_button_pressed() -> void:
	select_button(options_scene)
	

func _on_credits_button_pressed() -> void:
	select_button(credits_scene)
	

func _on_play_button_focus_entered() -> void:
	button_hover_sfx.play()
	

func _on_options_button_focus_entered() -> void:
	button_hover_sfx.play()
	

func _on_credits_button_focus_entered() -> void:
	button_hover_sfx.play()
	

func _on_quit_button_pressed() -> void:
	button_sfx.play()
	await transition.fade_to_black()
	get_tree().quit()


func _on_quit_button_focus_entered() -> void:
	button_hover_sfx.play()


func select_button(packed_scene: PackedScene) -> void:
	print("test")
	button_sfx.play()
	await transition.fade_to_black()
	get_tree().change_scene_to_packed(packed_scene)
	
