extends TileMap

func check_overlap(orb_pos: Vector2):
	var current_tile_coords: Array[Vector2i] = [
		local_to_map(floor(orb_pos)),
		local_to_map(ceil(orb_pos))
	]
	
	for coord in current_tile_coords:
		if get_cell_source_id(0, coord) != -1:
			set_cell(0, coord, -1)
			if randi_range(0, 100) > 60:
				print("shoot bullet")
