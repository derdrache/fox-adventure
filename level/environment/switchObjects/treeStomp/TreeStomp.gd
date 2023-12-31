extends StaticBody2D


var used = true


func _process(delta):
	if used: 
		$Sprite2D.frame = 1
		$CollisionShapeNormal.disabled = true
		$CollisionShapeStomped.disabled = false
		


func _on_area_2d_body_entered(body):
	if body is Player:
		var stompedState = 7
		if body.state == stompedState: used = true 
