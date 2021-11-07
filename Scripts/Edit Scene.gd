extends Node2D


onready var tiles = $Tiles
onready var selected_tile = $"Selected Tile"
onready var chosen_tile = $CanvasLayer/Control/VBoxContainer/Control/Sprite/Sprite

var hovered_tile = Vector2.ZERO
var brush = 1

var temp
var coin_grid = []

func _ready():
	Global.load_tiles(tiles)
	
	for x in Global.width:
		coin_grid.append([])
		for y in Global.height:
			coin_grid[x].append(false)


func set_cell(cell, type):
	Global.grid[cell.x][cell.y] = type
	
	tiles.set_tile(
		cell.x,
		-1 - cell.y,
		Global.tiles[Global.grid[cell.x][cell.y]][0],
		false, false, false,
		Global.tiles[Global.grid[cell.x][cell.y]][1]
	)
	tiles.update_bitmask_region(cell, cell)


func _physics_process(_delta):
	if Input.is_action_just_pressed("ui_cancel"):
		Global.save_data()
# warning-ignore:return_value_discarded
		get_tree().change_scene("res://Scenes/Main Scene.tscn")
	
	hovered_tile = get_global_mouse_position() / 32
	hovered_tile.x = clamp(int(hovered_tile.x), 0, Global.width - 1)
	hovered_tile.y = clamp(-int(hovered_tile.y), 0, Global.height - 1)
	
	if Input.is_mouse_button_pressed(1):
		set_cell(hovered_tile, brush)
	
	if Input.is_mouse_button_pressed(2):
		set_cell(hovered_tile, 0)
	
	selected_tile.position.x = hovered_tile.x * 32 + 16
	selected_tile.position.y = -(hovered_tile.y * 32 + 16)
	
	if Input.is_key_pressed(KEY_1):
		brush = 1
	if Input.is_key_pressed(KEY_2):
		brush = 2
	if Input.is_key_pressed(KEY_3):
		brush = 3
	if Input.is_key_pressed(KEY_4):
		brush = 4
	if Input.is_key_pressed(KEY_5):
		brush = 5
	if Input.is_key_pressed(KEY_6):
		brush = 6
	
	selected_tile.frame = brush - 1
	chosen_tile.offset.x = 32 * ((-(float(selected_tile.hframes) / 2.0) + (brush - 1)) + 0.5)
	
