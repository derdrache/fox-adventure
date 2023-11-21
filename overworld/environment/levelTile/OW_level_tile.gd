extends Area2D
class_name EnterLevelTile

@export var interactionBody : StaticBody2D
@export var levelDetails : LevelDetailsUI

var isComplete = false

func _process(_delta):
	if isComplete:
		if interactionBody != null: interactionBody.move()


func _on_body_entered(body):
	if body is PlayerOverworld && levelDetails:
		levelDetails.visible = true


func _on_body_exited(body):
	if body is PlayerOverworld && levelDetails:
		levelDetails.visible = false
