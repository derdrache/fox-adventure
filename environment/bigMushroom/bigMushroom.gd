extends StaticBody2D

@export var flipH = false
@export var flipV = false


func _ready():
	if flipH: $Sprite2D.flip_h = true
	if flipV: $Sprite2D.flip_v = true


func _on_area_2d_body_entered(body):
	if body is Player:
		var direction = "right"
		if $Sprite2D.flip_h: direction = "left"
		body.mushroomJump(direction)
