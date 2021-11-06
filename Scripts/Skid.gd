extends Sprite

var anim_frame = 0

func _physics_process(_delta):
	anim_frame += 0.2
	frame = anim_frame
	
	if frame >= 2:
		queue_free()
