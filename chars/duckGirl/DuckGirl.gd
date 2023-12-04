extends StaticBody2D

@export var flipH = false

func _ready():
	$Sprite2D.flip_h = flipH

