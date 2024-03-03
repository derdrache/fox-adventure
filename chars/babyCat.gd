extends CharacterBody2D

@onready var whiteCatAnimationsSprite = $whiteCat
@onready var yellowCatAnimationsSprite = $yellowCat
@onready var BlackCatAnimationsSprite = $blackCat
@onready var brownCatAnimationsSprite = $brownCat
@onready var blueCatAnimationsSprite = $blueCat
@onready var berryCatAnimationsSprite = $berryCat
@onready var area2D : Area2D = $Area2D
@onready var pickUpMessage = $HeartAnimation
@onready var meowMessage = $MeowMessage
@onready var audioPlayer = $AudioStreamPlayer2D
@onready var rayCast = $RayCast2D

@export var target: Player
@export var isWaiting = true

const MAX_SPEED = 100

var speed = 100

var animationSprite : AnimatedSprite2D
var followPosition = 0	
var catColorArray : Array
var rng = RandomNumberGenerator.new()


func _ready():
	catColorArray = [whiteCatAnimationsSprite, yellowCatAnimationsSprite, BlackCatAnimationsSprite, 
	brownCatAnimationsSprite, blueCatAnimationsSprite, berryCatAnimationsSprite]
	
	#Luna & Stella spezial
	if name == "Cat1" || name == "Cat2": catColorArray.remove_at(2) 
	
	whiteCatAnimationsSprite.visible = false
	
	_set_random_cat_color()

func _process(delta):
	if !isWaiting: _random_meow()

func _physics_process(delta):
	if target == null: 
		animationSprite.play("walk")
		isWaiting = false
		return
	
	speed = target.speed

	_get_moving_object_speed()
	
	_catch_up()
	
	_calculate_velocity()

	move_and_slide()
	
	_set_animation()
	
func _calculate_velocity():
	
	if isWaiting: return

	var targetPosition = target.global_position - Vector2(0, -9)
	var direction = (targetPosition - global_position).normalized()

	if global_position.distance_to(targetPosition) > 40  * followPosition:
		velocity = direction * (MAX_SPEED + speed)
		if !target.onEagle: velocity.y *= 3		
	elif global_position.distance_to(targetPosition) > 20  * followPosition:
		velocity = direction * (speed)
		if !target.onEagle: velocity.y *= 3
	elif (global_position.y - targetPosition.y) < -5 || (global_position.y - targetPosition.y) > 5:
		velocity.y = direction.y * (speed / 16 * abs(global_position.y - targetPosition.y))
		velocity.x = 0
	elif (global_position.y - targetPosition.y) < -0.3 || (global_position.y - targetPosition.y) > 0.3:
		pass
	else: velocity = Vector2.ZERO
	
	if target.rampType != null:
		if target.rampType == "rampLeft" && target.velocity.x > 0: velocity *= 0.9
		elif target.rampType == "rampRight" && target.velocity.x < 0: velocity *= 0.9
	
func _set_animation():
	if isWaiting || target.velocity == Vector2.ZERO: 
		animationSprite.play("idle")
		return
	
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

func _catch_up():
	var catchUpRange = 300
	
	if isWaiting: return
	
	if global_position.distance_to(target.global_position) > catchUpRange:
		global_position = target.global_position - Vector2(0, -8)

func _show_pick_up_message():
	pickUpMessage.visible = true
	pickUpMessage.play("heart")
	await get_tree().create_timer(2).timeout
	pickUpMessage.visible = false

func _random_meow():
	var randomNumber = rng.randi_range(0.0, 5000.0)
	if randomNumber == 1:
		meowMessage.visible = true
		audioPlayer.play()
		await get_tree().create_timer(2).timeout
		meowMessage.visible = false

func _get_moving_object_speed():
	if target.movingObjectSpeed:
		speed = target.movingObjectSpeed

func _on_area_2d_body_entered(body):
	if body is Player && isWaiting:
		var catNumber = int(name.replace("Cat", ""))
		isWaiting = false
		$AudioStreamPlayer2D.play()
		area2D.set_collision_layer_value(1, false)
		followPosition = body.followObjects + 1
		body.followObjects += 1
		LevelManager.gain_cat(catNumber)
		_show_pick_up_message()
