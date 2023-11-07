extends CharacterBody2D
class_name TreeStomp


var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

const SPEED = 100.0

var playerDirection = Vector2.ZERO
var moves = 0


func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	
	if moves > 0:
		velocity.x = playerDirection.x * SPEED
		$Sprite2D.rotate(playerDirection.x * 0.2)
		moves -= 1
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
		

func move(direction):
	playerDirection = direction
	moves += 1


func _on_area_2d_body_entered(body):
	if body is Player:
		playerDirection = body.getPlayerDirection()
		
		if playerDirection.x != 0:
			move(playerDirection)
