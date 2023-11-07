extends Area2D
class_name Door

@export var closed = false
@export var conectionDoor = Door
@onready var doorSprite = $Sprite2D

func _process(_delta):
	if closed: doorSprite.frame = 0
	elif not closed: doorSprite.frame = 1
	
func isClosed():
	return closed

func openDoor():
	closed = false
	
func getConnectionDoorPosition():
	var conectionDoorPosition = conectionDoor.position 
	return conectionDoorPosition
