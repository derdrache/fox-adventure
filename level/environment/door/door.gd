extends Area2D
class_name Door

@export var closed = false
@export var conectionDoor : Area2D
@onready var doorSprite = $Sprite2D
var playerIn = false

var playerBody: Player

func _process(_delta):
	if closed: doorSprite.frame = 0
	elif not closed: doorSprite.frame = 1
	
func _input(event):	
	if (event.is_action_pressed("move_up") || event.is_action_pressed("ui_accept")) && not closed && playerIn:
		if !playerBody.is_physics_processing(): return
		
		playerBody.circle_transition("out", 1)
		playerBody.set_physics_process(false)
		await get_tree().create_timer(1).timeout
		playerBody.global_position = conectionDoor.global_position 
		playerBody.circle_transition("in", 1)
		await get_tree().create_timer(1).timeout
		playerBody.set_physics_process(true)
	
func _on_body_entered(body):
	if body is Player:
		playerBody = body
		playerIn = true
		if closed && body.hasKey: 
			closed = false
			body.hasKey = false	
			$AudioStreamPlayer.play()
		elif closed: $ShortMessageBox.visible = true
			
func _on_body_exited(body):
	if body is Player:
		playerIn = false
		$ShortMessageBox.visible = false
