extends Node2D
class_name Stage1

@onready var bgm: AudioStreamPlayer = $BGM
@onready var card_tilemap: CardTileMap = $CardTilemap
@onready var dialog_player: DialogPlayer = $DialogPlayer
@onready var stage_1_ui: Stage1UI = $Stage1UI
@onready var yinyang_orb: YinyangOrb = $YinyangOrb

var player_lives: int = 5
var high_score: int = 0
var score: int = 0
var graze_count: int = 0
var combo: int = 0
var max_combo: int = 0
var time_left: float = 3000.0

var all_cards_turned: bool = false
var running_out_of_time: bool = false
var blocks_remaining: int


func _ready() -> void:
	stage_1_ui.update_high_score(high_score)
	stage_1_ui.life_init(player_lives)
	
	blocks_remaining = get_tree().get_nodes_in_group("blocks").size()
	bgm.play()
	
	#get_tree().paused = true
	#dialog_player.start_dialog()
	

func _process(delta: float) -> void:
	card_tilemap.check_overlap(yinyang_orb.position)
	
	time_left -= 24 * delta
	if time_left < 200 and not running_out_of_time:
		print("harry up!")
		running_out_of_time = true
	
	if combo > max_combo:
		max_combo = combo
	
	stage_1_ui.update_score(score)
	stage_1_ui.update_graze_count(graze_count)
	stage_1_ui.update_combo(combo)
	stage_1_ui.update_max_combo(max_combo)
	stage_1_ui.update_time_left(time_left)
	
	if blocks_remaining == 0 and all_cards_turned:
		stage_complete()
	
	if time_left <= 0:
		game_over()
		

func game_over() -> void:
	print("game over")
	get_tree().paused = true
	dialog_player.start_dialog()

func life_down() -> void:
	player_lives -= 1
	stage_1_ui.life_down()
	
	if player_lives <= 0:
		game_over()
	

func stage_complete() -> void:
	print("stage 1 complete")
	await get_tree().create_timer(1).timeout
	get_tree().paused = true
	dialog_player.start_dialog()
	
