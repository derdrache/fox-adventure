extends Control

@onready var messageContainer = $MessageContainer
@onready var messageIconContainer = $MarginContainer

@export var messageTexture : Texture
@export var messageTexture2 : Texture

func _process(delta):
	if messageTexture: $MarginContainer/VBoxContainer/TextureRect.texture = messageTexture
	if messageTexture2:
		$MarginContainer.position.y = -29
		$MarginContainer/VBoxContainer/TextureRect2.texture = messageTexture2
		$MarginContainer/VBoxContainer/TextureRect2.visible = true
		
		$MessageContainer.visible = false
		$MessageContainer2.visible = true

func flip_box(boolean):
	messageContainer.scale.x *= -1
	
	if boolean:
		messageContainer.position.x = 10
		messageIconContainer.position.x = -45
			
		
