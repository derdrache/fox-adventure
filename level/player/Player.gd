extends CharacterBody2D
class_name Player

@onready var collision_check = $ShapeCast2D
@onready var collision_check_right = $RayCastRight
@onready var collision_check_left = $RayCastLeft
@onready var animationPlayer = $AnimationPlayer
@onready var enviromentAnimation = $enviromentAnimation
@onready var sprite = $Sprite2D
@onready var keySprite = $key
@onready var normalCollision = $normalCollision
@onready var crawlCollision = $crawlCollision
@onready var levelTileMap = get_node("../TileMap")


enum { MOVE , CLIMB , JUMP, STOMP, DIG, HANG, SLIDE, CRAWL, SWIM}

const SPEED = 100.0
const SWIM_SPEED = 75
const CHERRYSPEED = 200
const JUMP_VELOCITY = -300.0
const CHERRY_POWER_TIME = 5
const TILE_ABOVE_ADJUSTMENT = Vector2(0, 10)	
const TILE_UNDER_ADJUSTMENT = Vector2(0,-20)
const TILE_LEFT_ADJUSTMENT = Vector2(8, -2)
const TILE_RIGHT_ADJUSTMENT = Vector2(-8, -2)

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var state = MOVE
var hasKey = false
var switchDoors = false
var direction = Vector2.ZERO
var doStomp = false
var forceVelocityX = 0
var doDig = false
var digRotation = 0
var sliderEndCounter = 30
var slideDirection = ""
var hasCerryPower = false
var underWater = false
var lastFloorPosition = Vector2.ZERO


func _process(_delta):
	underWater = "water" in get_tile_data()
	
	interaction()
	followKey()

func _physics_process(delta):
	if is_on_floor(): lastFloorPosition = position
	direction.x = Input.get_axis("move_left", "move_right")
	direction.y = Input.get_axis( "move_up", "move_down")
	
	match state:
		MOVE, JUMP, CRAWL: move_state(delta)
		SWIM: swim_state(delta)
		CLIMB: climb_state(delta)
		DIG: dig_state()
		STOMP: stomp_state(delta)
		SLIDE: slide_state(delta)
	
	if state == CRAWL:
		normalCollision.disabled = true
		crawlCollision.disabled = false
	else:
		normalCollision.disabled = false
		crawlCollision.disabled = true
	
	animation_state()
	
	move_and_slide()
	
	
	if is_on_floor():
		forceVelocityX = 0

func apply_gravity(delta):
		if not is_on_floor():
			velocity.y += gravity * delta

func is_on_climbing_object():
	var onLadder = getShapeCollision() is Ladder
	var onClimbingTree = getShapeCollision() is ClimbingTree
	var onLiane = getShapeCollision() is Liane
	var onClimbingPalm = getShapeCollision() is ClimbingPalm
	var onWall = "climb" in get_tile_data("right") || "climb" in get_tile_data("left")
	
	return onLadder || onClimbingTree || onLiane || onClimbingPalm || onWall

func digging_object_above_or_below():	
	return "dig" in get_tile_data("top")|| "dig" in get_tile_data("bottom")

func digging_object_left_or_right():
	return "dig" in get_tile_data("left")|| "dig" in get_tile_data("right")
		
func move_state(delta):
	var moveSpeed = SPEED
	if underWater: moveSpeed = SWIM_SPEED
	if hasCerryPower: moveSpeed += CHERRYSPEED
	
	var diggingUpOrDown = digging_object_above_or_below() && (Input.is_action_pressed("move_down") || Input.is_action_pressed("move_up"))
	var diggingLeftOrRight = digging_object_left_or_right() && (Input.is_action_pressed("move_left") || Input.is_action_pressed("move_right"))
	var cantStandUp = state == CRAWL && (get_tile_data("top") == "null" 
		|| get_tile_data("top", position - TILE_RIGHT_ADJUSTMENT) == "null" 
		|| get_tile_data("top", position - TILE_LEFT_ADJUSTMENT) == "null")
		
	if  is_on_climbing_object() && (Input.is_action_pressed("move_up") || (Input.is_action_pressed("move_down") && not is_on_floor()) || (!is_on_floor() && state != JUMP)):
		state = CLIMB
	elif _canDig()  && is_on_floor() && !doDig:
		state = DIG
	elif Input.is_action_pressed("move_down") || cantStandUp:
		state = CRAWL
	elif in_water() && !is_on_floor():
		state = SWIM
	elif is_on_floor():
		state = MOVE
		doStomp = false
	elif !is_on_floor():
		state = JUMP
	
	apply_gravity(delta);
	
	
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		state = JUMP
		velocity.y = JUMP_VELOCITY

	if not is_on_floor() && Input.is_action_just_pressed("move_down"):
		state = STOMP
		doStomp = true
	
	if direction && forceVelocityX == 0:
		velocity.x = direction.x * moveSpeed
	elif forceVelocityX != 0:
		velocity.x = forceVelocityX
	else:
		velocity.x = move_toward(velocity.x, 0, moveSpeed)

func climb_state(delta):
	var tileSearchY = 10
	
	velocity = direction * 50
	
	if direction.y == -1:
		tileSearchY = 10
	elif direction.y == 1:
		tileSearchY = -10
	
	
	var canClimbRight = "climb" in get_tile_data("right") || "climb" in get_tile_data("right", position- Vector2(0, tileSearchY))
	var canClimbLeft = "climb" in get_tile_data("left") || "climb" in get_tile_data("left", position- Vector2(0, tileSearchY))
	var nextStepIsClimbable = move_and_check_climbing_object(position+ (velocity*2 * delta))
	
	var canClimb = nextStepIsClimbable || canClimbRight || canClimbLeft
	
	
	if is_on_floor():
		state = MOVE

	if !canClimb: 
		if collision_check_right.get_collider() is Ladder || collision_check_left.get_collider() is Ladder:
			state = MOVE
		else:
			velocity = Vector2.ZERO
	
	
	if Input.is_action_just_pressed("ui_accept"):
		state = JUMP
		velocity.y = JUMP_VELOCITY
		
	if _canDig():
		state = DIG
		
func stomp_state(delta):
	if is_on_floor():
		state = MOVE
		stompAnimation()
	
	if in_water():
		state = MOVE
		
	
	velocity.y += gravity*4 * delta

func dig_state():
	velocity = Vector2.ZERO
	
	if !doDig: state = MOVE
	
func slide_state(delta):
	if not "ramp" in get_tile_data("bottom"): 
		sliderEndCounter -= 1
		
	velocity.y += gravity * delta * 10
	velocity.x = sliderEndCounter * 10
	
	if slideDirection == "Left":
		velocity.x = -velocity.x
	
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		state = JUMP
		velocity.y = JUMP_VELOCITY * 1.5
	
	if sliderEndCounter == 0:
		state = MOVE
		sliderEndCounter = 30

func swim_state(_delta):
	if !in_water() || is_on_floor(): state = MOVE
	
	var diggingUpOrDown = digging_object_above_or_below() && (Input.is_action_pressed("move_down") || Input.is_action_pressed("move_up"))
	var diggingLeftOrRight = digging_object_left_or_right() && (Input.is_action_pressed("move_left") || Input.is_action_pressed("move_right"))

	if diggingUpOrDown || diggingLeftOrRight:
		state = DIG
	
	if "waterTop" in get_tile_data() && Input.is_action_just_pressed("ui_accept"):
		state = JUMP
		velocity.y = JUMP_VELOCITY

	if state == JUMP: return
	
	if direction: velocity = direction * SWIM_SPEED
	else: velocity = Vector2.ZERO
	
func animation_state():
	var move_right = direction.x == 1
	var move_left = direction.x == -1
	var move_up = direction.y == -1
	var move_down = direction.y == 1

	if doDig: return
	
	if state != DIG && state != SWIM: 
		sprite.flip_v = false
		sprite.position.y = 0
		sprite.position.x = 0
		if digRotation != 0:
			sprite.rotate(-digRotation)
			digRotation = 0
		else:
			sprite.rotation = deg_to_rad(0)
	
	if move_up && state == CLIMB:
		keySprite.position.x = 0
		keySprite.position.y = 25
	elif move_down && state == CLIMB:
		keySprite.position.x = 0
		keySprite.position.y = -20
	elif move_down && state == DIG:
		sprite.flip_v = true
		sprite.position.y = 20
	elif move_right && state == DIG:
		if digRotation == 0: 
			digRotation = PI/2.0
			sprite.rotate(digRotation)
			sprite.position.x = 10
			sprite.position.y = 5
	elif move_left && state == DIG:
		if digRotation == 0:
			digRotation = -PI/2.0
			sprite.rotate(digRotation)	
			sprite.position.x = -10
			sprite.position.y = 5
	elif move_right: 
		sprite.flip_h = false
		if state == SWIM: sprite.flip_v = false
		keySprite.position.x = -20
		keySprite.position.y = 8
	elif move_left: 
		sprite.flip_h = true
		if state == SWIM: 
			sprite.flip_v = true
			sprite.flip_h = false
		keySprite.position.x = 20
		keySprite.position.y = 8		
	
	match state:
		MOVE:
			if direction.x == 0: animationPlayer.play("idle")
			else: animationPlayer.play("run")	
		CLIMB: 
			if direction == Vector2.ZERO: animationPlayer.stop(true)
			else: animationPlayer.play("climb")
		DIG: animationPlayer.play("climb")
		JUMP: animationPlayer.play("jump")
		CRAWL: animationPlayer.play("crawl")
		SWIM: sprite.rotation = deg_to_rad(90)

func stompAnimation():
	$stompSprite.visible = true
	enviromentAnimation.play("stomp")
	await get_tree().create_timer(0.5).timeout
	$stompSprite.visible = false	

func getShapeCollision():
	if !collision_check.is_colliding(): return null

	return collision_check.get_collider(0)

func getSideRayCollision():
	if collision_check_right.is_colliding() && Input.is_action_pressed("move_right"): return collision_check_right.get_collider()
	elif collision_check_left.is_colliding() && Input.is_action_pressed("move_left"): return collision_check_left.get_collider()
	
	return null


func interaction():
	var collision_object = getShapeCollision()
	
	var moveUp = Input.is_action_pressed("move_up")
	var moveDown = Input.is_action_pressed("move_down")
	var moveLeft = Input.is_action_pressed("move_left")
	var moveRight = Input.is_action_pressed("move_right")
	var cherries = LevelManager.cherries > 0;

	if collision_object is Door: doorInteraction(collision_object)
	
	if "dig" in get_tile_data("bottom") && moveDown: do_dig("bottom")
	elif "dig" in get_tile_data("top") && moveUp: do_dig("top")
	elif "dig" in get_tile_data("left") && moveLeft: do_dig("left")
	elif "dig" in get_tile_data("right") && moveRight: do_dig("right")
	elif "ramp" in get_tile_data("bottom") && moveDown:
		slideDirection = get_tile_data("bottom").replace("ramp", "")
		state = SLIDE
	elif moveUp && cherries && is_on_floor():
		activate_cherry_power()
		
func do_dig(digDirection):
	if state == DIG && !doDig:
		doDig = true
		var tilePosition = position
		
		if digDirection == "top":
			tilePosition -= TILE_ABOVE_ADJUSTMENT
		elif digDirection == "bottom":
			tilePosition -= TILE_UNDER_ADJUSTMENT
		elif digDirection == "left":
			tilePosition -= TILE_LEFT_ADJUSTMENT
		elif digDirection == "right": 
			tilePosition -= TILE_RIGHT_ADJUSTMENT
			
		await get_tree().create_timer(0.5).timeout
		tilePosition = levelTileMap.local_to_map(tilePosition)
		levelTileMap.set_cell(0, tilePosition, 0)
		doDig = false

func doorInteraction(collision_object):
	if collision_object.isClosed():
		if not hasKey: return
		hasKey = false
		collision_object.openDoor()
		
	if Input.is_action_just_pressed("move_up") && not switchDoors:
		$Camera2D/doorEffect.visible = true;
		enviromentAnimation.play("door");

		await get_tree().create_timer(0.6).timeout
		
		var newPosition = collision_object.getConnectionDoorPosition()
		$".".position.x = newPosition.x
		$".".position.y = newPosition.y
		

		enviromentAnimation.play_backwards("door");
	
		await get_tree().create_timer(0.7).timeout
		$Camera2D/doorEffect.visible = false;
	
func pickupKey():
	hasKey = true

func getPlayerDirection():
	return direction;

func followKey():
	if hasKey: keySprite.visible = true
	else: keySprite.visible = false

func mushroomJump(playerDirection):
	velocity.y = JUMP_VELOCITY * 2
	
	if playerDirection == "right":
		sprite.flip_h = false
		keySprite.position.x = 10
		forceVelocityX = 300
	else:
		sprite.flip_h = true
		forceVelocityX = -300
	
func move_and_check_climbing_object(newPlayerPosition):
	var space_state = get_world_2d().direct_space_state	
	var parameters = PhysicsShapeQueryParameters2D.new()
	var shape_rid = CircleShape2D.new()
	shape_rid.radius = 7

	parameters.collide_with_areas = true
	parameters.collide_with_bodies = false
	parameters.collision_mask = 1
	parameters.shape_rid = shape_rid.get_rid()
	parameters.transform.origin = newPlayerPosition
	
	var results = space_state.intersect_shape(parameters, 1)

	return !results.is_empty()	

func get_tile_data(direction : String = "", searchPosition = position):
	if levelTileMap == null: return ""
	
	var tileDirection = Vector2.ZERO

	if direction == "bottom":
		tileDirection = TILE_UNDER_ADJUSTMENT
	elif direction == "right":
		tileDirection = TILE_RIGHT_ADJUSTMENT
	elif direction == "left":
		tileDirection = TILE_LEFT_ADJUSTMENT
	elif direction == "top":
		tileDirection = TILE_ABOVE_ADJUSTMENT	
	
	var tilePos = levelTileMap.local_to_map(searchPosition - tileDirection)
	var tileData = levelTileMap.get_cell_tile_data(0, tilePos)

	if tileData:
		if tileData && tileData.get_custom_data("Floor") != "": 
			return tileData.get_custom_data("Floor")

		return "null"
	
	return ""

func activate_cherry_power():
	LevelManager.gain_cherries(-1)
	hasCerryPower = true
	enviromentAnimation.play("cherry_power")
	await get_tree().create_timer(CHERRY_POWER_TIME).timeout
	enviromentAnimation.stop()
	$Sprite2D.modulate = Color(1,1,1)
	hasCerryPower = false

func in_water():
		var tileData = get_tile_data()
		
		return "water" in tileData

func return_last_position():
	position = lastFloorPosition

func _canDig():
	var diggingUpOrDown = digging_object_above_or_below() && (Input.is_action_pressed("move_down") || Input.is_action_pressed("move_up"))
	var diggingLeftOrRight = digging_object_left_or_right() && (Input.is_action_pressed("move_left") || Input.is_action_pressed("move_right"))
	
	return diggingUpOrDown || diggingLeftOrRight
