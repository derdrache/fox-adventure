extends StaticBody2D

func done():
	queue_free()

func _on_area_2d_body_entered(body):
	if "Duck" in body.name:
		await get_tree().create_timer(1.6).timeout
		visible = false
		$CollisionShape2D.disabled = true
