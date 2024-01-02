extends CharacterBody2D
class_name Player

@onready var collision_check : ShapeCast2D = $ShapeCast2D
@onready var collision_check_right = $RayCastRight
@onready var collision_check_left = $RayCastLeft
@onready var playerAnimation = $AnimatedSprite2D
@onready var enviromentAnimation = $enviromentAnimation
@onready var sprite = $AnimatedSprite2D
@onready var keySprite = $key
@onready var normalCollider = $normalCollision
@onready var crawlCollider = $crawlCollision
@onready var climbCollider = $climbCollision
@onready var levelTileMap : TileMap = get_node("../TileMap")


enum { MOVE , CLIMB , JUMP, STOMP, DIG, HANG, SLIDE, CRAWL, SWIM}

const SPEED = 100.0
const SWIM_SPEED = 125
const JUMP_VELOCITY = -300.0
const TILE_ABOVE_ADJUSTMENT = Vector2(0, 10)	
const TILE_UNDER_ADJUSTMENT = Vector2(0,-20)
const TILE_LEFT_ADJUSTMENT = Vector2(8, -2)
const TILE_RIGHT_ADJUSTMENT = Vector2(-8, -2)

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var state = MOVE
var hasKey = false
var switchDoors = false
var direction = Vector2.ZERO
var forceVelocityX = 0
var doDig = false
var digRotation = 0
var sliderEndCounter = 30
var underWater = false
var lastFloorPosition = Vector2.ZERO
var lastFloorFlipH = false
var onMoveableObject = false
var pressedLeft = false
var pressedRight = false
var pressedUp = false
var pressedDown = false
var climbSideways = false
var doStomp = false


func _ready():
	$MobileControlUi.visible = true
	$LevelUI.visible = true

func _process(_delta):
	underWater = "water" in get_tile_data()
	
	interaction()
	followKey()

func _physics_process(delta):
	if is_on_floor() && !onMoveableObject:
		doStomp = false
		lastFloorFlipH = sprite.flip_h
		lastFloorPosition = position
	
	direction.x = Input.get_axis("move_left", "move_right")
	if direction.x == 0: direction.x = Input.get_axis("touch_left_down", "touch_right_down")
	if direction.x == 0: direction.x = Input.get_axis("touch_left_up", "touch_right_up")
	
	direction.y = Input.get_axis( "move_up", "move_down")
	if direction.y == 0: direction.y = Input.get_axis("touch_left_up" , "touch_left_down")
	if direction.y == 0: direction.y = Input.get_axis("touch_right_up" , "touch_right_down")
	
	pressedLeft = direction.x == -1
	pressedRight = direction.x == 1
	pressedUp = direction.y == -1
	pressedDown = direction.y == 1
	
	match state:
		MOVE, JUMP, CRAWL: move_state(delta)
		SWIM: swim_state(delta)
		CLIMB: climb_state(delta)
		DIG: dig_state()
		STOMP: stomp_state(delta)
		SLIDE: slide_state(delta)
	
	animation_state()
	
	_change_collider()

	move_and_slide()
	
	
	if is_on_floor():
		forceVelocityX = 0


func apply_gravity(delta):
		if not is_on_floor():
			velocity.y += gravity * delta

func is_on_climbing_object():
	var collisionObjectName = ""
	if getShapeCollision() != null: collisionObjectName = getShapeCollision().name

	var onClimbingObject = "Climb" in collisionObjectName
	var onLiane = getShapeCollision() is Liane
	var onWall = "climb" in get_tile_data("right") || "climb" in get_tile_data("left")
	
	return onClimbingObject || onLiane || onWall

func digging_object_above_or_below():	
	return "dig" in get_tile_data("top")|| "dig" in get_tile_data("bottom")

func digging_object_left_or_right():
	return "dig" in get_tile_data("left")|| "dig" in get_tile_data("right")
		
func move_state(delta):
	var moveSpeed = SPEED
	
	if underWater: moveSpeed = SWIM_SPEED
	elif state == CRAWL: moveSpeed = moveSpeed / 2
	
	
	var diggingUpOrDown = digging_object_above_or_below() && (pressedDown || pressedUp)
	var diggingLeftOrRight = digging_object_left_or_right() && (pressedLeft || pressedRight)
	
	
	if (pressedDown || _cant_stand_up()):
		state = CRAWL
	elif _can_and_do_climb():
		state = CLIMB
	elif _can_dig()  && is_on_floor() && !doDig:
		state = DIG
	elif in_water() && !is_on_floor():
		state = SWIM
	elif is_on_floor():
		state = MOVE
	elif !is_on_floor():
		state = JUMP
	
	apply_gravity(delta);
	
	
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		if state != CRAWL: state = JUMP
		velocity.y = JUMP_VELOCITY

	if not is_on_floor() && Input.is_action_just_pressed("move_down"):
		state = STOMP
	
	if direction && forceVelocityX == 0:
		velocity.x = direction.x * moveSpeed
	elif forceVelocityX != 0:
		velocity.x = forceVelocityX
	else:
		velocity.x = move_toward(velocity.x, 0, moveSpeed)

func climb_state(delta):
	velocity = direction * 50

	var nextStepIsClimbableOnTree = _check_next_climbstep_on_tree(
		position+ (velocity*2 * delta))
	var nextStepIsClimableOnClimgTiles = _check_next_climbstep_on_tiles(
		position+ (velocity*2 * delta))
	
	var canClimb = nextStepIsClimbableOnTree || nextStepIsClimableOnClimgTiles
	
	if is_on_floor(): 
		state = MOVE
		
	if !canClimb: velocity = Vector2.ZERO
	
	if climbSideways: direction.x = 0
	
	if Input.is_action_just_pressed("ui_accept"):
		state = JUMP
		velocity.y = JUMP_VELOCITY
		
	if _can_dig():
		state = DIG
		
func stomp_state(delta):
	doStomp = true
	
	if is_on_floor():
		state = MOVE
		stompAnimation()
	elif in_water():
		state = SWIM
		
	velocity.y += gravity*4 * delta

func dig_state():
	velocity = Vector2.ZERO
	
	if !doDig: state = MOVE
	
func slide_state(delta):
	if in_water(): state = MOVE
	
	if not "ramp" in get_tile_data("bottom"): 
		sliderEndCounter -= 1
		
	velocity.y += gravity * delta * 10
	velocity.x = sliderEndCounter * 10
	
	if get_tile_data("bottom").replace("ramp", "")  == "Left":
		velocity.x = -velocity.x
	
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		state = JUMP
		velocity.y = JUMP_VELOCITY * 1.5
	
	if sliderEndCounter == 0:
		state = MOVE
		sliderEndCounter = 30

func swim_state(_delta):
	if !in_water() || (!in_water() && is_on_floor()): state = MOVE
	
	var diggingUpOrDown = digging_object_above_or_below() && (pressedDown || pressedUp)
	var diggingLeftOrRight = digging_object_left_or_right() && (pressedLeft || pressedRight)

	if diggingUpOrDown || diggingLeftOrRight:
		state = DIG
	
	if "waterTop" in get_tile_data() && Input.is_action_just_pressed("ui_accept"):
		state = JUMP
		velocity.y = JUMP_VELOCITY

	if state == JUMP: return
	
	if !("water" in get_tile_data("top", "customData", position - Vector2(0, -8))) && pressedUp:
		velocity = Vector2.ZERO
	elif direction: velocity = direction * SWIM_SPEED
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
		keySprite.position.x = 20
		keySprite.position.y = 8		
	
	match state:
		MOVE:
			if direction.x == 0: playerAnimation.play("idle")
			else: playerAnimation.play("run")	
		CLIMB: 
			if direction == Vector2.ZERO: playerAnimation.stop()
			elif climbSideways: playerAnimation.play("climbSideways")
			else: playerAnimation.play("climb")
		DIG: playerAnimation.play("climb")
		JUMP: playerAnimation.play("jump")
		CRAWL: playerAnimation.play("crawl")
		SWIM: playerAnimation.play("swim")

func stompAnimation():
	$stompSprite.visible = true
	enviromentAnimation.play("stomp")
	await get_tree().create_timer(0.5).timeout
	$stompSprite.visible = false	

func getShapeCollision():
	if !collision_check.is_colliding(): return null
	return collision_check.get_collider(0)

func getSideRayCollision():
	if collision_check_right.is_colliding() && pressedRight: 
		return collision_check_right.get_collider()
	elif collision_check_left.is_colliding() && pressedLeft: 
		return collision_check_left.get_collider()
	
	return null


func interaction():
	var collision_object = getShapeCollision()
	
	if collision_object is Door: doorInteraction(collision_object)
	
	if "dig" in get_tile_data("bottom") && pressedDown: do_dig("bottom")
	elif "dig" in get_tile_data("top") && pressedUp: do_dig("top")
	elif "dig" in get_tile_data("left") && pressedLeft: do_dig("left")
	elif "dig" in get_tile_data("right") && pressedRight: do_dig("right")
	elif "ramp" in get_tile_data("bottom") && pressedDown: state = SLIDE
		
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
		#$Camera2D/doorEffect.visible = true;
		enviromentAnimation.play("door");

		#await get_tree().create_timer(0.6).timeout
		
		var newPosition = collision_object.getConnectionDoorPosition()
		$".".position.x = newPosition.x
		$".".position.y = newPosition.y
		

		enviromentAnimation.play_backwards("door");
	
		#await get_tree().create_timer(0.7).timeout
		#$Camera2D/doorEffect.visible = false;
	
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
	
func _check_next_climbstep_on_tree(newPlayerPosition):
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

func _check_next_climbstep_on_tiles(newPlayerPosition):
	var climbSideway = ("climbSideway" in get_tile_data("left","customData", position) 
		|| "climbSideway" in get_tile_data("right","customData", position))

	if climbSideway:
		climbSideways = true
		var canClimbLeft = "climb" in get_tile_data("left","customData", newPlayerPosition)
		var canClimbRight = "climb" in get_tile_data("right","customData", newPlayerPosition)
		return canClimbLeft || canClimbRight
	else: 
		climbSideways = false
		return "climb" in get_tile_data("","customData", newPlayerPosition)


func get_tile_data(direction : String = "", 
	dataType = "customData",  searchPosition = position):
		
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
	var tileData : TileData = levelTileMap.get_cell_tile_data(0, tilePos)
	
	if dataType == "customData": 
		
		if tileData:
			if tileData && tileData.get_custom_data("Floor") != "": 
				return tileData.get_custom_data("Floor")

			return "null"
		
		return ""
	elif dataType == "collision":
		if tileData : return tileData.get_collision_polygons_count(0)
		#return tileData

func in_water():
		var tileData = get_tile_data()
		
		return "water" in tileData

func return_last_position():
	var lastPosition = lastFloorPosition
	if lastFloorFlipH: lastPosition.x += 10
	else: lastPosition.x -= 10

	position = lastPosition

func _can_dig():
	var diggingUpOrDown = digging_object_above_or_below() && (pressedDown || pressedUp)
	var diggingLeftOrRight = digging_object_left_or_right() && (pressedLeft || pressedRight)
	
	return (diggingUpOrDown || diggingLeftOrRight) && !doDig

func _can_and_do_climb():
	#return (is_on_climbing_object() && (pressedUp || (pressedDown && not is_on_floor()) || (!is_on_floor() && state != JUMP)))
	return is_on_climbing_object() && (pressedUp || (pressedDown && not is_on_floor()))

func _cant_stand_up():
	return state == CRAWL && (get_tile_data("top", "collision") == 1 
		|| get_tile_data("top",  "collision", position - TILE_RIGHT_ADJUSTMENT) == 1 
		|| get_tile_data("top",  "collision", position - TILE_LEFT_ADJUSTMENT) == 1)

func _change_collider():
	match state:
		MOVE, JUMP, SWIM: 
			normalCollider.disabled = false
			crawlCollider.disabled = true
			climbCollider.disabled = true
		CRAWL:
			normalCollider.disabled = true
			crawlCollider.disabled = false
			climbCollider.disabled = true
		CLIMB:
			normalCollider.disabled = true
			crawlCollider.disabled = true
			climbCollider.disabled = false
