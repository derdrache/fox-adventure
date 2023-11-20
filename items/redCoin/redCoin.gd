extends Area2D


func _on_body_entered(body):
	if body is Player:
		LevelManager.gain_red_coin(1)
		queue_free()
