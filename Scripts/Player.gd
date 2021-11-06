extends KinematicBody2D


signal skid

onready var sprite = $Sprite
onready var ray = $RayCast2D
onready var tilemap = get_parent().get_node("Tiles")
onready var coins_label = $CanvasLayer/Control/Coins


export(float) var stop_speed = 0.4
export(float) var jump_speed = 11

export(float) var falling_add = 1
export(float) var jumping_add = 1

export(float) var gravity_limit = 22
export(float) var speed_limit = 10

export(float) var turn_accel = 0.8
export(float) var speed_accel = 0.4

export(int) var jump_frames = 11


var speed = Vector2()
var falling = 99
var jumping = 99

var left_right = 0
var ud = 0

var jump = false
var dont_jump = false

enum states {
	turn
	walk
	idle
	jump
	fall
}

var walk_frame = 0
var state = states.idle
var temp = 0

var skid_frame = 0

var coins = 0

func _ready():
	$Camera2D.limit_right = 32 * Global.width
	$Camera2D.limit_top = -32 * Global.height
	
	jump_frames *= jumping_add


func _physics_process(delta):
	# ---------------------------------------------
	# Walk Physics
	
	left_right = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	
	state = states.walk
	
	if !left_right:
		if falling < 2:
			if speed.x > stop_speed:
				speed.x -= stop_speed
			else:
				if speed.x < -stop_speed:
					speed.x += stop_speed
				else:
					speed.x = 0
	else:
		sprite.flip_h = left_right == -1
		
		if left_right * speed.x < speed_limit:
			if left_right * speed.x < 0:
				state = states.turn
				
				if !(skid_frame % 3) and is_on_floor():
					emit_signal("skid")
				
				skid_frame += 1
				
				speed.x += left_right * turn_accel
			else:
				skid_frame = 0
				
				speed.x += left_right * speed_accel
	
	# ---------------------------------------------
	# Jumping And Gravity Physics
	
	if is_on_ceiling():
		jump = false
	
	if is_on_floor():
		jumping = 0
		falling = 0
		dont_jump = false
	else:
		falling += falling_add
	
	speed.y += 1
	
	if Input.is_action_just_pressed("move_up"):
		jump = true
	
	if Input.is_action_just_released("move_up"):
		jump = false
		dont_jump = true
	
	if speed.y > gravity_limit: speed.y = gravity_limit
	
	if jump and (falling < 2 or jumping > 0) and !dont_jump:
			jumping += jumping_add
			if jumping < jump_frames:
				speed.y = -jump_speed
			else:
				jump = false
	
	# ---------------------------------------------
	# Drop Through Tiles
	
	if ray.is_colliding() and Input.is_action_pressed("move_down"):
			var tile = tilemap.get_cellv(tilemap.world_to_map(ray.get_collision_point()))
			if tile == 2:
				position.y += 1
	
	# ---------------------------------------------
	# Animation
	
	if !speed.x:
		state = states.idle
	
	if falling:
		if speed.y < 0:
			state = states.jump
		else:
			state = states.fall
	
	temp = abs(speed.x) / 19
	if temp < 0.2:
		temp = 0.2
	walk_frame += temp
	
	match state:
		states.idle:
			sprite.frame = 0
			walk_frame = 0
		states.walk:
			sprite.frame = int(walk_frame) % 4
		states.turn:
			sprite.frame = 4
		states.jump:
			sprite.frame = 5
		states.fall:
			sprite.frame = 6
	
	# ---------------------------------------------
	# Moving
	
	speed = move_and_slide(speed / delta, Vector2.UP) * delta
	
	if position.y > 0:
		position = Vector2(300, -300)
	


func pickup_coin():
	coins += 1
	coins_label.text = "Coins: " + str(coins)
