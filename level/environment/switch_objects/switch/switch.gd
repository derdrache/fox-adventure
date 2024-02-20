extends Area2D
class_name Switch

@export var multiUse = false
@export var used = false

func _ready():
	if used: $Sprite2D.frame = 1
	
	
func _process(_delta):
	if used: $Sprite2D.frame = 1
	else: $Sprite2D.frame = 0

func _on_body_entered(body):
	if body is Player && not used:
		$Sprite2D.frame = 1
		
		$AudioStreamPlayer.play()
		if multiUse: used = !used
		else: used = true
		
