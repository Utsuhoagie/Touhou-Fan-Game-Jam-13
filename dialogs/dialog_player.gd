extends CanvasLayer
class_name DialogPlayer

@export var dialog_key: String
@export var narration_mode: bool
@export var next_scene: PackedScene

@onready var animation_player = $AnimationPlayer
@onready var animation_timer: Timer = $AnimationTimer
@onready var character_name: Label = %CharacterName
@onready var dialog_section: Label = %DialogSection
@onready var proceed_hint: Label = %ProceedHint
@onready var transition: Transition = $"../Transition"
@onready var transition_bgm_1: AudioStreamPlayer = $TransitionBGM1
@onready var transition_bgm_2: AudioStreamPlayer = $TransitionBGM2
@onready var transition_sfx: AudioStreamPlayer = $TransitionSFX
@onready var dialog_sfx: AudioStreamPlayer = $DialogSFX

@onready var fake_parsee_sprite = $FakeParseeSprite
@onready var mizuchi_sprite = $MizuchiSprite
@onready var parsee_sprite = $ParseeSprite
@onready var komachi_sprite = $KomachiSprite

var dialogs_file_path: String = "res://dialogs/dialogs.json"
var dialogs_dict: Dictionary

var dialog_pointer: int = 0
var in_progress: bool = false


func _ready() -> void:
	if not FileAccess.file_exists(dialogs_file_path):
		return print("ERROR: dialogs.json not found")

	var dialogs_file = FileAccess.open(dialogs_file_path, FileAccess.READ)
	dialogs_dict = JSON.parse_string(dialogs_file.get_as_text())
	if not dialog_key in dialogs_dict:
		return print("ERROR: dialog key doesn't exist in dialogs.json")

	if narration_mode:
		hide()
		character_name.hide()
		await transition.fade_from_black()

		show()
		start_dialog()


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept") and in_progress:
		dialog_pointer += 1
		dialog_sfx.play()
		display_dialog(dialogs_dict[dialog_key], dialog_pointer)


func display_dialog(dialog: Array, pointer: int) -> void:
	if pointer + 1 > dialog.size():
		await end_dialog()
		return

	var	selected_text: Dictionary = dialog[pointer]
	var current_sprite: TextureRect

	komachi_sprite.hide()
	mizuchi_sprite.hide()
	parsee_sprite.hide()

	if not narration_mode:
		character_name.show()
		match selected_text["character"]:
			"0":
				character_name.text = "Mizuchi"
				current_sprite = mizuchi_sprite
			"1":
				character_name.text = "Parsee"
				current_sprite = parsee_sprite
			"2":
				character_name.text = "Komachi"
				current_sprite = komachi_sprite
			"3":
				character_name.text = "Parsee?"
				current_sprite = fake_parsee_sprite
			_:
				character_name.hide()


		if selected_text["sprite"] != -1:
			current_sprite.texture.region.position.x = selected_text["sprite"] * 128
			current_sprite.show()


	dialog_section.text = selected_text["text"]
	animation_player.play("show_text")
	animation_timer.start()
	await animation_timer.timeout
	animation_player.play("proceed_flash")


func end_dialog() -> void:
	in_progress = false
	dialog_pointer = 0
	transition_sfx.play()
	await transition.fade_to_black()

	if next_scene:
		get_tree().change_scene_to_packed(next_scene)
	else:
		get_tree().change_scene_to_file("res://menus/menu.tscn")


func start_dialog() -> void:
	in_progress = true
	display_dialog(dialogs_dict[dialog_key], dialog_pointer)
	show()

	match dialog_key:
		"prologue":
			pass
		"post_stage1":
			transition_bgm_1.play()
		"post_stage2":
			transition_bgm_2.play()
		"post_stage3":
			pass
		"ending":
			pass
		_:
			pass

