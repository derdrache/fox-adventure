extends Area2D

@export var hasRedCoin = false


func _on_body_entered(body):
	if body is Player:
		if hasRedCoin:
			$RedCoinSprite.visible = true
			await get_tree().create_timer(0.5).timeout
			LevelManager.gain_red_coin(1)
			queue_free()
		else:
			LevelManager.gain_gold_coin(1)
			queue_free()	
