extends Path2D
class_name Eagle

@onready var animationPlayer = $PathFollow2D/eagleBody/AnimationPlayer
@onready var path_follow = $PathFollow2D
@onready var eagleBody = $PathFollow2D/eagleBody
@onready var eagleSprite = $PathFollow2D/eagleBody/Sprite2D
@onready var sleepText = $PathFollow2D/eagleBody/RichTextLabel

@export var isActive = true
@export var flipH = false


const MOVE_SPEED = 100

var move = false
var playerBody : CharacterBody2D
var enteredBottom = false

func _ready():
	if flipH: eagleSprite.flip_h = true
	
	if isActive:animationPlayer.play("idle")
	else:
		sleepText.visible = true
		eagleSprite.frame = 1


func _physics_process(delta):
	
	_resetPosition(delta)
	
	_moving(delta)
		
	_release()
	
func _resetPosition(delta):
	if !move && path_follow.progress > 0 && playerBody == null: 
		path_follow.progress -= MOVE_SPEED * delta
	
func _moving(delta):	
	if move && playerBody != null: 
		var ridePosition = Vector2(
			5 if flipH else 0, 
			5 if enteredBottom else -10)
		
		path_follow.progress += MOVE_SPEED * delta
		var newPosition = eagleBody.global_position
		newPosition += ridePosition
		playerBody.position = newPosition

func _release():
	var pressRealseButtons = (Input.is_action_pressed("ui_accept") 
		|| Input.is_action_pressed("move_down"))
	var pathAllowed = path_follow.progress_ratio > 0.2	
	
	if enteredBottom && pressRealseButtons && pathAllowed: move = false
	elif !enteredBottom && path_follow.progress_ratio == 1: move = false
		
func _on_area_top_body_entered(body):
	if body is Player && isActive:
		playerBody = body
		body.movingObjectSpeed = MOVE_SPEED
		move = true
		enteredBottom = false

func _on_area_top_body_exited(body):
	if body is Player && isActive:
		move = false
		playerBody = null
		body.movingObjectSpeed = null

func _on_area_bottom_body_entered(body):
	if body is Player && isActive:
		playerBody = body
		body.movingObjectSpeed = MOVE_SPEED
		move = true
		enteredBottom = true

func _on_area_bottom_body_exited(body):
	if body is Player && isActive: 
		move = false
		playerBody = null
		body.movingObjectSpeed = null


