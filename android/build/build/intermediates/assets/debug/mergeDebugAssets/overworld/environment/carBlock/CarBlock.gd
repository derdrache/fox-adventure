extends Path2D

@onready var pathFollow = $PathFollow2D
@onready var sprite = $PathFollow2D/CarBlockBody/Sprite2D
@onready var animatedSprite = $PathFollow2D/CarBlockBody/AnimatedSprite2D

var doMove = false
var moveSpeed = 50
var duckBody
var sendSignal = false

signal interactionStart
signal interactionDone

func _physics_process(delta):
	if doMove && duckBody == null:
		if !sendSignal:
			sendSignal = true
			emit_signal("interactionStart")
		animatedSprite.visible = true
		animatedSprite.play("front")
		pathFollow.progress += moveSpeed * delta
	
	if pathFollow.progress_ratio == 1 && doMove:
		doMove = false
		emit_signal("interactionDone")	 

func done():
	queue_free()

func _on_area_2d_body_entered(body):
	if "Duck" in body.name:
		duckBody = body
		doMove = true	
