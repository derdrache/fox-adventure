extends Path2D

@onready var pathFollow : PathFollow2D = $PathFollow2D

@export var moving_speed = 50

func _physics_process(delta):
	pathFollow.progress += moving_speed * delta
