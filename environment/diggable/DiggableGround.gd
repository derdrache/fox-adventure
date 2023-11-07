extends StaticBody2D
class_name DiggableGround

func digAway():
	await get_tree().create_timer(0.5).timeout
	queue_free()
	return false
