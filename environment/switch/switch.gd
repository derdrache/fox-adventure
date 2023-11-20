extends Area2D

var used = false

func _on_body_entered(body):
	if body is Player:
		$Sprite2D.frame = 1
		used = true
