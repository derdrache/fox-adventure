extends CharacterBody2D
class_name PlayerOverworld

@onready var rayCastDown = $rayCastDown
@onready var rayCastUp = $rayCastUp
@onready var rayCastRight = $rayCastRight
@onready var rayCastLeft = $rayCastLeft
@onready var rayCastLevel = $rayCastLevel

@export var blockMovement = false

const SPEED = 70
const DIALOG_LINES: Array[String] = [
	"Oh Wow",
	"Ich kann sprechen!",
]

var movePathDirection = ""
var playerPosition = Vector2.ZERO
var playerStartPosition = Vector2.ZERO
var nextTarget = ""

func _ready():
	pass
	
func _process(_delta):
	enterLevel()

func _physics_process(delta):
	if blockMovement: return
	
	playerPosition = position
	var moveUp = Input.is_action_just_pressed("move_up")
	var moveDown = Input.is_action_just_pressed("move_down")
	var moveRight = Input.is_action_just_pressed("move_right")
	var moveLeft = Input.is_action_just_pressed("move_left")

	if moveUp && rayCastUp.is_colliding() && movePathDirection == "":
		movePathDirection = "up"
		playerStartPosition = position
	elif moveDown && rayCastDown.is_colliding() && movePathDirection == "":	
		movePathDirection = "down"
		playerStartPosition = position
	elif moveRight && rayCastRight.is_colliding() && movePathDirection == "":	
		movePathDirection = "right"
		playerStartPosition = position
	elif moveLeft && rayCastLeft.is_colliding() && movePathDirection == "":	
		movePathDirection = "left"
		playerStartPosition = position
		
	movePath(delta)
	move_and_slide()
	

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
		
		if rayCastUp.is_colliding() && oldMoveDirection != "down":
			movePathDirection = "up"
			nextTarget = rayCastUp.get_collider()
		elif rayCastDown.is_colliding() && oldMoveDirection != "up":
			movePathDirection = "down"
			nextTarget = rayCastDown.get_collider()
		elif rayCastRight.is_colliding() && oldMoveDirection != "left":
			movePathDirection = "right"
			nextTarget = rayCastRight.get_collider()
		elif rayCastLeft.is_colliding() && oldMoveDirection != "right":
			movePathDirection = "left"
			nextTarget = rayCastLeft.get_collider()

func _unhandled_input(event):
	if event.is_action_pressed("move_up"):
		DialogManager.start_dialog(global_position, DIALOG_LINES)
