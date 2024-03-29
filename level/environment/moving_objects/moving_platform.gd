extends Path2D
class_name MovingPlatform

@export var moving_speed = 50

var doMove = false

func _ready():
	doMove = !has_node("Area2D")
	

func _physics_process(delta):
	if doMove: $PathFollow2D.progress += moving_speed * delta
	

func _on_area_2d_body_entered(body):
	if "Player" in body.name && !doMove:
		doMove = true
		$PathFollow2D.progress_ratio = 0.5
