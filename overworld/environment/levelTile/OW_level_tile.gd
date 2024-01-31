extends Area2D
class_name EnterLevelTile

@export var levelDetails : Control


func _on_body_entered(body):
	if body is PlayerOverworld && levelDetails:
		levelDetails.visible = true


func _on_body_exited(body):
	if body is PlayerOverworld && levelDetails:
		levelDetails.visible = false
