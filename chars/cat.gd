extends CharacterBody2D

@onready var animationSprite = $AnimatedSprite2D

@export var target: Player

const SPEED = 100.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	_move()
	
	move_and_slide()
	
	_set_animation()
	
func _move():
	var catMultiplicator = int(name.replace("Cat", ""))
	if catMultiplicator == 0: catMultiplicator = 1

	var targetPosition = target.position - Vector2(0, -9)

	if position.distance_to(targetPosition) > 20 * catMultiplicator:
		var direction = (targetPosition - position).normalized()
		velocity = direction * SPEED
		velocity.y *= 3
	elif (position.y - targetPosition.y) < -0.5 || (position.y - targetPosition.y) > 0:
		velocity.x = 0
	else: velocity = Vector2.ZERO

func _set_animation():
	var targetPosition = target.position - Vector2(0, -9)

	if velocity.x > 0: animationSprite.flip_h = false
	elif velocity.x < 0: animationSprite.flip_h = true
	
	var not_on_floor = (position.y - targetPosition.y) < -1.0 || (position.y - targetPosition.y) > 0
	
	if not target.is_on_floor() || not_on_floor:
		if targetPosition.y < position.y: animationSprite.play("jumpUp")
		else: animationSprite.play("jumpDown")
	elif velocity != Vector2.ZERO:
		animationSprite.play("walk")
	else: animationSprite.play("idle")
