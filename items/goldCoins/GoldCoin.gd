extends Area2D


func _on_body_entered(body):
	if body is Player:
		GameManager.gain_gold_coin(1)
		queue_free()	
