extends TileMap


signal coin_placed(coin)

onready var coin_grid = $"Coin Grid"


func set_tile(x, y, tile, flip_x, flip_y, transpose, autotile_coord):
	if tile == -2:
		set_cell(x, y, Global.tiles[0][0], flip_x, flip_y, transpose, Global.tiles[0][1])
		coin_grid.set_cell(x, y, true)
		emit_signal("coin_placed", get_node("Coin Grid/" + str(x) + " " + str(y)))
	else:
		set_cell(x, y, tile, flip_x, flip_y, transpose, autotile_coord)
		coin_grid.set_cell(x, y, false)
