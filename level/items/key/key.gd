extends CharacterBody2D

@export var isWaiting = true
@export var target: Player

const SPEED = 100.0
const JUMP_VELOCITY = -400.0


func _physics_process(delta):
	if !isWaiting && !target.hasKey: queue_free()
	
	_calculate_velocity()

	move_and_slide()


func _calculate_velocity():
	if isWaiting: return

	var followPosition = target.followObjects + 1
	var targetPosition = target.global_position - Vector2(0, -8)

	if global_position.distance_to(targetPosition) > 20 * followPosition:
		var direction = (targetPosition - global_position).normalized()
		velocity = direction * SPEED
		velocity.y *= 3
	elif (global_position.y - targetPosition.y) < -2 || (global_position.y - targetPosition.y) > 2:
		velocity.x = 0
	else: velocity = Vector2.ZERO


func _on_key_body_entered(body):
	if body is Player && isWaiting: 
		body.hasKey = true
		isWaiting = false
		
