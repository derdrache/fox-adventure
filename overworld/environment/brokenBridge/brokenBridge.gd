extends StaticBody2D

var isComplete = false
		
func _process(_delta):
	if isComplete: $bridgeBody.visible = true
		

func _on_area_2d_body_entered(body):
	if body is Duck:
		await get_tree().create_timer(1).timeout
		$bridgeBody.visible = true
		$CollisionShape2D.disabled = true
