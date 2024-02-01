extends Area2D



func _on_body_entered(body):
	if "Player" in body.name:
		$TileMap.visible = false
		set_collision_layer_value(1, false)
