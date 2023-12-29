extends Path2D
class_name Eagle

@onready var animationPlayer = $PathFollow2D/eagleBody/AnimationPlayer
@onready var path_follow = $PathFollow2D
@onready var eagleBody = $PathFollow2D/eagleBody
@onready var eagleSprite = $PathFollow2D/eagleBody/Sprite2D
@onready var sleepText = $PathFollow2D/eagleBody/RichTextLabel

@export var isActive = true
@export var flip_h = false


const MOVE_SPEED = 100

var move = false
var playerBody : CharacterBody2D
var ridePosition = Vector2.ZERO

func _ready():
	if flip_h: 
		eagleSprite.flip_h = true
		ridePosition.x = 5
	
	if isActive:
		animationPlayer.play("idle")
	else:
		sleepText.visible = true
		eagleSprite.frame = 1


func _physics_process(delta):
	if !move && path_follow.progress > 0 && playerBody == null: 
		resetPosition(delta)
	
	if move && playerBody != null: 
		path_follow.progress += MOVE_SPEED * delta
		var newPosition = eagleBody.global_position
		newPosition += ridePosition
		playerBody.position = newPosition
		
	if path_follow.progress_ratio == 1: 
		move = false
	
func resetPosition(delta):
	path_follow.progress -= MOVE_SPEED * delta
	
func _on_area_top_body_entered(body):
	if body is Player && isActive:
		body.onMoveableObject = true
		ridePosition.y = -10
		playerBody = body
		move = true

func _on_area_top_body_exited(body):
	if body is Player && isActive:
		body.onMoveableObject = false
		move = false
		playerBody = null

func _on_area_bottom_body_entered(body):
	if body is Player && isActive:
		body.onMoveableObject = true
		playerBody = body
		move = true
		ridePosition.y = 10

func _on_area_bottom_body_exited(body):
	if body is Player && isActive: 
		body.onMoveableObject = false
		move = false
		playerBody = null


