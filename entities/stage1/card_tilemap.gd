extends TileMap

func check_overlap(orb_pos: Vector2):
	var current_tile_coords: Vector2i = local_to_map(orb_pos)
	if get_cell_source_id(0, current_tile_coords) != -1:
		set_cell(0, current_tile_coords, -1)
	
	if randi_range(0, 40) > 40:
		print("shoot bullet")
