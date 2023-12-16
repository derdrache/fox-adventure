extends StaticBody2D

var stomped = false



func _process(delta):
	if stomped: 
		$Sprite2D.frame = 1
		$CollisionShapeNormal.disabled = true
		$CollisionShapeStomped.disabled = false
		


func _on_area_2d_body_entered(body):
	if body is Player:
		if body.state == 7: stomped = true
