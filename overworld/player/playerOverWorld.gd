extends CharacterBody2D
class_name PlayerOverworld

@onready var rayCastDown = $rayCastDown
@onready var rayCastUp = $rayCastUp
@onready var rayCastRight = $rayCastRight
@onready var rayCastLeft = $rayCastLeft
@onready var rayCastLevel = $rayCastLevel
@onready var levelTileMap = get_node("../World1/TileMap")

@export var blockMovement = false

const SPEED = 70
const DIALOG_LINES: Array[String] = [
	"Oh Wow",
	"Ich kann sprechen!",
]
const TILE_ABOVE_ADJUSTMENT = Vector2(0, 0)	
const TILE_UNDER_ADJUSTMENT = Vector2(0,-24)
const TILE_LEFT_ADJUSTMENT = Vector2(16, -16)
const TILE_RIGHT_ADJUSTMENT = Vector2(-16, -16)

var movePathDirection = ""
var playerPosition = Vector2.ZERO
var playerStartPosition = Vector2.ZERO
var nextTarget = ""
var moveTileRight = false
var moveTileLeft = false
var moveTileUp = false
var moveTileDown = false

func _ready():
	pass
	
func _process(_delta):
	enterLevel()

func _physics_process(delta):
	moveTileRight = "move" in get_tile_data("right")
	moveTileLeft = "move" in get_tile_data("left")
	moveTileUp = "move" in get_tile_data("up")
	moveTileDown = "move" in get_tile_data("down")

	if blockMovement: return


	
	playerPosition = position
	var moveUp = Input.is_action_just_pressed("move_up")
	var moveDown = Input.is_action_just_pressed("move_down")
	var moveRight = Input.is_action_just_pressed("move_right")
	var moveLeft = Input.is_action_just_pressed("move_left")

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
		
	movePath(delta)
	move_and_slide()
	
func get_tile_data(direction : String = "", searchPosition = position):
	var tileDirection = Vector2.ZERO
	

	if direction == "down":
		tileDirection = TILE_UNDER_ADJUSTMENT
	elif direction == "right":
		tileDirection = TILE_RIGHT_ADJUSTMENT
	elif direction == "left":
		tileDirection = TILE_LEFT_ADJUSTMENT
	elif direction == "up":
		tileDirection = TILE_ABOVE_ADJUSTMENT
	
	var tilePos = levelTileMap.local_to_map(searchPosition - tileDirection)
	var tileData : TileData = levelTileMap.get_cell_tile_data(3, tilePos)
	
	if tileData:
		if tileData.get_custom_data("Floor") == "": 
			var tileDataSecret = levelTileMap.get_cell_tile_data(0, tilePos)
			if tileDataSecret && tileDataSecret.get_custom_data("Floor") != "":
				return tileDataSecret.get_custom_data("Floor")
				
			return "null"
		return tileData.get_custom_data("Floor")
	
	return ""

func enterLevel():
	var activeDialog = DialogManager.isDialogActive
	
	if movePathDirection == "" && Input.is_action_just_pressed("ui_accept") && !activeDialog:
		var levelName = rayCastLevel.get_collider().name
		levelName = "test_room" # testZeile
		var levelPath = "res://level/" + levelName + ".tscn"
		get_tree().change_scene_to_file(levelPath)

func movePath(_delta):
	var pixelSize = 16
	
	if movePathDirection == "": 
		$AnimationPlayer.play("idle")
		return
		
	
	
	$AnimationPlayer.play("run")
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
		
		if nextTarget is EnterLevelTile: 
			nextTarget = ""
			return
		
		if moveTileUp && oldMoveDirection != "down":
			movePathDirection = "up"
			nextTarget = rayCastUp.get_collider()
		elif moveTileDown && oldMoveDirection != "up":
			movePathDirection = "down"
			nextTarget = rayCastDown.get_collider()
		elif moveTileRight && oldMoveDirection != "left":
			movePathDirection = "right"
			nextTarget = rayCastRight.get_collider()
		elif moveTileLeft && oldMoveDirection != "right":
			movePathDirection = "left"
			nextTarget = rayCastLeft.get_collider()

func _unhandled_input(event):
	if event.is_action_pressed("move_up"):
		DialogManager.start_dialog(global_position, DIALOG_LINES)
