extends Area2D

func _on_body_entered(body):
	if body is Player:
		GameManager.gain_gem(1)
		queue_free()
