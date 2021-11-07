extends Node2D


var pos
var temp


func set_cell(x, y, coin):
	pos = str(x) + " " + str(y)
	if get_node_or_null(pos):
		if !coin:
			get_node(pos).queue_free()
	else:
		if coin:
			temp = Global.tiles[6][1].instance()
			temp.position.x = clamp(x, 0, Global.width - 1) * 32 + 16
			temp.position.y = clamp(y, -1 -Global.height, 0) * 32 + 16
			temp.name = pos
			
			add_child(temp)
