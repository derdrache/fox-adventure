extends Area2D
class_name Switch

var is_open = false

func change_status():
	if is_open:
		$Sprite2D.frame = 0
		is_open = false
	else:
		$Sprite2D.frame = 1
		is_open = true
	
