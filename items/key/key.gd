extends Area2D
class_name Key

@export var activeCollision = true


func _process(_delta):
	if not activeCollision: $CollisionShape2D.set_deferred("disabled", true)

func delete():
	queue_free()
