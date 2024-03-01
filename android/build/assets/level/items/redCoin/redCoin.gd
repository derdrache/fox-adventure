extends Area2D

var collected = false

func _on_body_entered(body):
	if body is Player && !collected:
		collected = true
		LevelManager.gain_red_coin(1)
		hide()
		$AudioStreamPlayer2D.play()
		


func _on_audio_stream_player_2d_finished():
	queue_free()
