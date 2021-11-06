extends Node2D


export(PackedScene) var skid_particle = preload("res://Scenes/Skid.tscn")

onready var tiles = $Tiles
onready var player = $Player
onready var particles = $Particles


func _ready():
	Global.load_tiles(tiles)


func _on_Player_skid():
	var skid = skid_particle.instance()
	skid.position.x = player.position.x
	skid.position.y = player.position.y + 20
	particles.add_child(skid)


func _process(_delta):
	if Input.is_action_just_pressed("ui_cancel"):
# warning-ignore:return_value_discarded
		get_tree().change_scene("res://Scenes/Main Scene.tscn")
