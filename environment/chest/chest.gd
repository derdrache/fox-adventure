extends Area2D
class_name Chest

@export var withKey = false

var opened = false

func openChest():
	if opened: return false
	
	opened = true
	$Sprite2D.frame = 1
	
	if withKey: 
		$keySprite.visible = true
		await get_tree().create_timer(0.5).timeout
		$keySprite.visible = false
		

	return true
