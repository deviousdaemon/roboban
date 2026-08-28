class_name LevelTileMap extends TileMapLayer

func get_wall_positions() -> Array[Vector2i]:
	var positions: Array[Vector2i]
	var used_rect: Rect2i = get_used_rect()
	for y in range(used_rect.position.y, used_rect.end.y):
		for x in range(used_rect.position.x, used_rect.end.x):
			var tile_data: TileData = get_cell_tile_data(Vector2i(x, y))
			if tile_data:
				if tile_data.get_custom_data("is_wall"):
					positions.append(Vector2i(x, y))
	return positions
