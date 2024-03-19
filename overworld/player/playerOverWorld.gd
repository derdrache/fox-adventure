extends CharacterBody2D
class_name PlayerOverworld

@onready var worldTileMap = get_node("../TileMap")

@export var blockMovement = false

const SPEED = 70
const TILE_ABOVE_ADJUSTMENT = Vector2(0, 12)	
const TILE_UNDER_ADJUSTMENT = Vector2(0,-12)
const TILE_LEFT_ADJUSTMENT = Vector2(12, 0)
const TILE_RIGHT_ADJUSTMENT = Vector2(-12, 0)


var movePathDirection = ""
var playerPosition = Vector2.ZERO
var playerStartPosition = Vector2.ZERO
var moveTileRight = false
var moveTileLeft = false
var moveTileUp = false
var moveTileDown = false
var multiPath = false

func _ready():
	$BackgroundMusic.play()

func _physics_process(delta):
	moveTileRight = "move" in get_tile_data("right")
	moveTileLeft = "move" in get_tile_data("left")
	moveTileUp = "move" in get_tile_data("up")
	moveTileDown = "move" in get_tile_data("down")
	
	multiPath = [moveTileRight, moveTileLeft, moveTileUp, moveTileDown].count(true) >= 3
	
	if blockMovement: return
	
	playerPosition = position
	var moveUp = Input.is_action_pressed("move_up")
	var moveDown = Input.is_action_pressed("move_down")
	var moveRight = Input.is_action_pressed("move_right")
	var moveLeft = Input.is_action_pressed("move_left")

	if moveUp && moveTileUp && movePathDirection == "":
		movePathDirection = "up"
		playerStartPosition = position
	elif moveDown && moveTileDown && movePathDirection == "":	
		movePathDirection = "down"
		playerStartPosition = position
	elif moveRight && moveTileRight && movePathDirection == "":	
		movePathDirection = "right"
		playerStartPosition = position
	elif moveLeft && moveTileLeft && movePathDirection == "":	
		movePathDirection = "left"
		playerStartPosition = position

	if movePathDirection == "": 
		$AnimationPlayer.play("idle")
		return
	else: $AnimationPlayer.play("run")
	
	movePath(delta)
	
	var isColliding = move_and_slide()
	
	if isColliding: movePathDirection = ""
	
func get_tile_data(direction : String = "", layer = -1):
	var centerYtoFeed = -10
	var searchPosition = position - Vector2(0,centerYtoFeed)
	var tileDirection = Vector2.ZERO
	

	if direction == "down":
		tileDirection = TILE_UNDER_ADJUSTMENT
	elif direction == "right":
		tileDirection = TILE_RIGHT_ADJUSTMENT
	elif direction == "left":
		tileDirection = TILE_LEFT_ADJUSTMENT
	elif direction == "up":
		tileDirection = TILE_ABOVE_ADJUSTMENT
	
	var tilePos = worldTileMap.local_to_map(searchPosition - tileDirection)
	
	var tileLayer1 = worldTileMap.get_cell_tile_data(0, tilePos)
	var tileLayer2 = worldTileMap.get_cell_tile_data(4, tilePos)
	
	if layer > 0:
		var searchLayer = worldTileMap.get_cell_tile_data(layer, tilePos)
		if searchLayer && searchLayer.get_custom_data("Floor")!= "":
			return searchLayer.get_custom_data("Floor")
		
		return ""
	
	
	if tileLayer2 && tileLayer2.get_custom_data("Floor")!= "":
		return tileLayer2.get_custom_data("Floor")
	elif tileLayer1 && tileLayer1.get_custom_data("Floor")!= "":
		return tileLayer1.get_custom_data("Floor")
	else:
		return ""

func movePath(_delta):
	var pixelSize = 16
	
	if(movePathDirection == "up" && playerPosition.y > playerStartPosition.y - pixelSize):
		velocity.y = -1 * SPEED
	elif (movePathDirection == "down" && playerPosition.y < playerStartPosition.y + pixelSize): 
		velocity.y = 1 * SPEED 
	elif (movePathDirection == "right" && playerPosition.x < playerStartPosition.x + pixelSize): 
		velocity.x = 1 * SPEED
		$Sprite2D.flip_h = false
	elif (movePathDirection == "left" && playerPosition.x > playerStartPosition.x - pixelSize):
		velocity.x = -1 * SPEED
		$Sprite2D.flip_h = true
	else:
		velocity = Vector2.ZERO
		if(movePathDirection == "up"):
			playerStartPosition.y -= pixelSize
		elif (movePathDirection == "down"):
			playerStartPosition.y += pixelSize
		elif (movePathDirection == "right"):
			playerStartPosition.x += pixelSize
		elif (movePathDirection == "left"):
			playerStartPosition.x -= pixelSize
		
		position = playerStartPosition
		var oldMoveDirection  = movePathDirection
		movePathDirection = ""
		
		
		if "level" in get_tile_data("", 5) || multiPath: return

		if moveTileUp && oldMoveDirection != "down":
			movePathDirection = "up"
		elif moveTileDown && oldMoveDirection != "up":
			movePathDirection = "down"
		elif moveTileRight && oldMoveDirection != "left":
			movePathDirection = "right"
		elif moveTileLeft && oldMoveDirection != "right":
			movePathDirection = "left"

func set_control_ui(boolean):
	$MobileControlUi.visible = boolean
			
