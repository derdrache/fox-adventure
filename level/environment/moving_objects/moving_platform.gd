extends Path2D

@export var moving_speed = 50

func _physics_process(delta):
	$PathFollow2D.progress += moving_speed * delta
	
