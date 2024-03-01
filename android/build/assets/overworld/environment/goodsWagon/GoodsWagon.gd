extends Path2D

@onready var pathFollow = $PathFollow2D
@onready var sprite = $PathFollow2D/GoodsWagonBody/SpriteDuck

@export var flipH = false

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
		sprite.flip_h = flipH
		sprite.visible = true
		pathFollow.progress += moveSpeed * delta
	
	if pathFollow.progress_ratio == 1 && doMove:
		doMove = false
		emit_signal("interactionDone")	 

func _on_area_2d_body_entered(body):
	if "Duck" in body.name:
		duckBody = body
		doMove = true		

func done():
	queue_free()
