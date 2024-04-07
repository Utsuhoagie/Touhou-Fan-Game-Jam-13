extends Node2D
class_name Stage2

signal blocks_cleared

@onready var bgm = $BGM
@onready var dialog_player: DialogPlayer = $DialogPlayer
@onready var parsee: Node2D = $Parsee/ParseeBody
@onready var stage_2_ui: Stage2UI = $Stage2UI
@onready var transition: Transition = $Transition

var combo: int = 0
var max_combo: int = 0
var player_lives: int = 5
var high_score: int = 0
var score: int = 0
var graze_count: int = 0
var time_left: float = 3000.0

var blocks_remaining: int


func _ready():
	stage_2_ui.update_high_score(high_score)
	stage_2_ui.life_init(player_lives)

	parsee.defeated.connect(on_defeated)
	blocks_remaining = $Parsee/ParseeBody/Blocks.get_child_count()

	await transition.fade_from_black()
	bgm.play()


func _process(delta: float):
	time_left -= 24 * delta

	stage_2_ui.update_graze(graze_count)
	stage_2_ui.update_score(score)
	stage_2_ui.update_time_left(time_left)


func decrease_blocks(n: int) -> void:
	blocks_remaining -= 1
	if blocks_remaining <= 0:
		blocks_cleared.emit()


func life_down() -> void:
	player_lives -= 1
	stage_2_ui.life_down()

	if player_lives <= 0:
		await transition.fade_to_black()
		get_tree().change_scene_to_file("res://menus/menu.tscn")


func on_defeated() -> void:
	print("stage 2 complete")
	await get_tree().create_timer(2).timeout
	get_tree().paused = true

	bgm.stop()
	dialog_player.start_dialog()

