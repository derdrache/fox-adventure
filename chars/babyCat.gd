extends CharacterBody2D

@onready var whiteCatAnimationsSprite = $whiteCat
@onready var yellowCatAnimationsSprite = $yellowCat
@onready var BlackCatAnimationsSprite = $blackCat
@onready var brownCatAnimationsSprite = $brownCat
@onready var blueCatAnimationsSprite = $blueCat
@onready var berryCatAnimationsSprite = $berryCat

@export var target: Player
@export var isWaiting = true

const SPEED = 100.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var animationSprite : AnimatedSprite2D


func _ready():
	whiteCatAnimationsSprite.visible = false
	_selectCatColor()

func _physics_process(delta):
	_move()
	
	move_and_slide()
	
	_set_animation()
	
func _move():
	if isWaiting: return
	
	var catNumber = int(name.replace("Cat", ""))
	var catMultiplicator = 1 if catNumber == 0 else catNumber

	var targetPosition = target.position - Vector2(0, -9)

	if position.distance_to(targetPosition) > 20 * catMultiplicator:
		var direction = (targetPosition - position).normalized()
		velocity = direction * SPEED
		velocity.y *= 3
	elif (position.y - targetPosition.y) < -0.5 || (position.y - targetPosition.y) > 0:
		velocity.x = 0
	else: velocity = Vector2.ZERO

func _set_animation():
	if isWaiting: return
	
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

func _selectCatColor():
	var catColorArray = [whiteCatAnimationsSprite, yellowCatAnimationsSprite, BlackCatAnimationsSprite, 
	brownCatAnimationsSprite, blueCatAnimationsSprite, berryCatAnimationsSprite]
	var rng = RandomNumberGenerator.new()
	var randomNumber = rng.randi_range(0, 5)
	
	animationSprite = catColorArray[randomNumber]
	animationSprite.visible = true



func _on_area_2d_body_entered(body):
	if body is Player && isWaiting:
		isWaiting = false
