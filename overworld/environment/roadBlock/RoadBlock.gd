extends Area2D



func _on_body_entered(body):
	if "Duck" in body.name:
		$Sprite2D.visible = false
		$CollisionShape2D.disabled = true
