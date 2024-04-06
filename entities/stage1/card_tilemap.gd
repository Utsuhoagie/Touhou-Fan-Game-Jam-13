extends TileMap
class_name CardTileMap

@onready var stage_1: Stage1 = get_parent()

var score_label_preload = preload("res://entities/stage1/score_label.tscn")


func check_overlap(orb_pos: Vector2):
	var current_tile_coords: Array[Vector2i] = [
		local_to_map(floor(orb_pos)),
		local_to_map(ceil(orb_pos))
	]
	
	for coord in current_tile_coords:
		if get_cell_source_id(0, coord) != -1:
			set_cell(0, coord, -1)
			
			stage_1.combo += 1
			var score = 100 * stage_1.combo
			stage_1.score += score
			
			var score_label: ScoreLabel = score_label_preload.instantiate()
			score_label.text = str(score)
			score_label.global_position = orb_pos
			stage_1.add_child(score_label)
			
			if randi_range(0, 100) > 60:
				print("shoot bullet")
	
