extends StaticBody2D

@export var flipH = false

var showBranche = true


func _ready():
	$Sprite2D.flip_h = flipH

func _process(delta):
	var parentIsSwitch = HelperFunctions.arentIsSwitch(get_parent())
	if parentIsSwitch: showBranche = get_parent().used
	
	if showBranche:
		$Sprite2D.modulate.a = 1
		$CollisionShape2D.disabled = false
	else:
		$Sprite2D.modulate.a = 0.3
		$CollisionShape2D.disabled = true
