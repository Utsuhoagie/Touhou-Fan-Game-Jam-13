extends CanvasLayer
class_name PauseMenu

@onready var bgm = $"../BGM"
@onready var button_sfx = $ButtonSFX
@onready var button_hover_sfx = $ButtonHoverSFX
@onready var continue_button = %ContinueButton
@onready var pause_sfx = $PauseSFX
@onready var transition: Transition = $"../Transition"


func _ready() -> void:
	hide()
	

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		if get_tree().paused:
			unpause()
		else:
			get_tree().paused = true
			show()
			bgm.volume_db = -10
			
			pause_sfx.play()
			continue_button.grab_focus()
	

func _on_continue_button_focus_entered() -> void:
	button_hover_sfx.play()
	

func _on_back_button_focus_entered() -> void:
	button_hover_sfx.play()
	

func _on_back_button_pressed() -> void:
	button_sfx.play()
	await transition.fade_to_black()
	get_tree().change_scene_to_file("res://menus/menu.tscn")
	

func _on_continue_button_pressed() -> void:
	button_sfx.play()
	unpause()
	

func unpause() -> void:
	bgm.volume_db = 0
	get_tree().paused = false
	hide()
