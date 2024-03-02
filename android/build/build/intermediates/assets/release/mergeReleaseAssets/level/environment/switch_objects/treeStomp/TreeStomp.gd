extends StaticBody2D
class_name treeStomp

var used = false


func _process(_delta):
	if used: 
		$Sprite2D.frame = 1
		$CollisionShapeNormal.disabled = true
		

func _on_area_2d_body_entered(body):
	if body is Player:
		var stompedState = 7
		if body.state == stompedState && !used: 
			$AudioStreamPlayer.play()
			used = true
