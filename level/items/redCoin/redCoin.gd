extends Area2D


func _on_body_entered(body):
	if body is Player:
		LevelManager.gain_red_coin(1)
		$AudioStreamPlayer2D.play()
		await get_tree().create_timer(0.1).timeout
		queue_free()
