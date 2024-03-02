extends Area2D

@export var messageTexture : Texture
@export var messageTexture2 : Texture

func _ready():
	if messageTexture: 
		$ShortMessageBox.messageTexture = messageTexture
		$ShortMessageBox.messageTexture2 = messageTexture2

func _on_body_exited(body):
	if "Player" in body.name:
		$ShortMessageBox.visible = false


func _on_body_entered(body):
	if "Player" in body.name:
		$ShortMessageBox.visible = true
