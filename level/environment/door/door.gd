extends Area2D
class_name Door

@export var closed = false
@export var conectionDoor : Area2D
@onready var doorSprite = $Sprite2D

var playerBody

func _process(_delta):
	if closed: doorSprite.frame = 0
	elif not closed: doorSprite.frame = 1
	
func _input(event):	
	if event.is_action_pressed("move_up") && not closed:
		if playerBody == null: return
		
		playerBody.position = conectionDoor.global_position 
	
	
func _on_body_entered(body):
	if body is Player:
		playerBody = body
		
		if closed && body.hasKey: 
			closed = false
			body.hasKey = false
			
			
func _on_body_exited(body):
	playerBody = null




