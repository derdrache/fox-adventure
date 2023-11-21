extends Area2D
class_name MoveOWTile


func enable():
	$CollisionShape2D.disabled = false
	
func disable():
	$CollisionShape2D.disabled = true
