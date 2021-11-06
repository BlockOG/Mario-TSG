extends Camera2D


export(float) var speed_mul = 6

var speed = Vector2.ZERO

var left_right = 0
var up_down = 0


func _physics_process(_delta):
	speed = Vector2.ZERO
	
	# ---------------------------------------------
	# X
	
	left_right = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	
	speed.x += left_right
	
	# ---------------------------------------------
	# Y
	
	up_down = int(Input.is_action_pressed("move_down")) - int(Input.is_action_pressed("move_up"))
	
	speed.y += up_down
	
	# ---------------------------------------------
	# Moving
	
	speed = speed.normalized() * speed_mul
	
	position.x = clamp(position.x + speed.x, 0, Global.width * 32)
	position.y = clamp(position.y + speed.y, -1 - Global.height * 32, 0)
	
