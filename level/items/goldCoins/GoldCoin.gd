extends Area2D

@export var hasRedCoin = false

var collected = false

func _on_body_entered(body):
	if body is Player && !collected:
		
		collected = true
		
		if hasRedCoin:
			$specialItemCollect.play()
			$RedCoinSprite.visible = true
			LevelManager.gain_red_coin(1)
		else: 
			$normalItemCollect.play()
			hide()
			LevelManager.gain_gold_coin(1)



func _on_audio_stream_player_2d_finished():
	queue_free()
