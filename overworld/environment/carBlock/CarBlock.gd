extends Path2D

@onready var pathFollow = $PathFollow2D
@onready var sprite = $PathFollow2D/CarBlockBody/Sprite2D
@onready var animatedSprite = $PathFollow2D/CarBlockBody/AnimatedSprite2D

var doMove = false
var moveSpeed = 50


func _physics_process(delta):
	if doMove: pathFollow.progress += moveSpeed * delta


func _on_area_2d_body_entered(body):
	if "Duck" in body.name:
		await get_tree().create_timer(2).timeout
		sprite.visible = false
		body.queue_free()
		animatedSprite.visible = true
		animatedSprite.play("front")
		doMove = true	
