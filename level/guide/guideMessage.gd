extends Node2D

@export var messageTexture : Texture

func _ready():
	if messageTexture: 
		$ShortMessageBox.messageTexture = messageTexture


func _on_area_2d_body_entered(body):
	if "Player" in body.name:
		$ShortMessageBox.visible = true


func _on_area_2d_body_exited(body):
	if "Player" in body.name:
		$ShortMessageBox.visible = false
