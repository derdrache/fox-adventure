extends Area2D
class_name Switch

@export var multiUse = false

var used = false

func _on_body_entered(body):
	if body is Player:
		$Sprite2D.frame = 1
		
		if multiUse: used = !used
		else: used = true
		
