extends CanvasLayer
class_name DialogPlayer

@export var dialog_key: String
@export var narration_mode: bool
@export var next_scene: PackedScene

@onready var character_name: Label = %CharacterName
@onready var dialog_section: Label = %DialogSection
@onready var proceed_hint: Label = %ProceedHint

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
		character_name.hide()
		start_dialog()
	

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept") and in_progress:
		dialog_pointer += 1
		display_dialog(dialogs_dict[dialog_key], dialog_pointer)
	

func display_dialog(dialog: Array, pointer: int) -> void:
	if pointer + 1 > dialog.size():
		return end_dialog()
	
	var	selected_text: Dictionary = dialog[pointer]
	var current_sprite: TextureRect
	
	komachi_sprite.hide()
	mizuchi_sprite.hide()
	parsee_sprite.hide()
	
	dialog_section.text = selected_text["text"]
	if narration_mode: return
	
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
		_:
			character_name.text = "???"
			return
	
	current_sprite.texture.region.position.x = selected_text["sprite"] * 128
	current_sprite.show()
	

func end_dialog() -> void:
	in_progress = false
	dialog_pointer = 0
	get_tree().change_scene_to_packed(next_scene)
	

func start_dialog() -> void:
	in_progress = true
	display_dialog(dialogs_dict[dialog_key], dialog_pointer)
	show()
	
