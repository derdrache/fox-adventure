extends CharacterBody2D
class_name Player

@onready var collision_check = $ShapeCast2D
@onready var collision_check_right = $RayCastRight
@onready var collision_check_left = $RayCastLeft
@onready var animationPlayer = $AnimationPlayer
@onready var sprite = $Sprite2D
@onready var keySprite = $key


@export var levelTileMap : TileMap

enum { MOVE , CLIMB , JUMP, STOMP, DIG, HANG, SLIDE}


const JUMP_VELOCITY = -300.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var state = MOVE
var cherry_counter = 0
var gem_counter = 0
var red_coin_counter = 0
var on_switch = false
var hasKey = false
var switchDoors = false
var direction = Vector2.ZERO
var doStomp = false
var forceVelocityX = 0
var doDig = false
var digRotation = 0
var hangBody = null
var sliderEndCounter = 30
var slideDirection = ""


func _process(_delta):
	interaction()
	followKey()

func _physics_process(delta):
	direction.x = Input.get_axis("move_left", "move_right")
	direction.y = Input.get_axis("move_up", "move_down")
	
	animation_state()
	
	match state:
		MOVE, JUMP: move_state(delta)
		CLIMB: climb_state(delta)
		DIG: dig_state()
		STOMP: stomp_state(delta)
		HANG: hang_state()
		SLIDE: slide_state(delta)
	
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
	
	return onLadder || onClimbingTree || onLiane || onClimbingPalm

func digging_object_above_or_below():
	var onDiggableGround = getShapeCollision() is DiggableGround
	
	return onDiggableGround

func digging_object_left_or_right():
	return collision_check_right.get_collider() is DiggableGround || collision_check_left.get_collider() is DiggableGround
		
func move_state(delta):
	const SPEED = 100.0
	var diggingUpOrDown = digging_object_above_or_below() && (Input.is_action_pressed("move_down") || Input.is_action_pressed("move_up"))
	var diggingLeftOrRight = digging_object_left_or_right() && (Input.is_action_pressed("move_left") || Input.is_action_pressed("move_right"))
	
	if is_on_climbing_object() && (Input.is_action_pressed("move_up") || Input.is_action_pressed("move_down") || (!is_on_floor() && state != JUMP)):
		state = CLIMB
	elif (diggingUpOrDown || diggingLeftOrRight)  && is_on_floor():
		doDig = true
		state = DIG
	elif is_on_floor():
		state = MOVE
		doStomp = false
	elif !is_on_floor():
		state = JUMP
	
	apply_gravity(delta);
	
		# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		state = JUMP
		velocity.y = JUMP_VELOCITY

	if not is_on_floor() && Input.is_action_just_pressed("move_down"):
		state = STOMP
		doStomp = true
	
	if direction && forceVelocityX == 0:
		velocity.x = direction.x * SPEED
	elif forceVelocityX != 0:
		velocity.x = forceVelocityX
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
func climb_state(delta):
	if !is_on_climbing_object():
		state = MOVE
	velocity = direction * 50
	var checkNextStep = move_and_check_climbing_object(position+ velocity * delta)
	
	if !checkNextStep: 
		if getShapeCollision() is Ladder:
			velocity.y = 0
		else:	
			velocity = Vector2.ZERO
	
	if Input.is_action_just_pressed("ui_accept"):
		state = JUMP
		velocity.y = JUMP_VELOCITY
		
func stomp_state(delta):
	if is_on_floor():
		state = MOVE
		$stompSprite.visible = true
		$AnimationPlayer2.play("stomp")
		await get_tree().create_timer(0.5).timeout
		$stompSprite.visible = false
		
	
	velocity.y += gravity*4 * delta

func dig_state():
	velocity = Vector2.ZERO
	
	if !doDig: state = MOVE
	
func hang_state():
	var hangSpeed = 20
	velocity = Vector2.ZERO
	
	if(Input.is_action_pressed("move_down")): 
		hangBody.stopHang()
		state = MOVE
	
	if direction && forceVelocityX == 0:
		velocity.x = direction.x * hangSpeed
	else:
		velocity.x = move_toward(velocity.x, 0, hangSpeed)
	
func slide_state(delta):
	
	
	if get_slide_information() == null: 
		sliderEndCounter -= 1
		
	velocity.y += gravity * delta * 10
	velocity.x = sliderEndCounter * 10
	
	if slideDirection == "Left":
		velocity.x = -velocity.x
	
	if sliderEndCounter == 0:
		state = MOVE
		sliderEndCounter = 30
	
func animation_state():
	var move_right = direction.x == 1
	var move_left = direction.x == -1
	var move_up = direction.y == -1
	var move_down = direction.y == 1
	
	if state != DIG: 
		sprite.flip_v = false
		sprite.position.y = 0
		sprite.position.x = 0
		if digRotation != 0:
			sprite.rotate(-digRotation)
			digRotation = 0
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
		keySprite.position.x = -20
		keySprite.position.y = 8
	elif move_left: 
		sprite.flip_h = true
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

func getShapeCollision():
	if !collision_check.is_colliding(): return null

	return collision_check.get_collider(0)

func getSideRayCollision():
	if collision_check_right.is_colliding() && Input.is_action_pressed("move_right"): return collision_check_right.get_collider()
	elif collision_check_left.is_colliding() && Input.is_action_pressed("move_left"): return collision_check_left.get_collider()
	
	return null


func interaction():
	var collision_object = getShapeCollision()
	var collisionObjectSide = getSideRayCollision()
	var sideMove = Input.is_action_pressed("move_left") || Input.is_action_pressed("move_right")
	var horizontalMove = Input.is_action_pressed("move_down") || Input.is_action_pressed("move_up")
	
	if collision_object is Switch: use_switch(collision_object)
	elif collision_object is Door: doorInteraction(collision_object)
	elif collision_object is Key: pickupKey(collision_object)
	elif collision_object is Chest: chestInteraction(collision_object)
	else: on_switch = false
	
	if collisionObjectSide is TreeStomp: move_tree_stomp(collisionObjectSide)
	if collisionObjectSide is DiggableGround && sideMove: do_dig(collisionObjectSide)
	elif collision_object is DiggableGround && horizontalMove: do_dig(collision_object)
	
	if get_slide_information() != null && Input.is_action_pressed("move_down"):
		slideDirection = get_slide_information().replace("ramp", "")
		state = SLIDE
	

func use_switch(collision_object):
	if on_switch: return

	collision_object.change_status()
	on_switch = true

func move_tree_stomp(collision_object):
	if (Input.is_action_pressed("move_right") || Input.is_action_pressed("move_left")) && !Input.is_action_pressed("ui_accept"): 
		collision_object.move(direction)
	else:
		collision_object.move(Vector2.ZERO)

func do_dig(collision_object):
	if state == DIG:
		doDig = await collision_object.digAway()

func doorInteraction(collision_object):
	if collision_object.isClosed():
		if not hasKey: return
		hasKey = false
		collision_object.openDoor()
		
	if Input.is_action_just_pressed("move_up") && not switchDoors:
		var newPosition = collision_object.getConnectionDoorPosition()
		$".".position.x = newPosition.x
		$".".position.y = newPosition.y
	
func pickupKey(collision_object):
	hasKey = true
	collision_object.delete()

func chestInteraction(collision_object):
	var opened = await collision_object.openChest()
	var withKey = collision_object.withKey
	
	if opened && withKey: hasKey = true

func getPlayerDirection():
	return direction;

func followKey():
	if hasKey: keySprite.visible = true
	else: keySprite.visible = false

func mushroomJump(playerDirection):
	velocity.y = JUMP_VELOCITY *2
	
	if playerDirection == "right":
		sprite.flip_h = false
		keySprite.position.x = 10
		forceVelocityX = 200
	else:
		sprite.flip_h = true
		forceVelocityX = -200

func hold_on_object(body):
	hangBody = body
	state = HANG
	
func move_and_check_climbing_object(newPlayerPosition):
	var space_state = get_world_2d().direct_space_state	
	var parameters = PhysicsShapeQueryParameters2D.new()
	var shape_rid = CircleShape2D.new()
	shape_rid.radius = 5

	parameters.collide_with_areas = true
	parameters.collide_with_bodies = false
	parameters.collision_mask = 1
	parameters.shape_rid = shape_rid.get_rid()
	parameters.transform.origin = newPlayerPosition
	
	var results = space_state.intersect_shape(parameters, 1)

	return !results.is_empty()

func get_slide_information():
	var tilePos = levelTileMap.local_to_map(position - Vector2(0, -25))
	var tileData = levelTileMap.get_cell_tile_data(0, tilePos)

	if tileData:
		if "ramp" in tileData.get_custom_data("Floor"):
			return tileData.get_custom_data("Floor")
	
	return 
