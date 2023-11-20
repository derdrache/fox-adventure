extends Area2D
class_name Liane

@export var canSwing = false

var changeRotation = 0
var changeDirection = false


func _physics_process(delta):
	if !canSwing || name != "liane": return
	
	var parentNode = get_parent()
	
	var newRotation = 0.2 * delta
	
	if changeRotation <= -0.5:
		changeDirection = true
	elif changeRotation >= 0.5:
		changeDirection = false
		
		
	if !changeDirection:
		changeRotation -= newRotation
		parentNode.rotation -= newRotation
	else:
		changeRotation += newRotation
		parentNode.rotation += newRotation	
