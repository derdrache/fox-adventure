extends Area2D



func _on_body_entered(body):
	if body is Duck:
		$Sprite2D.visible = false
		$CollisionShape2D.disabled = true
