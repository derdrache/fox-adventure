extends Control

@onready var messageContainer = $MessageContainer
@onready var messageIconContainer = $MarginContainer

@export var messageTexture : Texture


func _process(delta):
	if messageTexture: $MarginContainer/VBoxContainer/TextureRect.texture = messageTexture

func flip_box(boolean):
	messageContainer.scale.x *= -1
	
	if boolean:
		messageContainer.position.x = 10
		messageIconContainer.position.x = -45
			
		
