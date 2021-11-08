extends Control


var saved
var loaded

var v2_key = "abcdefghijklmnopqrstuvwxyz"
var v2_key_len = len(v2_key)

var digits = "0123456789"
var digits_len = len(digits)

var v2_encode_res = ""
var v2_encode_counter = 0
var v2_decode_res = 0

var v2_length = ""
var v2_tile = 0

var lt = true

var v2_load = 0


func v2_encode(num):
	if !num: return v2_key[0]
	
	v2_encode_res = ""
	v2_encode_counter = 0
	
	while num >= pow(v2_key_len, v2_encode_counter):
		v2_encode_res = v2_key[int(num / pow(v2_key_len, v2_encode_counter)) % v2_key_len] + v2_encode_res
		v2_encode_counter += 1
	
	return v2_encode_res

func v2_decode(string):
	v2_decode_res = 0
	
	for chr in string:
		v2_decode_res *= v2_key_len
		v2_decode_res += v2_key.find(chr)
	
	return v2_decode_res


func _on_Play_pressed():
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Scenes/Game Scene.tscn")


func _on_Edit_pressed():
# warning-ignore:return_value_discarded
	get_tree().change_scene("res://Scenes/Edit Scene.tscn")


func _on_Quit_pressed():
	get_tree().quit()


func _on_Save_pressed():
	if Global.save_format == 1:
		saved = "V1;" + str(Global.width) + ";" + str(Global.height) + ";"
		
		for x in Global.width:
			for y in Global.height:
				if (x or y) and Global.grid[x][y]: saved += ","
				if Global.grid[x][y]:
					saved += str(x) + "." + str(y) + "." + str(Global.grid[x][y])
		
		OS.clipboard = saved + ";"
	elif Global.save_format == 2:
		saved = "V2;" + v2_encode(Global.width) + ";" + v2_encode(Global.height) + ";"
		v2_length = 0
		v2_tile = Global.grid[0][0]
		
		for y in Global.height:
			for x in Global.width:
				if v2_tile == Global.grid[x][y]:
					v2_length += 1
				else:
					saved += str(v2_tile)
					saved += v2_encode(v2_length)
					
					v2_length = 1
					v2_tile = Global.grid[x][y]
		
		saved += str(v2_tile)
		saved += v2_encode(v2_length)
		
		OS.clipboard = saved + ";"


func _on_Load_pressed():
	loaded = Array(OS.clipboard.split(";"))
	
	if loaded[0] == "V1":
		loaded[3] = Array(loaded[3].split(","))
		for i in len(loaded[3]):
			loaded[3][i] = Array(loaded[3][i].split("."))
		
		Global.width = int(loaded[1])
		Global.height = int(loaded[2])
		
		Global.grid = []
		
		for x in Global.width:
			Global.grid.append([])
			for y in Global.height:
				Global.grid[x].append(0)
				for i in loaded[3]:
					if int(i[0]) == x and int(i[1]) == y:
						Global.grid[x][y] = int(i[2])
						break
	elif loaded[0] == "V2":
		Global.width = v2_decode(loaded[1])
		Global.height = v2_decode(loaded[2])
		
		Global.grid = []
		
		for x in Global.width:
			Global.grid.append([])
			for y in Global.height:
				Global.grid[x].append(0)
		
		v2_length = ""
		v2_tile = 0
		v2_load = 0
		
		for i in loaded[3]:
			if i in digits:
				if !lt:
					for j in v2_decode(v2_length):
						Global.grid[v2_load % Global.width][int(v2_load / Global.width)] = v2_tile
						v2_load += 1
					
					v2_length = ""
					v2_tile = 0
				
				lt = true
				v2_tile *= digits_len
				v2_tile += int(i)
			elif i in v2_key:
				lt = false
				v2_length += i
	
	Global.save_data()
