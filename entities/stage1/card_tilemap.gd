extends TileMap
class_name CardTileMap

@onready var stage_1: Stage1 = get_parent()

var cards_remaining: int
var card_close_sprite_preload = preload("res://entities/stage1/card_close_sprite.tscn")
var score_label_preload = preload("res://entities/stage1/score_label.tscn")

func _ready() -> void:
	cards_remaining = get_used_cells(0).size()

func check_overlap(orb_pos: Vector2) -> void:
	if stage_1.all_cards_turned: return
	
	var current_tile_coords: Array[Vector2i] = [
		local_to_map(floor(orb_pos)),
		local_to_map(ceil(orb_pos))
	]
	
	for coord in current_tile_coords:
		if get_cell_source_id(0, coord) == 1:
			set_cell(0, coord, -1)
			cards_remaining -= 1
			
			var card_close_sprite: CardCloseSprite = card_close_sprite_preload.instantiate()
			card_close_sprite.position = map_to_local(coord)
			add_child(card_close_sprite)
			
			stage_1.combo += 1
			var score = 100 * stage_1.combo
			stage_1.score += score
			
			var score_label: ScoreLabel = score_label_preload.instantiate()
			score_label.text = str(score)
			score_label.global_position = orb_pos
			stage_1.add_child(score_label)
			
			if randi_range(0, 100) > 60:
				print("shoot bullet")
			
	
	if cards_remaining <= 0:
		stage_1.all_cards_turned = true
	
