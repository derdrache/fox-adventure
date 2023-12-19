extends StaticBody2D
class_name Eagle

@onready var animationPlayer = $AnimationPlayer
@onready var path_follow : PathFollow2D

@export var isActive = false
@export var lookRight = false


var move_speed = 100
var move = false
var playerBody : CharacterBody2D
var ridePosition = Vector2.ZERO

func _ready():
	if get_parent() is PathFollow2D: 
		path_follow = get_parent()
	
	if lookRight: 
		$Sprite2D.flip_h = true
		ridePosition.x = 5
	
	if isActive:
		animationPlayer.play("idle")
	else:
		$RichTextLabel.visible = true
		$Sprite2D.frame = 1


func _physics_process(delta):
	
	if path_follow == null: return
	
	if move: 
		path_follow.progress += move_speed * delta
		var newPosition = global_position
		newPosition += ridePosition
		playerBody.position = newPosition
		
	if path_follow.progress_ratio == 1: 
		move = false
		
	if !move && path_follow.progress > 0 && playerBody == null: 
		resetPosition(delta)

func resetPosition(delta):
	await get_tree().create_timer(2).timeout
	path_follow.progress -= move_speed * delta
	playerBody = null


func _on_area_top_body_entered(body):
	if body is Player && isActive:
		ridePosition.y = -10
		playerBody = body
		move = true

func _on_area_top_body_exited(body):
	if body is Player && isActive:
		move = false

func _on_area_bottom_body_entered(body):
	if body is Player && isActive:
		body.hold_on_object($".")
		playerBody = body
		move = true
		ridePosition.y = 10

func _on_area_bottom_body_exited(body):
	if body is Player && isActive: 
		move = false


