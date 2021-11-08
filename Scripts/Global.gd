extends Node


var multiplier = 2

var grid = []
var width = 100
var height = 40

var coin = preload("res://Scenes/Coin.tscn")
var temp

var save_format = 2

var tiles = [
	[-1, Vector2(0, 0)],
	[ 3, Vector2(0, 0)],
	[ 3, Vector2(1, 0)],
	[ 1, Vector2(0, 0)],
	[ 2, Vector2(0, 0)],
	[ 0, Vector2(0, 0)],
	[-2, coin],
]


func _ready():
	if width < 32: width = 32
	if height < 19: height = 19
	
	load_data()


func load_tiles(tilemap):
	yield(get_tree(), "idle_frame")
	for x in width:
		for y in height:
			tilemap.set_tile(
				x,
				-1 - y,
				tiles[grid[x][y]][0],
				false, false, false,
				tiles[grid[x][y]][1]
			)
	tilemap.update_bitmask_region(Vector2(0, -1), Vector2(Global.width, -1 - Global.height))


func generate():
	for x in width:
		grid.append([])
		for y in height:
			grid[x].append(0)
	
	for x in width:
		grid[x][0] = 3
		grid[x][height - 1] = 2
	
	for y in height:
		grid[0][y] = 2
		grid[width - 1][y] = 2


func check_data(file):
	return file.file_exists("user://data.dat")
#	return false


func load_data():
	var file = File.new()
	
	if check_data(file):
		file.open("user://data.dat", File.READ)
		grid = JSON.parse(file.get_as_text()).result
		file.close()
	else:
		generate()


func save_data():
	var file = File.new()
	
	file.open("user://data.dat", File.WRITE)
	file.store_string(JSON.print(grid))
	file.close()
