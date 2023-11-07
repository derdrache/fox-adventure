extends StaticBody2D
class_name Eagle

@onready var animationPlayer = $AnimationPlayer

@export var isActive = false
@onready var path_follow = get_parent()

var move_speed = 20
var move = false
var playerBody : CharacterBody2D
var hanging = false

func _ready():
	if isActive:
		animationPlayer.play("idle")
	else:
		$RichTextLabel.visible = true
		$Sprite2D.frame = 1


func _physics_process(delta):
	if move: 
		path_follow.progress += move_speed * delta
		var newPosition = global_position
		newPosition.y += 10
		if hanging: playerBody.position = newPosition

	if !move && path_follow.progress > 0: resetPosition()


func _on_area_top_body_entered(body):
	if body is Player && isActive:
		move = true

func _on_area_top_body_exited(body):
	if body is Player && isActive: move = false

func _on_area_bottom_body_entered(body):
	if body is Player && isActive:
		body.hold_on_object($".")
		playerBody = body
		move = true
		hanging = true

func _on_area_bottom_body_exited(body):
	hanging = false

func resetPosition():
	await get_tree().create_timer(2).timeout
	path_follow.progress =0	
	playerBody = null

func stopHang():
	move = false
