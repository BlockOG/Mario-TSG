extends Camera2D


export(float) var speed_mul = 6

var speed = Vector2.ZERO

var left_right = 0
var up_down = 0


func _physics_process(_delta):
	# ---------------------------------------------
	# Moving
	
	speed = Input.get_vector("move_left", "move_right", "move_up", "move_down").normalized() * speed_mul
	
	position.x = clamp(position.x + speed.x, 0, Global.width * 32)
	position.y = clamp(position.y + speed.y, -1 - Global.height * 32, 0)
	
