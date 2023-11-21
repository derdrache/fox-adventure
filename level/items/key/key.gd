extends Area2D

@export var activeCollision = true


func _process(_delta):
	if not activeCollision: $CollisionShape2D.set_deferred("disabled", true)

func _on_body_entered(body):
	if body is Player:
		body.pickupKey()
		queue_free()
