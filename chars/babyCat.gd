extends CharacterBody2D

@onready var whiteCatAnimationsSprite = $whiteCat
@onready var yellowCatAnimationsSprite = $yellowCat
@onready var BlackCatAnimationsSprite = $blackCat
@onready var brownCatAnimationsSprite = $brownCat
@onready var blueCatAnimationsSprite = $blueCat
@onready var berryCatAnimationsSprite = $berryCat
@onready var area2D : Area2D = $Area2D

@export var target: Player
@export var isWaiting = true

const SPEED = 100.0
const JUMP_VELOCITY = -400.0

var animationSprite : AnimatedSprite2D
var followPosition = 0	
var catColorArray : Array


func _ready():
	catColorArray = [whiteCatAnimationsSprite, yellowCatAnimationsSprite, BlackCatAnimationsSprite, 
	brownCatAnimationsSprite, blueCatAnimationsSprite, berryCatAnimationsSprite]
	
	#Luna spezial
	if name == "Cat1": catColorArray.remove_at(2) 
	
	whiteCatAnimationsSprite.visible = false
	
	_set_random_cat_color()

func _physics_process(delta):
	_calculate_velocity()
	
	move_and_slide()
	
	_set_animation()
	
func _calculate_velocity():
	if isWaiting: return

	var targetPosition = target.global_position - Vector2(0, -9)

	if global_position.distance_to(targetPosition) > 20 * followPosition:
		var direction = (targetPosition - global_position).normalized()
		velocity = direction * SPEED
		velocity.y *= 3
	elif (global_position.y - targetPosition.y) < -2 || (global_position.y - targetPosition.y) > 2:
		velocity.x = 0
	else: velocity = Vector2.ZERO

func _set_animation():
	if isWaiting: return
	
	var targetPosition = target.position - Vector2(0, -9)

	if velocity.x > 0: animationSprite.flip_h = false
	elif velocity.x < 0: animationSprite.flip_h = true
	
	var not_on_floor = (position.y - targetPosition.y) < -2 || (position.y - targetPosition.y) > 2
	
	if not target.is_on_floor() || not_on_floor:
		if targetPosition.y < position.y: animationSprite.play("jumpUp")
		else: animationSprite.play("jumpDown")
	elif velocity != Vector2.ZERO:
		animationSprite.play("walk")
	else: animationSprite.play("idle")

func _set_random_cat_color():
	var rng = RandomNumberGenerator.new()
	var randomNumber = rng.randi_range(0, len(catColorArray)-1)
	
	animationSprite = catColorArray[randomNumber]
	animationSprite.visible = true

func _set_cat_color(catNumber):
	animationSprite.visible = false
	animationSprite = catColorArray[catNumber]
	animationSprite.visible = true

func _on_area_2d_body_entered(body):
	if body is Player && isWaiting:
		var catNumber = int(name.replace("Cat", ""))
		isWaiting = false
		area2D.set_collision_layer_value(1, false)
		followPosition = body.followObjects + 1
		body.followObjects += 1
		LevelManager.gain_cat(catNumber)
